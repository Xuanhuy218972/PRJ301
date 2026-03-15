<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>AI Booking - SportFieldHub</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800;900&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/customer/base.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/customer/ai-booking.css" rel="stylesheet">
    </head>
    <body>
        <jsp:include page="../common/header.jsp" />

        <section class="ai-booking-section">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-lg-8">
                        <!-- Header -->
                        <div class="ai-header text-center mb-4">
                            <div class="ai-icon-wrapper mb-3">
                                <i class="fas fa-robot"></i>
                            </div>
                            <h2 class="fw-bold">AI Booking Assistant</h2>
                            <p class="text-muted">Chat với AI để tìm và đặt sân nhanh chóng bằng ngôn ngữ tự nhiên</p>
                        </div>

                        <!-- Chat Container -->
                        <div class="chat-container">
                            <!-- Chat Messages -->
                            <div class="chat-messages" id="chatMessages">
                                <!-- Welcome message -->
                                <div class="message ai-message">
                                    <div class="message-avatar">
                                        <i class="fas fa-robot"></i>
                                    </div>
                                    <div class="message-content">
                                        <div class="message-bubble">
                                            Xin chào! Tôi là trợ lý AI đặt sân bóng của <strong>SportFieldHub</strong>. 
                                            Hãy cho tôi biết bạn muốn đặt sân như thế nào nhé!
                                            <br><br>
                                            <strong>Ví dụ bạn có thể nói:</strong>
                                            <ul class="mb-0 mt-2">
                                                <li>"Tìm sân 5 người tối thứ 7 này"</li>
                                                <li>"Chiều mai có sân 7 người không?"</li>
                                                <li>"Đặt sân sáng chủ nhật tuần này"</li>
                                            </ul>
                                        </div>
                                        <div class="message-time">AI Assistant</div>
                                    </div>
                                </div>
                            </div>

                            <!-- Quick Suggestions -->
                            <div class="quick-suggestions" id="quickSuggestions">
                                <button class="suggestion-chip" onclick="sendSuggestion('Tìm sân 5 người tối nay')">
                                    <i class="fas fa-bolt me-1"></i> Sân 5 tối nay
                                </button>
                                <button class="suggestion-chip" onclick="sendSuggestion('Chiều mai có sân 7 người không?')">
                                    <i class="fas fa-search me-1"></i> Sân 7 chiều mai
                                </button>
                                <button class="suggestion-chip" onclick="sendSuggestion('Tìm sân cuối tuần này')">
                                    <i class="far fa-calendar me-1"></i> Cuối tuần này
                                </button>
                                <button class="suggestion-chip" onclick="sendSuggestion('Sân nào rẻ nhất hôm nay?')">
                                    <i class="fas fa-tag me-1"></i> Sân rẻ nhất
                                </button>
                            </div>

                            <!-- Chat Input -->
                            <div class="chat-input-wrapper">
                                <form id="chatForm" onsubmit="sendMessage(event)">
                                    <div class="input-group">
                                        <input type="text" class="form-control chat-input" id="chatInput" 
                                               placeholder="Nhập yêu cầu đặt sân... VD: Tìm sân 5 người tối thứ 7"
                                               autocomplete="off" maxlength="500">
                                        <button type="submit" class="btn btn-danger chat-send-btn" id="sendBtn">
                                            <i class="fas fa-paper-plane"></i>
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <jsp:include page="../common/footer.jsp" />

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            const contextPath = '${pageContext.request.contextPath}';
            const chatMessages = document.getElementById('chatMessages');
            const chatInput = document.getElementById('chatInput');
            const sendBtn = document.getElementById('sendBtn');
            const quickSuggestions = document.getElementById('quickSuggestions');
            let isProcessing = false;

            function sendSuggestion(text) {
                chatInput.value = text;
                sendMessage(new Event('submit'));
            }

            function sendMessage(event) {
                event.preventDefault();
                const message = chatInput.value.trim();
                if (!message || isProcessing) return;

                // Hide quick suggestions after first message
                quickSuggestions.style.display = 'none';

                // Add user message to chat
                appendMessage('user', message);
                chatInput.value = '';

                // Show typing indicator
                const typingId = showTypingIndicator();

                isProcessing = true;
                sendBtn.disabled = true;

                // Send to server
                fetch(contextPath + '/ai-booking', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
                    },
                    body: 'message=' + encodeURIComponent(message)
                })
                .then(response => response.json())
                .then(data => {
                    removeTypingIndicator(typingId);
                    
                    if (data.success) {
                        // Show AI message
                        let aiHtml = formatMessage(data.message);

                        // Show search results if available
                        if (data.slots && data.slots.length > 0) {
                            aiHtml += buildSlotsHtml(data.slots, data.searchLink);
                        } else if (data.searchLink) {
                            aiHtml += '<div class="mt-3">'
                                    + '<a href="' + contextPath + '/' + data.searchLink + '" class="btn btn-sm btn-outline-danger">'
                                    + '<i class="fas fa-search me-1"></i>Xem trang tìm kiếm</a></div>';
                        }

                        appendMessage('ai', aiHtml, true);
                    } else {
                        appendMessage('ai', '<span class="text-danger">' + escapeHtml(data.message) + '</span>', true);
                    }
                })
                .catch(error => {
                    removeTypingIndicator(typingId);
                    appendMessage('ai', '<span class="text-danger">Lỗi kết nối. Vui lòng thử lại sau.</span>', true);
                })
                .finally(() => {
                    isProcessing = false;
                    sendBtn.disabled = false;
                    chatInput.focus();
                });
            }

            function appendMessage(type, content, isHtml) {
                const msgDiv = document.createElement('div');
                msgDiv.className = 'message ' + (type === 'user' ? 'user-message' : 'ai-message');

                const now = new Date();
                const timeStr = now.getHours().toString().padStart(2, '0') + ':' + now.getMinutes().toString().padStart(2, '0');

                if (type === 'user') {
                    msgDiv.innerHTML = 
                        '<div class="message-content">' +
                        '  <div class="message-bubble">' + escapeHtml(content) + '</div>' +
                        '  <div class="message-time">' + timeStr + '</div>' +
                        '</div>' +
                        '<div class="message-avatar"><i class="fas fa-user"></i></div>';
                } else {
                    msgDiv.innerHTML = 
                        '<div class="message-avatar"><i class="fas fa-robot"></i></div>' +
                        '<div class="message-content">' +
                        '  <div class="message-bubble">' + (isHtml ? content : escapeHtml(content)) + '</div>' +
                        '  <div class="message-time">AI Assistant - ' + timeStr + '</div>' +
                        '</div>';
                }

                chatMessages.appendChild(msgDiv);
                chatMessages.scrollTop = chatMessages.scrollHeight;
            }

            function showTypingIndicator() {
                const id = 'typing-' + Date.now();
                const typingDiv = document.createElement('div');
                typingDiv.id = id;
                typingDiv.className = 'message ai-message typing-message';
                typingDiv.innerHTML = 
                    '<div class="message-avatar"><i class="fas fa-robot"></i></div>' +
                    '<div class="message-content">' +
                    '  <div class="message-bubble typing-bubble">' +
                    '    <div class="typing-dots">' +
                    '      <span></span><span></span><span></span>' +
                    '    </div>' +
                    '  </div>' +
                    '</div>';
                chatMessages.appendChild(typingDiv);
                chatMessages.scrollTop = chatMessages.scrollHeight;
                return id;
            }

            function removeTypingIndicator(id) {
                const el = document.getElementById(id);
                if (el) el.remove();
            }

            function buildSlotsHtml(slots, searchLink) {
                let html = '<div class="ai-slots-result mt-3">';
                html += '<div class="slots-header mb-2"><strong><i class="fas fa-futbol me-1"></i> '
                      + 'Tìm thấy ' + slots.length + ' khung giờ trống:</strong></div>';
                html += '<div class="slots-grid">';

                const maxShow = Math.min(slots.length, 6);
                for (let i = 0; i < maxShow; i++) {
                    const slot = slots[i];
                    const bookingUrl = contextPath + '/booking?fieldId=' + slot.fieldId 
                                     + '&slotId=' + slot.slotId + '&date=' + slot.date;
                    const price = Number(slot.price).toLocaleString('vi-VN');

                    html += '<div class="slot-card">'
                          + '  <div class="slot-card-header">'
                          + '    <span class="slot-field-name">' + escapeHtml(slot.fieldName) + '</span>'
                          + '    <span class="badge bg-primary">Sân ' + slot.fieldType + '</span>'
                          + '  </div>'
                          + '  <div class="slot-card-body">'
                          + '    <div class="slot-time"><i class="far fa-clock me-1"></i>' + slot.startTime + ' - ' + slot.endTime + '</div>'
                          + '    <div class="slot-price">' + price + 'đ</div>'
                          + '  </div>'
                          + '  <a href="' + bookingUrl + '" class="btn btn-danger btn-sm w-100 mt-2">Đặt sân</a>'
                          + '</div>';
                }

                html += '</div>';

                if (slots.length > 6 && searchLink) {
                    html += '<div class="text-center mt-2">'
                          + '<a href="' + contextPath + '/' + searchLink + '" class="btn btn-outline-danger btn-sm">'
                          + '<i class="fas fa-list me-1"></i>Xem tất cả ' + slots.length + ' kết quả</a></div>';
                }

                html += '</div>';
                return html;
            }

            function formatMessage(text) {
                if (!text) return '';
                // Convert newlines to <br>
                return escapeHtml(text).replace(/\n/g, '<br>');
            }

            function escapeHtml(text) {
                if (!text) return '';
                const div = document.createElement('div');
                div.textContent = text;
                return div.innerHTML;
            }

            // Auto-focus input
            chatInput.focus();

            // Enter to send
            chatInput.addEventListener('keydown', function(e) {
                if (e.key === 'Enter' && !e.shiftKey) {
                    e.preventDefault();
                    document.getElementById('chatForm').dispatchEvent(new Event('submit'));
                }
            });
        </script>
    </body>
</html>
