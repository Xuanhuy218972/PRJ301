<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Đơn #BK${booking.bookingID} - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/admin.css" rel="stylesheet">
</head>
<body>

    <div class="admin-layout">

        <jsp:include page="../common/sidebar.jsp"></jsp:include>

        <div class="main-content">
            <div class="container-fluid px-0">

                <div class="page-header d-flex flex-wrap justify-content-between align-items-start gap-3">
                    <div>
                        <nav aria-label="breadcrumb" class="mb-2">
                            <ol class="breadcrumb small mb-0">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard" class="text-decoration-none text-muted">Hệ thống</a></li>
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/bookings" class="text-decoration-none text-muted">Quản lý đặt sân</a></li>
                                <li class="breadcrumb-item active text-primary fw-medium">Chi tiết #BK${booking.bookingID}</li>
                            </ol>
                        </nav>
                        <h2 class="page-title text-uppercase mb-0">
                            <i class="fas fa-file-invoice"></i>
                            Chi tiết đơn đặt sân #BK${booking.bookingID}
                        </h2>
                        <p class="page-subtitle">Xem thông tin chi tiết và các khung giờ đã đặt.</p>
                    </div>
                    <div class="d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/admin/bookings" class="btn btn-outline-secondary btn-sm rounded-pill px-3 shadow-sm">
                            <i class="fas fa-arrow-left me-1"></i> Quay lại
                        </a>
                    </div>
                </div>

                <!-- Booking Info Cards -->
                <div class="row g-3 mb-4">
                    <div class="col-md-6 col-lg-3">
                        <div class="card border-0 shadow-sm rounded-4 h-100">
                            <div class="card-body p-4">
                                <h6 class="text-muted text-uppercase small mb-2">Khách hàng</h6>
                                <div class="fw-bold fs-5 mb-2">${not empty booking.customerName ? booking.customerName : 'N/A'}</div>
                                <c:if test="${not empty booking.customerPhone}">
                                    <div class="d-flex align-items-center gap-2 text-dark">
                                        <i class="fas fa-phone-alt text-muted"></i>
                                        <span class="fw-medium">${booking.customerPhone}</span>
                                    </div>
                                </c:if>
                                <c:if test="${empty booking.customerPhone}">
                                    <div class="small text-muted">
                                        <i class="fas fa-phone-slash me-1"></i>Chưa có SĐT
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3">
                        <div class="card border-0 shadow-sm rounded-4 h-100">
                            <div class="card-body p-4">
                                <h6 class="text-muted text-uppercase small mb-2">Tổng tiền</h6>
                                <div class="fw-bold fs-5 text-success"><fmt:formatNumber value="${booking.totalPrice}" pattern="#,###"/>đ</div>
                                <div class="small text-muted mt-1">Đặt cọc: <fmt:formatNumber value="${booking.deposit}" pattern="#,###"/>đ</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3">
                        <div class="card border-0 shadow-sm rounded-4 h-100">
                            <div class="card-body p-4">
                                <h6 class="text-muted text-uppercase small mb-2">Trạng thái</h6>
                                <div class="mt-1">
                                    <c:choose>
                                        <c:when test="${booking.status == 'PENDING'}">
                                            <span class="badge bg-warning-subtle text-warning fs-6 px-3 py-2">
                                                <i class="fas fa-clock me-1"></i>Chờ xử lý
                                            </span>
                                        </c:when>
                                        <c:when test="${booking.status == 'CONFIRMED'}">
                                            <span class="badge bg-success-subtle text-success fs-6 px-3 py-2">
                                                <i class="fas fa-check-circle me-1"></i>Đã xác nhận
                                            </span>
                                        </c:when>
                                        <c:when test="${booking.status == 'COMPLETED'}">
                                            <span class="badge bg-info-subtle text-info fs-6 px-3 py-2">
                                                <i class="fas fa-check-double me-1"></i>Hoàn thành
                                            </span>
                                        </c:when>
                                        <c:when test="${booking.status == 'CANCELLED'}">
                                            <span class="badge bg-danger-subtle text-danger fs-6 px-3 py-2">
                                                <i class="fas fa-times-circle me-1"></i>Đã hủy
                                            </span>
                                        </c:when>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3">
                        <div class="card border-0 shadow-sm rounded-4 h-100">
                            <div class="card-body p-4">
                                <h6 class="text-muted text-uppercase small mb-2">Thông tin</h6>
                                <div class="small">
                                    <div class="mb-1">
                                        <strong>Loại:</strong>
                                        <c:choose>
                                            <c:when test="${booking.bookingType == 'EVENT'}">Sự kiện</c:when>
                                            <c:otherwise>Đặt lẻ</c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="mb-1">
                                        <strong>Ngày tạo:</strong>
                                        ${booking.createdAt != null ? booking.createdAt.toString().substring(0, 10) : 'N/A'}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Note -->
                <c:if test="${not empty booking.note}">
                    <div class="card border-0 shadow-sm rounded-4 mb-4">
                        <div class="card-body p-4">
                            <h6 class="fw-bold mb-2"><i class="fas fa-sticky-note text-warning me-2"></i>Ghi chú</h6>
                            <p class="mb-0 text-muted">${booking.note}</p>
                        </div>
                    </div>
                </c:if>

                <!-- Update Status Form -->
                <div class="card border-0 shadow-sm rounded-4 mb-4">
                    <div class="card-body p-4">
                        <h6 class="fw-bold mb-3"><i class="fas fa-exchange-alt text-primary me-2"></i>Cập nhật trạng thái</h6>
                        <form method="post" action="${pageContext.request.contextPath}/admin/bookings" class="d-flex align-items-center gap-3">
                            <input type="hidden" name="action" value="updateStatus">
                            <input type="hidden" name="bookingID" value="${booking.bookingID}">
                            <select name="newStatus" class="form-select" style="max-width: 250px;" required>
                                <option value="PENDING" ${booking.status == 'PENDING' ? 'selected' : ''}>Chờ xử lý</option>
                                <option value="CONFIRMED" ${booking.status == 'CONFIRMED' ? 'selected' : ''}>Đã xác nhận</option>
                                <option value="COMPLETED" ${booking.status == 'COMPLETED' ? 'selected' : ''}>Hoàn thành</option>
                                <option value="CANCELLED" ${booking.status == 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
                            </select>
                            <button type="submit" class="btn btn-primary btn-sm rounded-pill px-3">
                                <i class="fas fa-save me-1"></i> Cập nhật
                            </button>
                        </form>
                    </div>
                </div>

                <!-- Booking Details Table -->
                <div class="card border-0 shadow-sm rounded-4">
                    <div class="card-body p-0">
                        <div class="table-container">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h5 class="fw-bold mb-0"><i class="fas fa-list text-primary me-2"></i>Chi tiết khung giờ đã đặt</h5>
                                <span class="badge bg-primary rounded-pill">${fn:length(details)} khung giờ</span>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead>
                                        <tr>
                                            <th class="ps-4">#</th>
                                            <th>Sân</th>
                                            <th>Khung giờ</th>
                                            <th>Ngày đặt</th>
                                            <th>Giá</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="detail" items="${details}" varStatus="loop">
                                            <tr>
                                                <td class="ps-4 fw-bold">${loop.index + 1}</td>
                                                <td>
                                                    <div class="fw-bold">${not empty detail.fieldName ? detail.fieldName : 'N/A'}</div>
                                                </td>
                                                <td>
                                                    <span class="badge bg-primary-subtle text-primary px-3 py-2">
                                                        <i class="fas fa-clock me-1"></i>
                                                        ${not empty detail.slotStartTime ? detail.slotStartTime : '?'} - ${not empty detail.slotEndTime ? detail.slotEndTime : '?'}
                                                    </span>
                                                </td>
                                                <td class="text-muted">
                                                    <i class="far fa-calendar me-1"></i>
                                                    ${detail.bookingDate != null ? detail.bookingDate.toString() : 'N/A'}
                                                </td>
                                                <td class="fw-bold text-success">
                                                    <fmt:formatNumber value="${detail.price}" pattern="#,###"/>đ
                                                </td>
                                            </tr>
                                        </c:forEach>

                                        <c:if test="${empty details}">
                                            <tr>
                                                <td colspan="5" class="text-center py-4 text-muted">
                                                    <i class="fas fa-inbox fa-3x mb-3"></i>
                                                    <p>Chưa có chi tiết khung giờ nào</p>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
