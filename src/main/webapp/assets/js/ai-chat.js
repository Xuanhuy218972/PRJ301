/**
 * AI Chat Widget — SportField Booking
 * Requires: var isLoggedIn and var contextPath set by JSP before this script loads.
 */
(function () {
    'use strict';

    /* ── DOM refs (resolved after DOMContentLoaded) ── */
    var toggleBtn, panel, messagesEl, inputEl, sendBtn;

    /* ── Toggle panel open/close ── */
    function togglePanel() {
        panel.classList.toggle('open');
        if (panel.classList.contains('open')) {
            inputEl.focus();
        }
    }

    /* ── Append a bubble to the messages area ── */
    function appendBubble(text, type) {
        var div = document.createElement('div');
        div.className = 'chat-bubble ' + type;
        div.textContent = text;
        messagesEl.appendChild(div);
        scrollToBottom();
        return div;
    }

    /* ── Show / remove loading indicator ── */
    function showLoading() {
        var el = document.createElement('div');
        el.className = 'chat-loading';
        el.id = 'ai-chat-loading';
        for (var i = 0; i < 3; i++) {
            var dot = document.createElement('span');
            dot.className = 'dot';
            el.appendChild(dot);
        }
        messagesEl.appendChild(el);
        scrollToBottom();
    }

    function removeLoading() {
        var el = document.getElementById('ai-chat-loading');
        if (el) el.parentNode.removeChild(el);
    }

    /* ── Format price as Vietnamese currency ── */
    function formatPrice(price) {
        var num = parseFloat(price);
        if (isNaN(num)) return price + 'đ';
        return num.toLocaleString('vi-VN') + 'đ';
    }

    /* ── Build booking URL ── */
    function buildBookingUrl(slot) {
        var base = contextPath + '/booking'
            + '?fieldId=' + encodeURIComponent(slot.fieldID)
            + '&slotId='  + encodeURIComponent(slot.slotID)
            + '&date='    + encodeURIComponent(slot.bookingDate);
        if (!isLoggedIn) {
            return contextPath + '/login?returnUrl=' + encodeURIComponent(
                '/booking?fieldId=' + slot.fieldID
                + '&slotId='        + slot.slotID
                + '&date='          + slot.bookingDate
            );
        }
        return base;
    }

    /* ── Render slot cards ── */
    function renderSlots(slots) {
        var wrapper = document.createElement('div');
        wrapper.className = 'slot-cards-wrapper';

        slots.forEach(function (slot) {
            var card = document.createElement('div');
            card.className = 'slot-card';

            var name = document.createElement('div');
            name.className = 'slot-card-name';
            name.textContent = slot.fieldName;

            var meta = document.createElement('div');
            meta.className = 'slot-card-meta';

            var timeSpan = document.createElement('span');
            timeSpan.textContent = '🕐 ' + slot.startTime + ' – ' + slot.endTime;

            var dateSpan = document.createElement('span');
            dateSpan.textContent = '📅 ' + slot.bookingDate;

            meta.appendChild(timeSpan);
            meta.appendChild(dateSpan);

            var priceEl = document.createElement('div');
            priceEl.className = 'slot-card-price';
            priceEl.textContent = formatPrice(slot.price);

            var bookBtn = document.createElement('button');
            bookBtn.className = 'slot-card-book';
            bookBtn.textContent = 'Đặt ngay';
            bookBtn.addEventListener('click', function () {
                window.location.href = buildBookingUrl(slot);
            });

            card.appendChild(name);
            card.appendChild(meta);
            card.appendChild(priceEl);
            card.appendChild(bookBtn);
            wrapper.appendChild(card);
        });

        messagesEl.appendChild(wrapper);
        scrollToBottom();
    }

    /* ── Scroll messages to bottom ── */
    function scrollToBottom() {
        messagesEl.scrollTop = messagesEl.scrollHeight;
    }

    /* ── Set loading state on input controls ── */
    function setLoading(loading) {
        inputEl.disabled = loading;
        sendBtn.disabled = loading;
    }

    /* ── Send message ── */
    function sendMessage() {
        var text = inputEl.value.trim();
        if (!text) return;

        appendBubble(text, 'user');
        inputEl.value = '';
        setLoading(true);
        showLoading();

        fetch(contextPath + '/ai-chat', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ message: text })
        })
        .then(function (res) {
            return res.json();
        })
        .then(function (data) {
            removeLoading();
            if (data.type === 'slots') {
                if (data.slots && data.slots.length > 0) {
                    renderSlots(data.slots);
                } else {
                    appendBubble('Không tìm thấy sân trống phù hợp. Bạn thử ngày hoặc giờ khác nhé!', 'ai');
                }
            } else if (data.type === 'text') {
                appendBubble(data.message, 'ai');
            } else if (data.type === 'error') {
                appendBubble(data.message, 'error');
            } else {
                appendBubble('Đã xảy ra lỗi không xác định. Vui lòng thử lại.', 'error');
            }
        })
        .catch(function () {
            removeLoading();
            appendBubble('Không thể kết nối đến máy chủ. Vui lòng kiểm tra kết nối và thử lại.', 'error');
        })
        .finally(function () {
            setLoading(false);
            scrollToBottom();
        });
    }

    /* ── Init ── */
    document.addEventListener('DOMContentLoaded', function () {
        toggleBtn  = document.getElementById('ai-chat-toggle');
        panel      = document.getElementById('ai-chat-panel');
        messagesEl = panel ? panel.querySelector('.ai-chat-messages') : null;
        inputEl    = document.getElementById('ai-chat-input');
        sendBtn    = document.getElementById('ai-chat-send');

        if (!toggleBtn || !panel || !messagesEl || !inputEl || !sendBtn) return;

        /* Toggle on floating button click */
        toggleBtn.addEventListener('click', togglePanel);

        /* Close button inside panel (optional, if present) */
        var closeBtn = panel.querySelector('.ai-chat-close');
        if (closeBtn) {
            closeBtn.addEventListener('click', function () {
                panel.classList.remove('open');
            });
        }

        /* Send button click */
        sendBtn.addEventListener('click', sendMessage);

        /* Enter key submits; Shift+Enter allows newline in textarea */
        inputEl.addEventListener('keydown', function (e) {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                sendMessage();
            }
        });
    });

}());
