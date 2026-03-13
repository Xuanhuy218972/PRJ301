<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Liên Hệ - SportFieldHub</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800;900&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/customer/base.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/customer/contact.css" rel="stylesheet">
    </head>
    <body>
        <jsp:include page="../common/header.jsp" />

        <section class="contact-hero">
            <div class="container text-center">
                <h1 class="contact-hero-title mb-3">Liên Hệ Với Chúng Tôi</h1>
                <p class="contact-hero-subtitle">Đội ngũ hỗ trợ 24/7 luôn sẵn sàng giải đáp mọi thắc mắc của bạn</p>
            </div>
        </section>

        <section class="contact-info-section">
            <div class="container">
                <div class="row g-4">
                    <div class="col-md-4">
                        <div class="contact-info-card">
                            <div class="contact-icon-wrapper">
                                <i class="fas fa-phone-alt contact-icon"></i>
                            </div>
                            <h4 class="contact-card-title">Hotline Đặt Sân</h4>
                            <p class="contact-card-value">0901 234 567</p>
                            <p class="contact-card-desc">Hỗ trợ đặt sân nhanh chóng</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="contact-info-card">
                            <div class="contact-icon-wrapper">
                                <i class="fas fa-envelope contact-icon"></i>
                            </div>
                            <h4 class="contact-card-title">Email Phản Hồi</h4>
                            <p class="contact-card-value">support@sportbooking.com</p>
                            <p class="contact-card-desc">Phản hồi trong vòng 24h</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="contact-info-card">
                            <div class="contact-icon-wrapper">
                                <i class="fas fa-clock contact-icon"></i>
                            </div>
                            <h4 class="contact-card-title">Giờ Làm Việc</h4>
                            <p class="contact-card-value">7:00 - 22:00</p>
                            <p class="contact-card-desc">Tất cả các ngày trong tuần</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="contact-form-section">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-lg-8">
                        <div class="contact-form-card">
                            <div class="text-center mb-4">
                                <h2 class="contact-form-title">Gửi Yêu Cầu Hỗ Trợ</h2>
                                <p class="text-muted">Điền thông tin bên dưới và chúng tôi sẽ liên hệ lại sớm nhất</p>
                            </div>

                            <c:if test="${not empty successMessage}">
                                <div class="alert alert-success alert-dismissible fade show" role="alert">
                                    <i class="fas fa-check-circle me-2"></i>${successMessage}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                            </c:if>

                            <c:if test="${not empty errorMessage}">
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                            </c:if>

                            <form action="${pageContext.request.contextPath}/contact" method="POST" id="contactForm">
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold">Họ và Tên <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control form-control-lg" name="fullName" required 
                                               placeholder="Nguyễn Văn A" value="${param.fullName}">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold">Email <span class="text-danger">*</span></label>
                                        <input type="email" class="form-control form-control-lg" name="email" required 
                                               placeholder="example@email.com" value="${param.email}">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold">Số Điện Thoại <span class="text-danger">*</span></label>
                                        <input type="tel" class="form-control form-control-lg" name="phone" required 
                                               placeholder="0901234567" pattern="[0-9]{10}" value="${param.phone}">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold">Chủ Đề <span class="text-danger">*</span></label>
                                        <select class="form-select form-control-lg" name="subject" required>
                                            <option value="">-- Chọn chủ đề --</option>
                                            <option value="Đặt sân" ${param.subject == 'Đặt sân' ? 'selected' : ''}>Đặt sân</option>
                                            <option value="Thanh toán" ${param.subject == 'Thanh toán' ? 'selected' : ''}>Thanh toán</option>
                                            <option value="Hủy đặt sân" ${param.subject == 'Hủy đặt sân' ? 'selected' : ''}>Hủy đặt sân</option>
                                            <option value="Khiếu nại" ${param.subject == 'Khiếu nại' ? 'selected' : ''}>Khiếu nại</option>
                                            <option value="Khác" ${param.subject == 'Khác' ? 'selected' : ''}>Khác</option>
                                        </select>
                                    </div>
                                    <div class="col-12">
                                        <label class="form-label fw-bold">Nội Dung <span class="text-danger">*</span></label>
                                        <textarea class="form-control form-control-lg" name="message" rows="6" required 
                                                  placeholder="Nhập nội dung yêu cầu hỗ trợ của bạn...">${param.message}</textarea>
                                    </div>
                                    <div class="col-12 text-center mt-4">
                                        <button type="submit" class="btn btn-primary btn-lg px-5 py-3 fw-bold contact-submit-btn">
                                            <i class="fas fa-paper-plane me-2"></i>Gửi Yêu Cầu
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <jsp:include page="../common/footer.jsp" />

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
