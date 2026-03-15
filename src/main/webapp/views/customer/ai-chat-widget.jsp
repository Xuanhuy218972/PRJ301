<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- AI Chat Widget — include this fragment in any customer-facing page --%>

<%-- Stylesheet --%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ai-chat.css">

<%-- Expose session state and context path to JS --%>
<script>
    var isLoggedIn  = ${not empty sessionScope.account};
    var contextPath = "${pageContext.request.contextPath}";
</script>

<%-- Floating toggle button --%>
<button id="ai-chat-toggle" aria-label="Mở trợ lý đặt sân">
    <i class="fas fa-comments"></i>
</button>

<%-- Chat panel --%>
<div id="ai-chat-panel" role="dialog" aria-label="Trợ lý đặt sân">

    <%-- Header --%>
    <div class="ai-chat-header">
        <div class="ai-chat-header-title">
            <i class="fas fa-robot"></i>
            <span>Trợ lý đặt sân</span>
        </div>
        <button class="ai-chat-close" aria-label="Đóng">
            <i class="fas fa-times"></i>
        </button>
    </div>

    <%-- Messages area with welcome message --%>
    <div class="ai-chat-messages">
        <div class="chat-bubble ai">
            Xin chào! Tôi có thể giúp bạn tìm và đặt sân.
            Hãy cho tôi biết bạn muốn đặt sân mấy người, ngày nào và giờ nào nhé!
        </div>
    </div>

    <%-- Input area --%>
    <div class="ai-chat-input-area">
        <textarea id="ai-chat-input"
                  rows="1"
                  placeholder="Nhập tin nhắn..."
                  aria-label="Nhập tin nhắn"></textarea>
        <button id="ai-chat-send" aria-label="Gửi">
            <i class="fas fa-paper-plane"></i>
        </button>
    </div>

</div>

<%-- Widget script --%>
<script src="${pageContext.request.contextPath}/assets/js/ai-chat.js"></script>
