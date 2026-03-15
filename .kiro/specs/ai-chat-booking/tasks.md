# Implementation Plan: AI Chat Booking

## Overview

Implement the AI-powered chat booking assistant by adding new components
(servlet, service, models, widget) that integrate with the existing
SportField JSP/Servlet architecture and Gemini API. No existing controllers
or DAOs are modified.

## Tasks

- [x] 1. Add dependencies and configuration
  - Add `com.google.genai:google-genai` Maven dependency to `pom.xml`
  - Add `com.fasterxml.jackson.core:jackson-databind` if not already present (for JSON serialization)
  - Create `src/main/webapp/WEB-INF/gemini.properties` with keys `gemini.api.key` and `gemini.model=gemini-2.0-flash`
  - _Requirements: 7.4_

- [x] 2. Create core data model classes
  - [x] 2.1 Create `BookingIntent.java` in `com.sportfield.model`
    - Fields: `int fieldType`, `LocalDate date`, `int startHour`, `int endHour`
    - _Requirements: 2.1, 2.2, 2.3_
  - [x] 2.2 Create `SlotResult.java` in `com.sportfield.model`
    - Fields: `int fieldID`, `int slotID`, `String fieldName`, `int fieldType`, `String startTime`, `String endTime`, `BigDecimal price`, `String bookingDate`
    - _Requirements: 3.2, 3.5_
  - [x] 2.3 Create `ChatMessage.java` in `com.sportfield.model`
    - Fields: `String role` ("user"/"model"), `String text`
    - _Requirements: 5.1_

- [x] 3. Implement GeminiService
  - [x] 3.1 Create `GeminiService.java` in `com.sportfield.service`
    - Load API key and model name from `gemini.properties` via `ServletContext` init or static loader
    - Build system prompt string that includes today's date and instructs Gemini to respond only with SEARCH or ASK JSON shapes
    - Implement `processMessage(String userMessage, List<ChatMessage> history)` method
    - Construct Gemini REST request body: system instruction + contents array (history + new user message)
    - Call Gemini `generateContent` endpoint using `java.net.http.HttpClient` with 10-second timeout
    - Parse response: extract `text` from `candidates[0].content.parts[0].text`
    - Parse inner JSON: if `action == "SEARCH"` return `BookingIntent`; if `action == "ASK"` return the message string
    - _Requirements: 1.2, 1.3, 2.1, 2.2, 2.3, 2.4_
  - [ ]* 3.2 Write property test for Gemini response parsing (Property 1)
    - **Property 1: Gemini response parsing completeness**
    - Generate random valid SEARCH JSON (random fieldType in {5,7,11}, random ISO date, random hours) and ASK JSON (random message string)
    - Assert parser returns `BookingIntent` for SEARCH and `String` for ASK without throwing
    - **Validates: Requirements 1.3**
  - [ ]* 3.3 Write property test for ISO date parsing round-trip (Property 3)
    - **Property 3: ISO date parsing round-trip**
    - Generate random valid `LocalDate` values, format to `yyyy-MM-dd`, parse back, assert equality
    - **Validates: Requirements 2.2**

- [x] 4. Implement input sanitization utility
  - [x] 4.1 Create `InputSanitizer.java` in `com.sportfield.utils`
    - Implement `sanitize(String input)`: strip known prompt-injection patterns (e.g., "ignore previous instructions", "system:", "###"), trim whitespace
    - _Requirements: 7.3_
  - [ ]* 4.2 Write property test for sanitization (Property 11)
    - **Property 11: Input sanitization idempotence**
    - Generate random strings; assert `sanitize(sanitize(x)).equals(sanitize(x))` for all inputs
    - Generate strings containing injection keywords; assert sanitized output does not contain them
    - **Validates: Requirements 7.3**

- [x] 5. Checkpoint — Ensure GeminiService and sanitizer tests pass
  - Ensure all tests pass, ask the user if questions arise.

- [x] 6. Implement AIChatController
  - [x] 6.1 Create `AIChatController.java` in `com.sportfield.controller.customer`
    - Annotate with `@WebServlet("/ai-chat")`
    - `doPost`: read JSON body, check auth (return 401 if no session account), check rate limit (return error if count ≥ 20), validate message length ≤ 500 chars
    - Sanitize input via `InputSanitizer`
    - Load conversation history from session (`aiChatHistory`), call `GeminiService.processMessage`
    - If result is `BookingIntent`: query `SportFieldDAO.getActiveFieldsByType`, `FieldSlotDAO.getByFieldID`, `BookingDAO.getBookedSlotIDs` to build `List<SlotResult>` (max 5, filtered by time window and ACTIVE status)
    - If result is `String` (ASK): return `{type:"text", message:"..."}`
    - If no slots found: return `{type:"text", message:"Không tìm thấy sân trống..."}`
    - Append user message + AI reply to history, trim to 20 messages, save back to session
    - Increment `aiChatMessageCount` in session
    - Serialize response to JSON using Jackson `ObjectMapper` and write to response
    - _Requirements: 1.1, 1.4, 1.5, 3.1, 3.2, 3.3, 3.4, 3.5, 5.1, 5.2, 5.3, 7.1, 7.2, 7.5_
  - [ ]* 6.2 Write property test for message length validation (Property 2)
    - **Property 2: Message length validation**
    - Generate strings of random length; assert controller rejects length > 500 and accepts ≤ 500
    - **Validates: Requirements 1.5**
  - [ ]* 6.3 Write property test for authentication gate (Property 9)
    - **Property 9: Authentication gate**
    - Generate mock requests without session account; assert HTTP 401 response
    - **Validates: Requirements 7.1**
  - [ ]* 6.4 Write property test for rate limit enforcement (Property 10)
    - **Property 10: Rate limit enforcement**
    - Generate sessions with `aiChatMessageCount` ≥ 20; assert request is rejected without calling GeminiService
    - **Validates: Requirements 7.5**
  - [ ]* 6.5 Write property test for slot search filtering (Property 4)
    - **Property 4: Slot search returns only active, unbooked slots**
    - Generate random field/slot/booking configurations; assert all returned SlotResults have ACTIVE status and no conflicting booking
    - **Validates: Requirements 3.1, 3.4**
  - [ ]* 6.6 Write property test for slot count invariant (Property 5)
    - **Property 5: Slot search result count invariant**
    - Generate random configurations with many matching slots; assert result list size ≤ 5
    - **Validates: Requirements 3.2**
  - [ ]* 6.7 Write property test for SlotResult JSON serialization (Property 6)
    - **Property 6: SlotResult JSON serialization completeness**
    - Generate random SlotResult instances; serialize to JSON; assert all required fields present
    - **Validates: Requirements 3.5**
  - [ ]* 6.8 Write property test for conversation history append invariant (Property 8)
    - **Property 8: Conversation history append invariant**
    - Generate histories of random length (0–15 pairs); simulate one exchange; assert history size is min(N+1, 10)
    - **Validates: Requirements 5.2, 5.3**

- [x] 7. Register servlet in web.xml
  - Add `<servlet>` and `<servlet-mapping>` entries for `AIChatController` at `/ai-chat` in `WEB-INF/web.xml`
  - _Requirements: 1.1_

- [x] 8. Checkpoint — Ensure all controller tests pass
  - Ensure all tests pass, ask the user if questions arise.

- [x] 9. Build the chat widget frontend
  - [x] 9.1 Create `webapp/assets/css/ai-chat.css`
    - Floating button (bottom-right, fixed position)
    - Chat panel (slide-up, 360px wide, 480px tall)
    - Message bubbles (user right-aligned, AI left-aligned)
    - Slot result cards (field name, time, price, "Đặt ngay" button)
    - Loading spinner
    - _Requirements: 6.1, 6.2, 6.3, 6.4, 6.5, 6.6_
  - [x] 9.2 Create `webapp/assets/js/ai-chat.js`
    - Toggle panel open/close on button click
    - `sendMessage()`: POST to `/ai-chat` with JSON body, show loading indicator
    - Handle response: render text bubble for `type:"text"`, render slot cards for `type:"slots"`, show error for `type:"error"`
    - Slot card "Đặt ngay" button: check if user is logged in (read from a JSP-rendered JS variable), redirect to `/booking?fieldId=&slotId=&date=` or `/login?returnUrl=...`
    - Enter key submits message
    - _Requirements: 6.1, 6.2, 6.3, 6.4, 6.5, 6.6, 4.1, 4.3_
  - [ ]* 9.3 Write property test for booking redirect URL construction (Property 7)
    - **Property 7: Booking redirect URL construction**
    - Generate random SlotResult-like objects; assert the JS URL builder produces a URL containing `fieldId`, `slotId`, and `date` with correct values (test the Java-side URL builder if extracted to a utility method)
    - **Validates: Requirements 4.1**
  - [x] 9.4 Create `webapp/views/customer/ai-chat-widget.jsp`
    - Include `ai-chat.css` and `ai-chat.js`
    - Render floating button and empty chat panel container
    - Expose logged-in state as a JS variable: `var isLoggedIn = ${not empty sessionScope.account};`
    - _Requirements: 6.1, 6.2_

- [x] 10. Include widget in customer pages
  - Add `<%@ include file="/views/customer/ai-chat-widget.jsp" %>` to `home.jsp`, `shop.jsp`, `field-detail.jsp`, and `search-results.jsp`
  - _Requirements: 6.1_

- [x] 11. Final checkpoint — Ensure all tests pass
  - Ensure all tests pass, ask the user if questions arise.
