<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page import="java.time.format.DateTimeFormatter" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Trang Cá Nhân - SportFieldHub</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800;900&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/customer/base.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/customer/profile.css" rel="stylesheet">
    </head>
    <body>
        <jsp:include page="../common/header.jsp" />

        <main class="py-5">
            <div class="container py-4">
                <c:if test="${not empty sessionScope.success}">
                    <input type="checkbox" id="close-success" class="alert-closer">
                    <div class="alert custom-alert-box border-0 bg-success text-white rounded-3 shadow-sm mb-4 position-relative" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${sessionScope.success}
                        <label for="close-success" class="position-absolute top-50 end-0 translate-middle-y me-3 opacity-75 alert-close-btn">
                            <i class="fas fa-times fs-5"></i>
                        </label>
                    </div>
                    <c:remove var="success" scope="session" />
                </c:if>

                <c:if test="${not empty sessionScope.error}">
                    <input type="checkbox" id="close-error" class="alert-closer">
                    <div class="alert custom-alert-box border-0 bg-danger text-white rounded-3 shadow-sm mb-4 position-relative" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>${sessionScope.error}
                        <label for="close-error" class="position-absolute top-50 end-0 translate-middle-y me-3 opacity-75 alert-close-btn">
                            <i class="fas fa-times fs-5"></i>
                        </label>
                    </div>
                    <c:remove var="error" scope="session" />
                </c:if>
                <input type="radio" name="profile_tabs" id="tab-info" checked>
                <input type="radio" name="profile_tabs" id="tab-bookings">
                <input type="radio" name="profile_tabs" id="tab-security">

                <div class="row g-4">
                    <div class="col-lg-4">
                        <div class="profile-sidebar mb-4">
                            <div class="avatar-circle">
                                <c:choose>
                                    <c:when test="${not empty user.avatar}">
                                        <img src="${user.avatar}" alt="Avatar" class="avatar-img">
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fas fa-user-ninja"></i>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <h4 class="fw-bold mb-1">${user.fullName}</h4>
                            <p class="text-muted small opacity-75 mb-0">${user.email}</p>
                            <div class="mt-3 pt-3 border-top border-secondary">
                                <span class="badge bg-light text-dark px-3 py-2 rounded-pill">
                                    <i class="fas fa-id-badge text-danger me-1"></i> 
                                    ${user.role == 'ADMIN' ? 'Quản trị viên' : (user.role == 'STAFF' ? 'Nhân viên' : 'Khách hàng')}
                                </span>
                            </div>
                        </div>

                        <div class="bg-white rounded-4 p-3 shadow-sm">
                            <label for="tab-info" class="tab-label label-info">
                                <i class="fas fa-user-edit"></i> Hồ sơ cá nhân
                            </label>
                            <label for="tab-bookings" class="tab-label label-bookings">
                                <i class="fas fa-futbol"></i> Lịch sử ra sân
                            </label>
                            <label for="tab-security" class="tab-label label-security">
                                <i class="fas fa-shield-alt"></i> Bảo mật
                            </label>
                        </div>
                    </div>

                    <div class="col-lg-8">

                        <div class="content-card css-tab-content content-info">
                            <h4 class="fw-bold mb-4 border-bottom pb-3">Thông Tin Cơ Bản</h4>
                            <form method="post" action="${pageContext.request.contextPath}/profile">
                                <input type="hidden" name="action" value="updateProfile">
                                <div class="row g-4">
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold text-muted small text-uppercase">Tên đăng nhập</label>
                                        <input type="text" class="form-control bg-light" value="${user.username}" disabled>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold text-muted small text-uppercase">Họ và tên</label>
                                        <input type="text" class="form-control" name="fullName" value="${user.fullName}" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold text-muted small text-uppercase">Số điện thoại</label>
                                        <input type="tel" class="form-control" name="phone" value="${user.phone}" required pattern="[0-9]{10,11}">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold text-muted small text-uppercase">Email</label>
                                        <input type="email" class="form-control" name="email" value="${user.email}" required>
                                    </div>
                                </div>
                                <div class="mt-4 pt-3 border-top text-end">
                                    <button type="submit" class="btn btn-action px-4"><i class="fas fa-save me-2"></i>Cập nhật ngay</button>
                                </div>
                            </form>
                        </div>

                        <div class="content-card css-tab-content content-bookings">
                            <h4 class="fw-bold mb-4 border-bottom pb-3">Các Trận Đã Đặt</h4>
                            <c:choose>
                                <c:when test="${empty bookings}">
                                    <div class="text-center py-5">
                                        <i class="fas fa-box-open fa-3x text-muted opacity-25 mb-3"></i>
                                        <h5 class="fw-bold text-dark">Chưa có trận nào!</h5>
                                        <p class="text-muted">Nhanh tay kiếm đồng đội và ra sân thôi.</p>
                                        <a href="${pageContext.request.contextPath}/shop" class="btn btn-danger rounded-pill px-4 mt-2">Đặt sân ngay</a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="booking" items="${bookings}">
                                        <div class="history-card bg-white">
                                            <div class="d-flex justify-content-between align-items-center border-bottom pb-2 mb-3">
                                                <span class="text-muted small fw-bold">#BK${booking.bookingID}</span>
                                                <c:choose>
                                                    <c:when test="${booking.bookingStatus == 'CONFIRMED'}">
                                                        <div>
                                                            <span class="badge bg-success px-3 py-2 rounded-pill me-1">Đã xác nhận</span>
                                                            <c:if test="${booking.paymentStatus == 'DEPOSITED'}">
                                                                <span class="badge bg-info text-dark px-3 py-2 rounded-pill">Đã cọc sân</span>
                                                            </c:if>
                                                        </div>
                                                    </c:when>
                                                    <c:when test="${booking.bookingStatus == 'PENDING'}">
                                                        <span class="badge bg-warning text-dark px-3 py-2 rounded-pill">Chờ thanh toán</span>
                                                    </c:when>
                                                    <c:when test="${booking.bookingStatus == 'COMPLETED'}">
                                                        <span class="badge bg-primary px-3 py-2 rounded-pill">Hoàn thành</span>
                                                    </c:when>
                                                    <c:when test="${booking.bookingStatus == 'CANCELLED'}">
                                                        <span class="badge bg-danger px-3 py-2 rounded-pill">Đã hủy</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary px-3 py-2 rounded-pill">${booking.bookingStatus}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <h5 class="fw-bold text-dark mb-3"><i class="fas fa-map-marker-alt text-danger me-2"></i>${booking.fieldName}</h5>
                                            <div class="row g-2 text-dark">
                                                <div class="col-sm-4">
                                                    <div class="small text-muted mb-1">Ngày</div>
                                                    <div class="fw-bold">${booking.bookingDate}</div>
                                                </div>
                                                <div class="col-sm-4">
                                                    <div class="small text-muted mb-1">Giờ</div>
                                                    <div class="fw-bold">${booking.slotStartTime} - ${booking.slotEndTime}</div>
                                                </div>
                                                <div class="col-sm-4">
                                                    <div class="small text-muted mb-1">Đã trả / Tổng</div>
                                                    <div class="fw-bold text-success fs-5">
                                                        <fmt:formatNumber value="${booking.paidAmount != null ? booking.paidAmount : 0}" pattern="#,###"/>đ 
                                                        <span class="fs-6 text-muted">/ <fmt:formatNumber value="${booking.price}" pattern="#,###"/>đ</span>
                                                    </div>
                                                </div>
                                            </div>
                                            <c:if test="${booking.bookingStatus == 'CONFIRMED'}">
                                                <div class="mt-3 pt-3 border-top">
                                                    <form method="post" action="${pageContext.request.contextPath}/profile" class="d-flex gap-2 align-items-end">
                                                        <input type="hidden" name="action" value="cancelBooking">
                                                        <input type="hidden" name="bookingID" value="${booking.bookingID}">
                                                        <div class="flex-grow-1">
                                                            <input type="text" class="form-control form-control-sm" name="cancelReason" placeholder="Lý do hủy (tùy chọn)">
                                                        </div>
                                                        <button type="submit" class="btn btn-outline-danger btn-sm rounded-pill px-3"
                                                                onclick="return confirm('Bạn chắc chắn muốn hủy sân này?');">
                                                            <i class="fas fa-times me-1"></i>Hủy sân
                                                        </button>
                                                    </form>
                                                </div>
                                            </c:if>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="content-card css-tab-content content-security">
                            <h4 class="fw-bold mb-4 border-bottom pb-3">Đổi Mật Khẩu</h4>
                            <form method="post" action="${pageContext.request.contextPath}/profile" class="w-75">
                                <input type="hidden" name="action" value="changePassword">
                                <div class="mb-3">
                                    <label class="form-label fw-bold text-muted small text-uppercase">Mật khẩu hiện tại</label>
                                    <input type="password" class="form-control" name="currentPassword" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label fw-bold text-muted small text-uppercase">Mật khẩu mới</label>
                                    <input type="password" class="form-control" name="newPassword" required minlength="6">
                                </div>
                                <div class="mb-4">
                                    <label class="form-label fw-bold text-muted small text-uppercase">Nhập lại mật khẩu mới</label>
                                    <input type="password" class="form-control" name="confirmPassword" required minlength="6">
                                </div>
                                <button type="submit" class="btn btn-action w-100"><i class="fas fa-key me-2"></i>Lưu mật khẩu</button>
                            </form>
                        </div>

                    </div>
                </div>
            </div>
        </main>

        <jsp:include page="../common/footer.jsp" />
    </body>
</html>

