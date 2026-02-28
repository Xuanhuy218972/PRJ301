<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh Sửa Người Dùng - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/admin.css" rel="stylesheet">
</head>
<body>

    <div class="admin-layout">

        <jsp:include page="../common/sidebar.jsp"></jsp:include>

        <div class="main-content">
            <div class="container-fluid px-0">
                <div class="row">
                    <div class="col-12">
                        <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                        <div class="card-header bg-white py-4 border-bottom">
                            <div class="px-3">
                                <h4 class="fw-bold m-0">
                                    <i class="fas fa-user-edit text-primary me-2"></i>Chỉnh sửa thông tin người dùng
                                </h4>
                            </div>
                        </div>
                        <div class="card-body p-5">
                            <form method="post" action="${pageContext.request.contextPath}/admin/users">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="userID" value="${user.userID}">

                                <div class="mb-5 text-center">
                                    <div class="avatar-preview-container mb-3">
                                        <c:choose>
                                            <c:when test="${not empty user.avatar}">
                                                <img src="${user.avatar}" alt="Avatar" class="rounded-circle shadow-sm avatar-preview">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="rounded-circle shadow-sm mx-auto bg-primary-subtle text-primary avatar-fallback avatar-fallback-show">
                                                    <span class="fs-1 fw-bold">${user.fullName.substring(0,1).toUpperCase()}</span>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <p class="text-muted small mb-0">Avatar hiện tại (Lưu form để cập nhật)</p>
                                </div>

                                <div class="mb-5">
                                    <h6 class="text-uppercase fw-bold text-secondary mb-4 small tracking-widest">
                                        <i class="fas fa-lock me-2"></i>Thông tin tài khoản (Cố định)
                                    </h6>
                                    <div class="row g-4 align-items-center bg-light p-4 rounded-4 border border-dashed fixed-account-row">
                                        <div class="col-md-4">
                                            <label class="form-label small text-muted">Tên đăng nhập</label>
                                            <input type="text" class="form-control-plaintext fw-bold ps-2" value="${user.username}" readonly>
                                        </div>
                                        <div class="col-md-4">
                                            <label class="form-label small text-muted">Vai trò hiện tại</label>
                                            <div class="mt-2">
                                                <c:choose>
                                                    <c:when test="${user.role == 'ADMIN'}">
                                                        <span class="badge bg-danger px-3 py-2 rounded-pill">
                                                            <i class="fas fa-crown me-1"></i>${user.role}
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${user.role == 'STAFF'}">
                                                        <span class="badge bg-warning px-3 py-2 rounded-pill">
                                                            <i class="fas fa-user-tie me-1"></i>${user.role}
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-info px-3 py-2 rounded-pill">
                                                            <i class="fas fa-user me-1"></i>${user.role}
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="balance-card h-100 d-flex flex-column">
                                                <div class="balance-card-title">
                                                    <i class="fas fa-wallet me-1"></i>Số dư ví (VNĐ)
                                                </div>

                                                <c:choose>
                                                    <c:when test="${sessionScope.account.role == 'ADMIN'}">
                                                        <div class="mb-2">
                                                            <div class="display-amount">
                                                                <fmt:formatNumber value='${user.walletBalance}' type='number' groupingUsed='true'/> VNĐ
                                                            </div>
                                                            <div class="display-amount-label mt-1">
                                                                Số dư hiện tại. Chỉnh sửa bên dưới nếu cần.
                                                            </div>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="mb-2">
                                                            <div class="display-amount">
                                                                <fmt:formatNumber value='${user.walletBalance}' type='number' groupingUsed='true'/> VNĐ
                                                            </div>
                                                            <div class="display-amount-label mt-1">
                                                                Bạn không có quyền chỉnh sửa số dư.
                                                            </div>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="mb-5">
                                    <h6 class="text-uppercase fw-bold text-primary mb-4 small tracking-widest">
                                        <i class="fas fa-edit me-2"></i>Thông tin cá nhân có thể thay đổi
                                    </h6>
                                    <div class="row g-4">
                                        <div class="col-md-6">
                                            <label class="form-label">
                                                <i class="fas fa-user text-primary me-1"></i>Họ và tên
                                            </label>
                                            <input type="text" class="form-control" name="fullName" value="${user.fullName}" required>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label">
                                                <i class="fas fa-envelope text-primary me-1"></i>Email liên hệ
                                            </label>
                                            <input type="email" class="form-control" name="email" value="${user.email}" required>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label">
                                                <i class="fas fa-phone text-primary me-1"></i>Số điện thoại
                                            </label>
                                            <input type="tel" class="form-control" name="phone" value="${user.phone}">
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label">
                                                <i class="fas fa-venus-mars text-primary me-1"></i>Giới tính
                                            </label>
                                            <select class="form-select" name="gender">
                                                <option value="">-- Chọn giới tính --</option>
                                                <option value="Nam" ${user.gender == 'Nam' ? 'selected' : ''}>Nam</option>
                                                <option value="Nữ" ${user.gender == 'Nữ' ? 'selected' : ''}>Nữ</option>
                                                <option value="Khác" ${user.gender == 'Khác' ? 'selected' : ''}>Khác</option>
                                            </select>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label">
                                                <i class="fas fa-birthday-cake text-primary me-1"></i>Ngày sinh
                                            </label>
                                            <input type="date" class="form-control" name="dateOfBirth" value="${user.dateOfBirth}">
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label">
                                                <i class="fas fa-image text-primary me-1"></i>Avatar URL
                                            </label>
                                            <input type="url" class="form-control" name="avatar" value="${user.avatar}" placeholder="https://example.com/avatar.jpg">
                                            <small class="text-muted">Nhập link ảnh từ Google Drive, Imgur, hoặc URL trực tiếp</small>
                                        </div>
                                        <c:if test="${sessionScope.account.role == 'ADMIN'}">
                                            <div class="col-md-6">
                                                <label class="form-label">
                                                    <i class="fas fa-wallet text-primary me-1"></i>Số dư ví (VNĐ)
                                                </label>
                                                <input type="number" class="form-control" name="walletBalance" 
                                                       value="<fmt:formatNumber value='${user.walletBalance}' type='number' groupingUsed='false' maxFractionDigits='0'/>"
                                                       step="1000" min="0">
                                            </div>
                                        </c:if>
                                        <div class="col-md-6">
                                            <label class="form-label">
                                                <i class="fas fa-map-marker-alt text-primary me-1"></i>Địa chỉ
                                            </label>
                                            <textarea class="form-control" name="address" rows="3" 
                                                      placeholder="Nhập địa chỉ đầy đủ...">${user.address}</textarea>
                                        </div>
                                    </div>
                                </div>

                                <div class="d-flex justify-content-end gap-3 pt-4 border-top">
                                    <a href="#confirm-cancel-form" 
                                       class="btn btn-light px-4 rounded-pill">
                                        <i class="fas fa-times me-1"></i>Hủy
                                    </a>
                                    <button type="submit" class="btn btn-primary px-5 rounded-pill shadow">
                                        <i class="fas fa-save me-1"></i>Lưu thay đổi
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div id="confirm-cancel-form" class="css-modal-overlay">
        <div class="css-modal-content animate-slide-up">
            <div class="css-modal-icon">
                <i class="fas fa-exclamation-triangle"></i>
            </div>
            <div class="css-modal-title">Hủy chỉnh sửa?</div>
            <div class="css-modal-text">
                Các thay đổi chưa lưu sẽ bị mất. Bạn có chắc muốn hủy bỏ?
            </div>
            <div class="css-modal-actions">
                <a href="#" class="css-modal-btn stay">Ở lại</a>
                <a href="${pageContext.request.contextPath}/admin/users" class="css-modal-btn leave">Hủy bỏ</a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
