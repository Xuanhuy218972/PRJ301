package com.sportfield.controller.customer;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.sportfield.dao.BookingDAO;
import com.sportfield.dao.FieldSlotDAO;
import com.sportfield.dao.SportFieldDAO;
import com.sportfield.model.FieldSlot;
import com.sportfield.model.SportField;
import com.sportfield.utils.GeminiService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Controller for AI-powered booking assistant.
 * GET  /ai-booking       → Show chat UI
 * POST /ai-booking       → Process chat message via Gemini API, return JSON response
 */
@WebServlet(name = "AIBookingController", urlPatterns = {"/ai-booking"})
public class AIBookingController extends HttpServlet {

    private final SportFieldDAO fieldDAO = new SportFieldDAO();
    private final FieldSlotDAO slotDAO = new FieldSlotDAO();
    private final BookingDAO bookingDAO = new BookingDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/customer/ai-booking.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

        String userMessage = request.getParameter("message");
        if (userMessage == null || userMessage.trim().isEmpty()) {
            sendJsonResponse(response, false, "Vui lòng nhập tin nhắn!", null, null);
            return;
        }

        try {
            // Build context with available fields info
            String fieldsInfo = buildFieldsContext();
            String systemPrompt = GeminiService.buildSystemPrompt(fieldsInfo);

            // Call Gemini API
            String aiResponse = GeminiService.chat(userMessage.trim(), systemPrompt);

            if (aiResponse == null) {
                sendJsonResponse(response, false,
                        "Xin lỗi, AI đang bận. Vui lòng thử lại sau hoặc sử dụng chức năng tìm kiếm thủ công.",
                        null, null);
                return;
            }

            // Parse AI response to get structured intent
            JsonObject intent = GeminiService.parseBookingIntent(aiResponse);

            if (intent == null) {
                // AI responded but not in expected JSON format - return raw response
                sendJsonResponse(response, true, aiResponse, null, null);
                return;
            }

            String intentType = intent.has("intent") ? intent.get("intent").getAsString() : "CHAT";
            String aiMessage = intent.has("response") ? intent.get("response").getAsString() : aiResponse;

            if ("SEARCH".equals(intentType)) {
                // Extract search parameters
                String dateStr = intent.has("date") ? intent.get("date").getAsString() : "";
                String fieldTypeStr = intent.has("fieldType") ? intent.get("fieldType").getAsString() : "";
                String timeRange = intent.has("timeRange") ? intent.get("timeRange").getAsString() : "ALL";

                if (dateStr.isEmpty()) {
                    sendJsonResponse(response, true, aiMessage, null, null);
                    return;
                }

                LocalDate searchDate = LocalDate.parse(dateStr);

                // Don't search for past dates
                if (searchDate.isBefore(LocalDate.now())) {
                    sendJsonResponse(response, true,
                            "Ngày bạn yêu cầu đã qua rồi. Vui lòng chọn ngày từ hôm nay trở đi nhé!",
                            null, null);
                    return;
                }

                // Search for available slots
                List<JsonObject> results = searchAvailableSlots(searchDate, fieldTypeStr, timeRange);

                // Build search link for manual navigation
                String searchLink = "search?date=" + dateStr;
                if (!fieldTypeStr.isEmpty()) {
                    searchLink += "&type=" + fieldTypeStr;
                }
                if (!"ALL".equals(timeRange)) {
                    searchLink += "&timeRange=" + timeRange;
                }

                if (results.isEmpty()) {
                    String noResultMsg = aiMessage + "\n\nRất tiếc, không tìm thấy sân trống phù hợp với yêu cầu của bạn. "
                            + "Bạn có muốn thử ngày khác hoặc khung giờ khác không?";
                    sendJsonResponse(response, true, noResultMsg, null, searchLink);
                } else {
                    sendJsonResponse(response, true, aiMessage, results, searchLink);
                }

            } else {
                // CHAT intent - just return the message
                sendJsonResponse(response, true, aiMessage, null, null);
            }

        } catch (Exception e) {
            getServletContext().log("[AIBookingController] Error", e);
            sendJsonResponse(response, false,
                    "Đã xảy ra lỗi. Vui lòng thử lại sau!", null, null);
        }
    }

    /**
     * Build context string describing available fields for Gemini.
     */
    private String buildFieldsContext() {
        List<SportField> fields = fieldDAO.getActiveFields();
        StringBuilder sb = new StringBuilder();
        for (SportField field : fields) {
            sb.append("- ").append(field.getFieldName())
              .append(" (Sân ").append(field.getFieldType()).append(" người)")
              .append(", Giá: ").append(field.getPricePerHour()).append("đ/giờ")
              .append(", ID: ").append(field.getFieldID())
              .append("\n");
        }
        if (sb.length() == 0) {
            sb.append("Hiện chưa có sân nào trong hệ thống.\n");
        }
        return sb.toString();
    }

    /**
     * Search for available slots matching the AI-extracted criteria.
     */
    private List<JsonObject> searchAvailableSlots(LocalDate searchDate, String fieldTypeStr, String timeRange) {
        List<SportField> fields;
        if (fieldTypeStr != null && !fieldTypeStr.isEmpty()) {
            try {
                int type = Integer.parseInt(fieldTypeStr);
                fields = fieldDAO.getActiveFieldsByType(type);
            } catch (NumberFormatException e) {
                fields = fieldDAO.getActiveFields();
            }
        } else {
            fields = fieldDAO.getActiveFields();
        }

        LocalTime minTime = LocalTime.MIN;
        LocalTime maxTime = LocalTime.MAX;
        if (timeRange != null) {
            switch (timeRange) {
                case "MORNING":
                    minTime = LocalTime.of(6, 0);
                    maxTime = LocalTime.of(12, 0);
                    break;
                case "AFTERNOON":
                    minTime = LocalTime.of(12, 0);
                    maxTime = LocalTime.of(18, 0);
                    break;
                case "EVENING":
                    minTime = LocalTime.of(18, 0);
                    maxTime = LocalTime.of(23, 30);
                    break;
                default:
                    break;
            }
        }

        List<JsonObject> results = new ArrayList<>();

        for (SportField field : fields) {
            List<FieldSlot> allSlots = slotDAO.getByFieldID(field.getFieldID());
            List<Integer> bookedSlotIDs = bookingDAO.getBookedSlotIDs(field.getFieldID(), searchDate);

            for (FieldSlot slot : allSlots) {
                if (!"ACTIVE".equals(slot.getStatus())) {
                    continue;
                }

                if (slot.getStartTime().isBefore(minTime) || slot.getStartTime().isAfter(maxTime)
                        || slot.getStartTime().equals(maxTime)) {
                    continue;
                }

                // Skip past slots for today
                if (searchDate.equals(LocalDate.now())) {
                    LocalDateTime slotStartDateTime = searchDate.atTime(slot.getStartTime());
                    if (slotStartDateTime.isBefore(LocalDateTime.now())) {
                        continue;
                    }
                }

                if (!bookedSlotIDs.contains(slot.getSlotID())) {
                    JsonObject slotJson = new JsonObject();
                    slotJson.addProperty("fieldId", field.getFieldID());
                    slotJson.addProperty("fieldName", field.getFieldName());
                    slotJson.addProperty("fieldType", field.getFieldType());
                    slotJson.addProperty("slotId", slot.getSlotID());
                    slotJson.addProperty("startTime", slot.getStartTime().toString().substring(0, 5));
                    slotJson.addProperty("endTime", slot.getEndTime().toString().substring(0, 5));
                    slotJson.addProperty("price", slot.getPrice());
                    slotJson.addProperty("date", searchDate.toString());
                    slotJson.addProperty("imageURL", field.getImageURL() != null ? field.getImageURL() : "");
                    results.add(slotJson);
                }
            }
        }

        return results;
    }

    /**
     * Send JSON response to the client.
     */
    private void sendJsonResponse(HttpServletResponse response, boolean success, String message,
                                  List<JsonObject> slots, String searchLink) throws IOException {
        JsonObject json = new JsonObject();
        json.addProperty("success", success);
        json.addProperty("message", message);
        if (searchLink != null) {
            json.addProperty("searchLink", searchLink);
        }
        if (slots != null && !slots.isEmpty()) {
            json.add("slots", gson.toJsonTree(slots));
        }

        PrintWriter out = response.getWriter();
        out.print(gson.toJson(json));
        out.flush();
    }
}
