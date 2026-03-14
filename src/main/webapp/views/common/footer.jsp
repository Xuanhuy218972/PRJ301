<%@page contentType="text/html" pageEncoding="UTF-8"%>

<footer class="main-footer">
    <div class="container">
        <!-- Sponsors -->
        <div class="footer-sponsors">
            <h6 class="text-center text-white-50 mb-3">Đối Tác & Nhà Tài Trợ</h6>
            <div class="sponsor-container">
                <img src="${pageContext.request.contextPath}/assets/images/konami.png" alt="Konami" class="footer-sponsor-logo">
                <img src="${pageContext.request.contextPath}/assets/images/tiger.png" alt="Tiger" class="footer-sponsor-logo">
                <img src="${pageContext.request.contextPath}/assets/images/adidas.png" alt="Adidas" class="footer-sponsor-logo">
            </div>
        </div>
        
        <!-- Copyright -->
        <div class="footer-bottom">
            <p class="mb-0">&copy; 2026 SportFieldHub. All rights reserved.</p>
        </div>
    </div>
</footer>

<script>
    // Smooth Reveal on Scroll
    const revealElements = document.querySelectorAll('.reveal');
    const revealObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('active');
                // Optional: stop observing once revealed
                // revealObserver.unobserve(entry.target);
            } else {
                // If you want it to hide again when scrolling up, don't unobserve
                entry.target.classList.remove('active');
            }
        });
    }, {
        threshold: 0.1, // Trigger when 10% of element is visible
        rootMargin: '0px 0px -50px 0px' // Slightly delay trigger for better effect
    });

    revealElements.forEach(el => revealObserver.observe(el));
</script>
