package com.sportfield.controller.customer;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.sportfield.dao.BookingDAO;
import com.sportfield.dao.FieldSlotDAO;
import com.sportfield.dao.SportFieldDAO;
import com.sportfield.model.BookingIntent;
import com.sportfield.model.ChatMessage;
import com.sportfield.model.FieldSlot;
import com.sportfield.model.SlotResult;
import com.sportfield.model.SportField;
import com.sportfield.service.GeminiService;
import com.sportfield.utils.InputSanitizer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet that handles AI-powered chat booking requests.
 * Requirements: 1.1, 1.4, 1.5, 3.1, 3.2, 3.3, 3.4, 3.5, 5.1, 5.2, 5.3, 7.1, 7.2, 7.5
 */
@WebServlet(name = "AIChatController", urlPatterns = {"/ai-chat"})
public class AIChatController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(AIChatController.class.getName());
    private static final ObjectMapper MAPPER = new ObjectMapper();
    private static final int MAX_MESSAGE_LENGTH = 500;
    private static final int MAX_MESSAGE_COUNT = 20;
    private static final int MAX_HISTORY_MESSAGES = 20; // 10 pairs
    private static final int MAX_SLOT_RESULTS = 5;
    private static final String SESSION_HISTORY_KEY = "aiChatHistory";
    private static final String SESSION_COUNT_KEY = "aiChatMessageCount";

    private GeminiService geminiService;

    @Override
    public void init() throws ServletException {
        geminiService = GeminiService.fromServletContext(getServletContext());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession(false);

        // 7.1 / 7.2 — Auth check
        if (session == null || session.getAttribute("account") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.write("{\"type\":\"error\",\"message\":\"Vui lòng đăng nhập.\"}");
            return;
        }

        // 7.5 — Rate limit check
        Integer messageCount = (Integer) session.getAttribute(SESSION_COUNT_KEY);
        if (messageCount != null && messageCount >= MAX_MESSAGE_COUNT) {
            out.write("{\"type\":\"error\",\"message\":\"Bạn đã gửi quá nhiều tin nhắn. Vui lòng thử lại sau.\"}");
            return;
        }

        // 1.5 — Read and validate message from JSON body
        String rawMessage;
        try {
            JsonNode body = MAPPER.readTree(request.getReader());
            rawMessage = body.path("message").asText("");
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to parse request body", e);
            out.write("{\"type\":\"error\",\"message\":\"Yêu cầu không hợp lệ.\"}");
            return;
        }

        if (rawMessage.length() > MAX_MESSAGE_LENGTH) {
            out.write("{\"type\":\"error\",\"message\":\"Tin nhắn quá dài (tối đa 500 ký tự).\"}");
            return;
        }

        // 7.3 — Sanitize input
        String sanitizedMessage = InputSanitizer.sanitize(rawMessage);

        // 5.1 — Load conversation history from session
        @SuppressWarnings("unchecked")
        List<ChatMessage> history = (List<ChatMessage>) session.getAttribute(SESSION_HISTORY_KEY);
        if (history == null) {
            history = new ArrayList<>();
        }

        // 1.1 — Call GeminiService
        Object result;
        try {
            result = geminiService.processMessage(sanitizedMessage, history);
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "GeminiService error", e);
            // 1.4 — User-friendly error, no internal details
            appendHistory(session, history, sanitizedMessage,
                    "Xin lỗi, hệ thống AI đang bận. Vui lòng thử lại.");
            incrementCount(session, messageCount);
            out.write("{\"type\":\"error\",\"message\":\"Xin lỗi, hệ thống AI đang bận. Vui lòng thử lại.\"}");
            return;
        }

        // 3.1 — Handle BookingIntent: query DAOs for available slots
        if (result instanceof BookingIntent) {
            BookingIntent intent = (BookingIntent) result;
            List<SlotResult> slots;
            try {
                slots = findAvailableSlots(intent);
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "DB error during slot search", e);
                appendHistory(session, history, sanitizedMessage, "Lỗi hệ thống. Vui lòng thử lại.");
                incrementCount(session, messageCount);
                out.write("{\"type\":\"error\",\"message\":\"Lỗi hệ thống. Vui lòng thử lại.\"}");
                return;
            }

            String aiReply;
            String jsonResponse;
            if (slots.isEmpty()) {
                // 3.3 — No slots found
                aiReply = "Không tìm thấy sân trống phù hợp. Bạn có muốn thử ngày hoặc giờ khác không?";
                jsonResponse = "{\"type\":\"text\",\"message\":\"" + aiReply + "\"}";
            } else {
                // 3.2, 3.5 — Return structured slot list
                aiReply = "Đã tìm thấy " + slots.size() + " sân trống.";
                jsonResponse = MAPPER.writeValueAsString(
                        new SlotsResponse("slots", slots));
            }

            appendHistory(session, history, sanitizedMessage, aiReply);
            incrementCount(session, messageCount);
            out.write(jsonResponse);

        } else {
            // String (ASK) response from Gemini
            String aiReply = (String) result;
            appendHistory(session, history, sanitizedMessage, aiReply);
            incrementCount(session, messageCount);
            out.write(MAPPER.writeValueAsString(new TextResponse("text", aiReply)));
        }
    }

    // -------------------------------------------------------------------------
    // Helpers
    // -------------------------------------------------------------------------

    /**
     * Queries DAOs to find available slots matching the given BookingIntent.
     * Returns up to MAX_SLOT_RESULTS results.
     * Requirements: 3.1, 3.2, 3.4
     */
    private List<SlotResult> findAvailableSlots(BookingIntent intent) {
        SportFieldDAO sportFieldDAO = new SportFieldDAO();
        FieldSlotDAO fieldSlotDAO = new FieldSlotDAO();
        BookingDAO bookingDAO = new BookingDAO();

        List<SlotResult> results = new ArrayList<>();
        LocalDate date = intent.getDate();
        int startHour = intent.getStartHour();
        int endHour = intent.getEndHour();

        List<SportField> fields = sportFieldDAO.getActiveFieldsByType(intent.getFieldType());

        for (SportField field : fields) {
            if (results.size() >= MAX_SLOT_RESULTS) break;

            List<FieldSlot> slots = fieldSlotDAO.getByFieldID(field.getFieldID());
            List<Integer> bookedSlotIDs = bookingDAO.getBookedSlotIDs(field.getFieldID(), date);

            for (FieldSlot slot : slots) {
                if (results.size() >= MAX_SLOT_RESULTS) break;

                int slotHour = slot.getStartTime().getHour();
                boolean inTimeWindow = slotHour >= startHour && slotHour < endHour;
                boolean isActive = "ACTIVE".equals(slot.getStatus());
                boolean isBooked = bookedSlotIDs.contains(slot.getSlotID());

                if (isActive && inTimeWindow && !isBooked) {
                    results.add(new SlotResult(
                            field.getFieldID(),
                            slot.getSlotID(),
                            field.getFieldName(),
                            field.getFieldType(),
                            slot.getStartTime().toString().substring(0, 5),
                            slot.getEndTime().toString().substring(0, 5),
                            slot.getPrice(),
                            date.toString()
                    ));
                }
            }
        }
        return results;
    }

    /**
     * Appends user message and AI reply to history, trims to MAX_HISTORY_MESSAGES,
     * and saves back to session.
     * Requirements: 5.2, 5.3
     */
    private void appendHistory(HttpSession session, List<ChatMessage> history,
                               String userMessage, String aiReply) {
        history.add(new ChatMessage("user", userMessage));
        history.add(new ChatMessage("model", aiReply));

        // Trim to most recent 20 messages (10 pairs)
        while (history.size() > MAX_HISTORY_MESSAGES) {
            history.remove(0);
        }
        session.setAttribute(SESSION_HISTORY_KEY, history);
    }

    /**
     * Increments the aiChatMessageCount in the session.
     * Requirements: 7.5
     */
    private void incrementCount(HttpSession session, Integer currentCount) {
        int newCount = (currentCount == null ? 0 : currentCount) + 1;
        session.setAttribute(SESSION_COUNT_KEY, newCount);
    }

    // -------------------------------------------------------------------------
    // Inner response POJOs for Jackson serialization
    // -------------------------------------------------------------------------

    public static class TextResponse {
        public final String type;
        public final String message;
        public TextResponse(String type, String message) {
            this.type = type;
            this.message = message;
        }
    }

    public static class SlotsResponse {
        public final String type;
        public final List<SlotResult> slots;
        public SlotsResponse(String type, List<SlotResult> slots) {
            this.type = type;
            this.slots = slots;
        }
    }
}
