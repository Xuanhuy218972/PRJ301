# Requirements Document

## Introduction

This feature adds an AI-powered chat interface to the SportField booking system, allowing customers to describe their booking needs in natural language (Vietnamese or English). The system uses the Gemini API to parse the customer's intent, query available field slots from the database, and guide the customer through completing a booking — all within a conversational chat widget embedded in the existing JSP frontend.

## Glossary

- **AI_Chat_Service**: The server-side Java service that communicates with the Gemini API to process natural language messages and extract booking intent.
- **Chat_Controller**: The Jakarta Servlet (`AIChatController`) that handles AJAX requests from the chat widget and returns JSON responses.
- **Chat_Widget**: The client-side chat UI component embedded in the customer-facing pages, built with HTML/CSS/JavaScript.
- **Booking_Intent**: A structured object extracted from a customer's natural language message, containing field type, preferred date, and preferred time range.
- **Available_Slot**: A `FieldSlot` record whose status is `ACTIVE` and which has no conflicting `BookingDetail` for the requested date.
- **Conversation_Context**: The ordered list of prior messages in a chat session, stored server-side in `HttpSession`, used to provide multi-turn context to the Gemini API.
- **Field_Type**: An integer representing the court size (e.g., 5 = 5-a-side, 7 = 7-a-side, 11 = 11-a-side).
- **Confirmation_Payload**: A JSON object returned by the AI_Chat_Service containing the resolved `fieldID`, `slotID`, and `bookingDate` needed to redirect the customer to the existing booking flow.

---

## Requirements

### Requirement 1: Natural Language Message Processing

**User Story:** As a customer, I want to describe my booking request in natural language, so that I can find and book a court without manually browsing the schedule.

#### Acceptance Criteria

1. WHEN a customer submits a chat message, THE Chat_Controller SHALL forward the message and the current Conversation_Context to the AI_Chat_Service within 10 seconds.
2. WHEN the AI_Chat_Service receives a message, THE AI_Chat_Service SHALL send the message along with a system prompt and Conversation_Context to the Gemini API.
3. WHEN the Gemini API returns a response, THE AI_Chat_Service SHALL parse the response and return either a Booking_Intent or a clarifying reply text to the Chat_Controller.
4. IF the Gemini API call fails or times out, THEN THE Chat_Controller SHALL return a user-friendly error message in Vietnamese without exposing internal error details.
5. THE Chat_Controller SHALL accept messages up to 500 characters in length and reject longer messages with an error response.

---

### Requirement 2: Booking Intent Extraction

**User Story:** As a customer, I want the AI to understand my preferred court type, date, and time from my message, so that it can find matching available slots automatically.

#### Acceptance Criteria

1. WHEN a customer's message contains a field type indicator (e.g., "sân 5", "5-a-side", "sân 7"), THE AI_Chat_Service SHALL extract the Field_Type as an integer (5, 7, or 11).
2. WHEN a customer's message contains a date reference (e.g., "thứ 7", "Saturday", "ngày 21"), THE AI_Chat_Service SHALL resolve it to a concrete `LocalDate` relative to the current server date.
3. WHEN a customer's message contains a time-of-day reference (e.g., "buổi chiều", "afternoon", "17h"), THE AI_Chat_Service SHALL map it to a time range (e.g., afternoon = 12:00–18:00).
4. WHEN a Booking_Intent cannot be fully extracted from a single message, THE AI_Chat_Service SHALL return a clarifying question asking for the missing information (field type, date, or time).
5. WHEN a customer provides a specific date that has already passed, THE AI_Chat_Service SHALL inform the customer and ask for a future date.

---

### Requirement 3: Available Slot Search

**User Story:** As a customer, I want the AI to show me available time slots that match my request, so that I can choose one to book.

#### Acceptance Criteria

1. WHEN a complete Booking_Intent is available, THE Chat_Controller SHALL query `FieldSlotDAO` and `BookingDAO` to find Available_Slots matching the Field_Type, date, and time range.
2. WHEN Available_Slots are found, THE Chat_Controller SHALL return a list of up to 5 slots, each including field name, slot time, price, `fieldID`, `slotID`, and `bookingDate`.
3. WHEN no Available_Slots are found for the requested criteria, THE Chat_Controller SHALL return a message informing the customer and suggesting they try a different date or time.
4. THE Chat_Controller SHALL only return slots where the parent `SportField` has status `ACTIVE` and the `FieldSlot` has status `ACTIVE`.
5. WHEN Available_Slots are returned, THE Chat_Controller SHALL include them as structured data in the JSON response so the Chat_Widget can render them as selectable cards.

---

### Requirement 4: Booking Confirmation and Handoff

**User Story:** As a customer, I want to confirm a slot from the chat and be taken directly to the booking page, so that I can complete payment without re-entering my details.

#### Acceptance Criteria

1. WHEN a customer selects a slot from the chat results, THE Chat_Widget SHALL redirect the customer to the existing `/booking` URL with `fieldId`, `slotId`, and `date` query parameters.
2. WHEN the customer is redirected to `/booking`, THE existing BookingController SHALL handle the request using the existing booking and payment flow without modification.
3. WHEN a customer is not logged in and selects a slot, THE Chat_Widget SHALL redirect the customer to `/login` with a return URL pointing back to the booking page.

---

### Requirement 5: Conversation Context Management

**User Story:** As a customer, I want the AI to remember what I said earlier in the conversation, so that I don't have to repeat myself.

#### Acceptance Criteria

1. THE Chat_Controller SHALL store the Conversation_Context in the customer's `HttpSession` under a dedicated session key.
2. WHEN a new message is sent, THE Chat_Controller SHALL append the customer's message and the AI's reply to the Conversation_Context before returning the response.
3. THE Chat_Controller SHALL limit the Conversation_Context to the most recent 10 message pairs to prevent excessive token usage.
4. WHEN a customer's session expires or the customer explicitly resets the chat, THE Chat_Controller SHALL clear the Conversation_Context and start a new conversation.

---

### Requirement 6: Chat Widget UI

**User Story:** As a customer, I want a chat interface that is easy to use and fits the existing site design, so that the experience feels native to the application.

#### Acceptance Criteria

1. THE Chat_Widget SHALL be accessible as a floating button on all customer-facing pages.
2. WHEN the floating button is clicked, THE Chat_Widget SHALL expand to show the chat panel without navigating away from the current page.
3. WHEN the AI returns available slot results, THE Chat_Widget SHALL render each slot as a card with field name, time, price, and a "Book Now" button.
4. WHEN a message is being processed, THE Chat_Widget SHALL display a loading indicator until the response is received.
5. WHEN an error response is received, THE Chat_Widget SHALL display the error message in the chat panel in Vietnamese.
6. THE Chat_Widget SHALL support input submission via the Enter key and a send button.

---

### Requirement 7: Security and Access Control

**User Story:** As a system administrator, I want the AI chat endpoint to be secure, so that it cannot be abused or expose sensitive data.

#### Acceptance Criteria

1. THE Chat_Controller SHALL require the customer to be authenticated (session attribute `account` must be non-null) before processing any message.
2. IF an unauthenticated request is received by the Chat_Controller, THEN THE Chat_Controller SHALL return an HTTP 401 response with a JSON error body.
3. THE Chat_Controller SHALL sanitize all customer input before including it in the Gemini API prompt to prevent prompt injection.
4. THE AI_Chat_Service SHALL store the Gemini API key in a server-side configuration file and SHALL NOT expose it to the client.
5. THE Chat_Controller SHALL rate-limit requests to a maximum of 20 messages per customer session to prevent API abuse.
