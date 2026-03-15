package com.sportfield.utils;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAdjusters;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Service class for Google Gemini API integration.
 * Parses natural language booking requests into structured search parameters.
 */
public class GeminiService {

    private static final Logger LOGGER = Logger.getLogger(GeminiService.class.getName());
    private static final Gson gson = new Gson();

    /**
     * Sends a user message to Gemini and returns the AI response text.
     */
    public static String chat(String userMessage, String systemContext) {
        try {
            URL url = new URL(GeminiConfig.GEMINI_API_URL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            conn.setDoOutput(true);
            conn.setConnectTimeout(15000);
            conn.setReadTimeout(30000);

            // Build request body with system instruction and user message
            JsonObject requestBody = new JsonObject();

            // System instruction
            JsonObject systemInstruction = new JsonObject();
            JsonArray systemParts = new JsonArray();
            JsonObject systemPart = new JsonObject();
            systemPart.addProperty("text", systemContext);
            systemParts.add(systemPart);
            systemInstruction.add("parts", systemParts);
            requestBody.add("systemInstruction", systemInstruction);

            // User message
            JsonArray contents = new JsonArray();
            JsonObject content = new JsonObject();
            content.addProperty("role", "user");
            JsonArray parts = new JsonArray();
            JsonObject part = new JsonObject();
            part.addProperty("text", userMessage);
            parts.add(part);
            content.add("parts", parts);
            contents.add(content);
            requestBody.add("contents", contents);

            // Generation config
            JsonObject generationConfig = new JsonObject();
            generationConfig.addProperty("temperature", 0.7);
            generationConfig.addProperty("maxOutputTokens", 1024);
            requestBody.add("generationConfig", generationConfig);

            String jsonBody = gson.toJson(requestBody);

            try (OutputStream os = conn.getOutputStream()) {
                os.write(jsonBody.getBytes(StandardCharsets.UTF_8));
            }

            int responseCode = conn.getResponseCode();
            BufferedReader reader = null;
            try {
                if (responseCode >= 200 && responseCode < 300) {
                    reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
                } else {
                    java.io.InputStream errorStream = conn.getErrorStream();
                    if (errorStream == null) {
                        LOGGER.log(Level.SEVERE, "[GeminiService] API error: " + responseCode + " (no error body)");
                        return null;
                    }
                    reader = new BufferedReader(new InputStreamReader(errorStream, StandardCharsets.UTF_8));
                }

                StringBuilder responseText = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    responseText.append(line);
                }

                if (responseCode >= 200 && responseCode < 300) {
                    return extractTextFromResponse(responseText.toString());
                } else {
                    LOGGER.log(Level.SEVERE, "[GeminiService] API error: " + responseCode + " - " + responseText);
                    return null;
                }
            } finally {
                if (reader != null) { try { reader.close(); } catch (Exception ignored) {} }
                conn.disconnect();
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "[GeminiService] Error calling Gemini API", e);
            return null;
        }
    }

    /**
     * Extract text content from Gemini API response JSON.
     */
    private static String extractTextFromResponse(String jsonResponse) {
        try {
            JsonObject response = JsonParser.parseString(jsonResponse).getAsJsonObject();
            JsonArray candidates = response.getAsJsonArray("candidates");
            if (candidates != null && candidates.size() > 0) {
                JsonObject firstCandidate = candidates.get(0).getAsJsonObject();
                JsonObject contentObj = firstCandidate.getAsJsonObject("content");
                JsonArray partsArr = contentObj.getAsJsonArray("parts");
                if (partsArr != null && partsArr.size() > 0) {
                    return partsArr.get(0).getAsJsonObject().get("text").getAsString();
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "[GeminiService] Error parsing response", e);
        }
        return null;
    }

    /**
     * Parse structured JSON from Gemini's response text.
     * Expected format: {"date":"2026-03-20","fieldType":"5","timeRange":"EVENING","response":"..."}
     */
    public static JsonObject parseBookingIntent(String aiResponse) {
        if (aiResponse == null) return null;
        try {
            // Find JSON block in the response (may be wrapped in markdown code block)
            String jsonStr = aiResponse.trim();
            if (jsonStr.contains("```json")) {
                int start = jsonStr.indexOf("```json") + 7;
                int end = jsonStr.indexOf("```", start);
                if (end > start) {
                    jsonStr = jsonStr.substring(start, end).trim();
                }
            } else if (jsonStr.contains("```")) {
                int start = jsonStr.indexOf("```") + 3;
                int end = jsonStr.indexOf("```", start);
                if (end > start) {
                    jsonStr = jsonStr.substring(start, end).trim();
                }
            }
            // Try to find JSON object in the string
            int braceStart = jsonStr.indexOf('{');
            int braceEnd = jsonStr.lastIndexOf('}');
            if (braceStart >= 0 && braceEnd > braceStart) {
                jsonStr = jsonStr.substring(braceStart, braceEnd + 1);
            }
            JsonElement element = JsonParser.parseString(jsonStr);
            if (element.isJsonObject()) {
                return element.getAsJsonObject();
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "[GeminiService] Could not parse booking intent JSON from: " + aiResponse, e);
        }
        return null;
    }

    /**
     * Build the system prompt for the AI booking assistant.
     * Includes today's date and available field information for context.
     */
    public static String buildSystemPrompt(String availableFieldsInfo) {
        LocalDate today = LocalDate.now();
        LocalDate tomorrow = today.plusDays(1);
        LocalDate nextMonday = today.with(TemporalAdjusters.next(DayOfWeek.MONDAY));

        return "Bạn là trợ lý AI đặt sân bóng đá của hệ thống SportFieldHub. "
             + "Nhiệm vụ của bạn là hiểu yêu cầu đặt sân từ khách hàng bằng ngôn ngữ tự nhiên (tiếng Việt), "
             + "sau đó trích xuất thông tin tìm kiếm và trả về JSON.\n\n"
             + "NGÀY HÔM NAY: " + today.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")) + " ("
             + getVietnameseDayOfWeek(today.getDayOfWeek()) + ")\n"
             + "NGÀY MAI: " + tomorrow.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")) + " ("
             + getVietnameseDayOfWeek(tomorrow.getDayOfWeek()) + ")\n"
             + "THỨ HAI TUẦN SAU: " + nextMonday.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")) + "\n\n"
             + "THÔNG TIN SÂN HIỆN CÓ:\n" + availableFieldsInfo + "\n\n"
             + "QUY TẮC:\n"
             + "1. Luôn trả lời bằng tiếng Việt, thân thiện, ngắn gọn.\n"
             + "2. Khi khách hàng mô tả yêu cầu đặt sân, hãy trích xuất: ngày, loại sân (5 hoặc 7 người), khung giờ.\n"
             + "3. Khung giờ có 3 loại: MORNING (06:00-12:00), AFTERNOON (12:00-18:00), EVENING (18:00-23:30), ALL (tất cả).\n"
             + "4. Nếu khách nói 'thứ 7 này' → tính từ hôm nay đến thứ 7 gần nhất sắp tới.\n"
             + "5. Nếu khách nói 'chiều' → AFTERNOON, 'tối' → EVENING, 'sáng' → MORNING.\n"
             + "6. Nếu khách nói 'cuối tuần' → tìm cả thứ 7 và chủ nhật gần nhất.\n"
             + "7. Nếu thiếu thông tin, hãy hỏi lại khách.\n\n"
             + "ĐỊNH DẠNG TRẢ LỜI:\n"
             + "Luôn trả về JSON với cấu trúc:\n"
             + "```json\n"
             + "{\n"
             + "  \"intent\": \"SEARCH\" hoặc \"CHAT\",\n"
             + "  \"date\": \"yyyy-MM-dd\" (nếu có),\n"
             + "  \"fieldType\": \"5\" hoặc \"7\" hoặc \"\" (tất cả),\n"
             + "  \"timeRange\": \"MORNING\" hoặc \"AFTERNOON\" hoặc \"EVENING\" hoặc \"ALL\",\n"
             + "  \"response\": \"Câu trả lời cho khách hàng\"\n"
             + "}\n"
             + "```\n\n"
             + "VÍ DỤ:\n"
             + "- Khách: 'Tôi muốn đặt sân 5 người tối thứ 7 này'\n"
             + "  → {\"intent\":\"SEARCH\",\"date\":\"" + today.with(TemporalAdjusters.nextOrSame(DayOfWeek.SATURDAY)).format(DateTimeFormatter.ofPattern("yyyy-MM-dd"))
             + "\",\"fieldType\":\"5\",\"timeRange\":\"EVENING\",\"response\":\"Để tôi tìm sân 5 người vào tối Thứ 7 cho bạn nhé!\"}\n"
             + "- Khách: 'Hello'\n"
             + "  → {\"intent\":\"CHAT\",\"date\":\"\",\"fieldType\":\"\",\"timeRange\":\"\",\"response\":\"Xin chào! Tôi là trợ lý AI đặt sân bóng. Bạn muốn đặt sân vào ngày nào, loại sân gì và khung giờ nào ạ?\"}\n"
             + "- Khách: 'Chiều mai có sân 7 người không?'\n"
             + "  → {\"intent\":\"SEARCH\",\"date\":\"" + tomorrow.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"))
             + "\",\"fieldType\":\"7\",\"timeRange\":\"AFTERNOON\",\"response\":\"Tôi sẽ tìm sân 7 người vào chiều mai cho bạn!\"}\n";
    }

    private static String getVietnameseDayOfWeek(DayOfWeek dow) {
        switch (dow) {
            case MONDAY: return "Thứ 2";
            case TUESDAY: return "Thứ 3";
            case WEDNESDAY: return "Thứ 4";
            case THURSDAY: return "Thứ 5";
            case FRIDAY: return "Thứ 6";
            case SATURDAY: return "Thứ 7";
            case SUNDAY: return "Chủ Nhật";
            default: return "";
        }
    }
}
