package com.sportfield.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.sportfield.model.BookingIntent;
import com.sportfield.model.ChatMessage;

import jakarta.servlet.ServletContext;

import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Service that communicates with the Gemini REST API to process natural language
 * booking requests and return either a BookingIntent or a clarifying String.
 */
public class GeminiService {

    private static final Logger LOGGER = Logger.getLogger(GeminiService.class.getName());
    private static final ObjectMapper MAPPER = new ObjectMapper();
    private static final String ENDPOINT_TEMPLATE =
            "https://generativelanguage.googleapis.com/v1beta/models/%s:generateContent?key=%s";

    private final String apiKey;
    private final String model;
    private final HttpClient httpClient;

    // -------------------------------------------------------------------------
    // Constructors / factory
    // -------------------------------------------------------------------------

    /**
     * Primary constructor — accepts key and model directly (useful for testing).
     */
    public GeminiService(String apiKey, String model) {
        this.apiKey = apiKey;
        this.model  = model;
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(10))
                .build();
    }

    /**
     * Factory method that loads configuration from
     * {@code /WEB-INF/gemini.properties} via the given {@link ServletContext}.
     */
    public static GeminiService fromServletContext(ServletContext ctx) {
        Properties props = new Properties();
        try (InputStream is = ctx.getResourceAsStream("/WEB-INF/gemini.properties")) {
            if (is == null) {
                throw new RuntimeException("gemini.properties not found in WEB-INF");
            }
            props.load(is);
        } catch (IOException e) {
            throw new RuntimeException("Failed to load gemini.properties", e);
        }
        String key   = props.getProperty("gemini.api.key");
        String model = props.getProperty("gemini.model", "gemini-2.0-flash");
        if (key == null || key.isBlank()) {
            throw new RuntimeException("gemini.api.key is not set in gemini.properties");
        }
        return new GeminiService(key, model);
    }

    // -------------------------------------------------------------------------
    // Public API
    // -------------------------------------------------------------------------

    /**
     * Sends {@code userMessage} together with the conversation {@code history}
     * to the Gemini API and returns either a {@link BookingIntent} (when the
     * model extracted a complete SEARCH intent) or a {@link String} (when the
     * model needs to ask a clarifying question).
     *
     * @param userMessage the latest message from the customer
     * @param history     prior conversation turns (may be empty)
     * @return {@link BookingIntent} or {@link String}
     * @throws RuntimeException on timeout or unrecoverable API error
     */
    public Object processMessage(String userMessage, List<ChatMessage> history) {
        String systemPrompt = buildSystemPrompt();
        String requestBody  = buildRequestBody(systemPrompt, userMessage, history);

        String url = String.format(ENDPOINT_TEMPLATE, model, apiKey);

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(requestBody))
                .timeout(Duration.ofSeconds(10))
                .build();

        HttpResponse<String> response;
        try {
            response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
        } catch (java.net.http.HttpTimeoutException e) {
            LOGGER.log(Level.WARNING, "Gemini API timed out", e);
            throw new RuntimeException("Xin lỗi, hệ thống AI đang bận. Vui lòng thử lại.");
        } catch (IOException | InterruptedException e) {
            LOGGER.log(Level.SEVERE, "Gemini API call failed", e);
            if (e instanceof InterruptedException) {
                Thread.currentThread().interrupt();
            }
            throw new RuntimeException("Xin lỗi, không thể kết nối đến hệ thống AI. Vui lòng thử lại.");
        }

        if (response.statusCode() != 200) {
            LOGGER.warning("Gemini API returned HTTP " + response.statusCode() + ": " + response.body());
            throw new RuntimeException("Xin lỗi, hệ thống AI gặp lỗi. Vui lòng thử lại.");
        }

        return parseGeminiResponse(response.body());
    }

    // -------------------------------------------------------------------------
    // Internal helpers
    // -------------------------------------------------------------------------

    /**
     * Builds the system prompt that instructs Gemini to respond only with
     * SEARCH or ASK JSON shapes, including today's date for relative resolution.
     */
    String buildSystemPrompt() {
        String today = LocalDate.now().format(DateTimeFormatter.ISO_LOCAL_DATE);
        return "Bạn là trợ lý đặt sân thể thao. Hôm nay là " + today + ".\n"
             + "Nhiệm vụ của bạn là phân tích yêu cầu đặt sân của khách hàng và trả lời ĐÚNG MỘT trong hai dạng JSON sau:\n\n"
             + "Nếu đã đủ thông tin (loại sân, ngày, giờ):\n"
             + "{\"action\":\"SEARCH\",\"fieldType\":<5|7|11>,\"date\":\"yyyy-MM-dd\",\"startHour\":<0-23>,\"endHour\":<1-24>}\n\n"
             + "Nếu còn thiếu thông tin:\n"
             + "{\"action\":\"ASK\",\"message\":\"<câu hỏi bằng tiếng Việt>\"}\n\n"
             + "Quy tắc:\n"
             + "- Chỉ trả về JSON thuần túy, không có markdown, không có giải thích.\n"
             + "- fieldType phải là 5, 7 hoặc 11.\n"
             + "- date phải là ngày trong tương lai (sau hôm nay " + today + ") theo định dạng yyyy-MM-dd.\n"
             + "- Nếu khách hàng đề cập ngày đã qua, hãy dùng action ASK để thông báo và hỏi lại.\n"
             + "- startHour và endHour là số nguyên (giờ theo định dạng 24h).\n"
             + "- Buổi sáng: startHour=6, endHour=12. Buổi chiều: startHour=12, endHour=18. Buổi tối: startHour=18, endHour=22.\n";
    }

    /**
     * Constructs the Gemini REST request body JSON string.
     */
    String buildRequestBody(String systemPrompt, String userMessage, List<ChatMessage> history) {
        try {
            ObjectNode root = MAPPER.createObjectNode();

            // system_instruction
            ObjectNode sysInstruction = root.putObject("system_instruction");
            ArrayNode sysParts = sysInstruction.putArray("parts");
            sysParts.addObject().put("text", systemPrompt);

            // contents array: history + new user message
            ArrayNode contents = root.putArray("contents");
            for (ChatMessage msg : history) {
                ObjectNode turn = contents.addObject();
                turn.put("role", msg.getRole());
                ArrayNode parts = turn.putArray("parts");
                parts.addObject().put("text", msg.getText());
            }

            // append the new user message
            ObjectNode userTurn = contents.addObject();
            userTurn.put("role", "user");
            userTurn.putArray("parts").addObject().put("text", userMessage);

            return MAPPER.writeValueAsString(root);
        } catch (Exception e) {
            throw new RuntimeException("Failed to build Gemini request body", e);
        }
    }

    /**
     * Parses the raw Gemini API response body and returns either a
     * {@link BookingIntent} or a {@link String}.
     */
    Object parseGeminiResponse(String responseBody) {
        try {
            JsonNode root = MAPPER.readTree(responseBody);
            String text = root
                    .path("candidates").path(0)
                    .path("content").path("parts").path(0)
                    .path("text").asText();

            if (text == null || text.isBlank()) {
                LOGGER.warning("Gemini returned empty text in response");
                return "Xin lỗi, tôi không hiểu yêu cầu của bạn. Bạn có thể nói rõ hơn không?";
            }

            // Strip markdown code fences if present
            String json = text.trim();
            if (json.startsWith("```")) {
                json = json.replaceAll("^```[a-zA-Z]*\\n?", "").replaceAll("```$", "").trim();
            }

            return parseInnerJson(json);
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to parse Gemini response: " + responseBody, e);
            return "Xin lỗi, tôi không hiểu yêu cầu của bạn. Bạn có thể nói rõ hơn không?";
        }
    }

    /**
     * Parses the inner JSON returned by Gemini (either SEARCH or ASK shape).
     * Package-private for unit testing.
     */
    Object parseInnerJson(String json) {
        try {
            JsonNode node = MAPPER.readTree(json);
            String action = node.path("action").asText();

            if ("SEARCH".equals(action)) {
                int fieldType  = node.path("fieldType").asInt();
                String dateStr = node.path("date").asText();
                int startHour  = node.path("startHour").asInt();
                int endHour    = node.path("endHour").asInt();

                LocalDate date = LocalDate.parse(dateStr, DateTimeFormatter.ISO_LOCAL_DATE);
                return new BookingIntent(fieldType, date, startHour, endHour);

            } else if ("ASK".equals(action)) {
                return node.path("message").asText();

            } else {
                LOGGER.warning("Unknown action in Gemini inner JSON: " + action);
                return "Xin lỗi, tôi không hiểu yêu cầu của bạn. Bạn có thể nói rõ hơn không?";
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Failed to parse inner Gemini JSON: " + json, e);
            return "Xin lỗi, tôi không hiểu yêu cầu của bạn. Bạn có thể nói rõ hơn không?";
        }
    }
}
