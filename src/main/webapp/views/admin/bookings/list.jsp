<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Đặt Sân - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/admin/admin.css" rel="stylesheet">
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
                                <li class="breadcrumb-item active text-primary fw-medium">Quản lý đặt sân</li>
                            </ol>
                        </nav>
                        <h2 class="page-title text-uppercase mb-0">
                            <i class="fas fa-calendar-check"></i>
                            Quản lý đặt sân
                            <span class="count-badge">Tổng: ${fn:length(bookings)}</span>
                        </h2>
                        <p class="page-subtitle">Theo dõi và quản lý tất cả các đơn đặt sân từ khách hàng.</p>
                    </div>
                </div>

                <!-- Status Filter Tabs -->
                <div class="d-flex flex-wrap gap-2 mb-4">
                    <a href="${pageContext.request.contextPath}/admin/bookings"
                       class="btn btn-sm rounded-pill px-3 shadow-sm ${empty currentStatus ? 'btn-primary' : 'btn-outline-secondary'}">
                        <i class="fas fa-list me-1"></i> Tất cả
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/bookings?status=PENDING"
                       class="btn btn-sm rounded-pill px-3 shadow-sm ${currentStatus == 'PENDING' ? 'btn-warning' : 'btn-outline-warning'}">
                        <i class="fas fa-clock me-1"></i> Chờ xử lý <span class="badge bg-white text-warning ms-1">${pendingCount}</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/bookings?status=CONFIRMED"
                       class="btn btn-sm rounded-pill px-3 shadow-sm ${currentStatus == 'CONFIRMED' ? 'btn-success' : 'btn-outline-success'}">
                        <i class="fas fa-check me-1"></i> Đã xác nhận <span class="badge bg-white text-success ms-1">${confirmedCount}</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/bookings?status=COMPLETED"
                       class="btn btn-sm rounded-pill px-3 shadow-sm ${currentStatus == 'COMPLETED' ? 'btn-info' : 'btn-outline-info'}">
                        <i class="fas fa-check-double me-1"></i> Hoàn thành <span class="badge bg-white text-info ms-1">${completedCount}</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/bookings?status=CANCELLED"
                       class="btn btn-sm rounded-pill px-3 shadow-sm ${currentStatus == 'CANCELLED' ? 'btn-danger' : 'btn-outline-danger'}">
                        <i class="fas fa-times me-1"></i> Đã hủy <span class="badge bg-white text-danger ms-1">${cancelledCount}</span>
                    </a>
                </div>

                <c:if test="${not empty sessionScope.success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${sessionScope.success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="success" scope="session" />
                </c:if>

                <c:if test="${not empty sessionScope.error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>${sessionScope.error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="error" scope="session" />
                </c:if>

                <div class="row">
                    <div class="col-12">
                        <div class="card border-0 shadow-sm rounded-4">
                            <div class="card-body p-0">
                                <div class="table-container">
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle">
                                        <thead>
                                            <tr>
                                                <th class="ps-4">Mã đơn</th>
                                                <th>Khách hàng</th>
                                                <th>Loại</th>
                                                <th>Tổng tiền</th>
                                                <th>Đặt cọc</th>
                                                <th>Trạng thái</th>
                                                <th>Ngày tạo</th>
                                                <th class="text-end pe-4">Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                            <c:forEach var="booking" items="${bookings}">
                                <tr>
                                    <td class="ps-4">
                                        <strong>#BK${booking.bookingID}</strong>
                                    </td>
                                    <td>
                                        <div>
                                            <div class="fw-bold">${not empty booking.customerName ? booking.customerName : 'N/A'}</div>
                                            <div class="small text-muted">
                                                <c:if test="${not empty booking.customerPhone}">
                                                    <i class="fas fa-phone me-1"></i>${booking.customerPhone}
                                                </c:if>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${booking.bookingType == 'EVENT'}">
                                                <span class="badge bg-purple-subtle text-purple">
                                                    <i class="fas fa-trophy me-1"></i>Sự kiện
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-info-subtle text-info">
                                                    <i class="fas fa-futbol me-1"></i>Lẻ
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="fw-bold text-success">
                                        <fmt:formatNumber value="${booking.totalPrice}" pattern="#,###"/>đ
                                    </td>
                                    <td class="text-muted">
                                        <fmt:formatNumber value="${booking.deposit}" pattern="#,###"/>đ
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${booking.status == 'PENDING'}">
                                                <span class="badge bg-warning-subtle text-warning">
                                                    <i class="fas fa-clock me-1"></i>Chờ xử lý
                                                </span>
                                            </c:when>
                                            <c:when test="${booking.status == 'CONFIRMED'}">
                                                <span class="badge bg-success-subtle text-success">
                                                    <i class="fas fa-check-circle me-1"></i>Đã xác nhận
                                                </span>
                                            </c:when>
                                            <c:when test="${booking.status == 'COMPLETED'}">
                                                <span class="badge bg-info-subtle text-info">
                                                    <i class="fas fa-check-double me-1"></i>Hoàn thành
                                                </span>
                                            </c:when>
                                            <c:when test="${booking.status == 'CANCELLED'}">
                                                <span class="badge bg-danger-subtle text-danger">
                                                    <i class="fas fa-times-circle me-1"></i>Đã hủy
                                                </span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                    <td class="text-muted small">
                                        <i class="far fa-calendar me-1"></i>
                                        ${booking.createdAt != null ? booking.createdAt.toString().substring(0, 10) : 'N/A'}
                                    </td>
                                    <td class="text-end pe-4">
                                        <div class="btn-group shadow-sm rounded-3 overflow-hidden">
                                            <a href="?action=detail&id=${booking.bookingID}"
                                               class="btn btn-white btn-sm border-end"
                                               title="Xem chi tiết">
                                                <i class="fas fa-eye text-info"></i>
                                            </a>
                                            <button class="btn btn-white btn-sm border-end"
                                                    data-bs-toggle="modal"
                                                    data-bs-target="#statusModal${booking.bookingID}"
                                                    title="Đổi trạng thái">
                                                <i class="fas fa-exchange-alt text-primary"></i>
                                            </button>
                                            <button class="btn btn-white btn-sm"
                                                    data-bs-toggle="modal"
                                                    data-bs-target="#deleteModal${booking.bookingID}"
                                                    title="Xóa">
                                                <i class="fas fa-trash text-danger"></i>
                                            </button>
                                        </div>

                                        <!-- Status Modal -->
                                        <div class="modal fade" id="statusModal${booking.bookingID}" tabindex="-1">
                                            <div class="modal-dialog modal-dialog-centered">
                                                <div class="modal-content border-0 shadow-lg">
                                                    <div class="modal-header bg-primary-subtle">
                                                        <h5 class="modal-title">
                                                            <i class="fas fa-exchange-alt me-2"></i>Cập nhật trạng thái
                                                        </h5>
                                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                    </div>
                                                    <div class="modal-body">
                                                        <p>Cập nhật trạng thái đơn: <strong>#BK${booking.bookingID}</strong></p>
                                                        <form method="post" action="${pageContext.request.contextPath}/admin/bookings">
                                                            <input type="hidden" name="action" value="updateStatus">
                                                            <input type="hidden" name="bookingID" value="${booking.bookingID}">
                                                            <select name="newStatus" class="form-select mb-3" required>
                                                                <option value="PENDING" ${booking.status == 'PENDING' ? 'selected' : ''}>Chờ xử lý</option>
                                                                <option value="CONFIRMED" ${booking.status == 'CONFIRMED' ? 'selected' : ''}>Đã xác nhận</option>
                                                                <option value="COMPLETED" ${booking.status == 'COMPLETED' ? 'selected' : ''}>Hoàn thành</option>
                                                                <option value="CANCELLED" ${booking.status == 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
                                                            </select>
                                                            <div class="d-flex gap-2 justify-content-end">
                                                                <button type="button" class="btn btn-light" data-bs-dismiss="modal">Hủy</button>
                                                                <button type="submit" class="btn btn-primary">Cập nhật</button>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Delete Modal -->
                                        <div class="modal fade" id="deleteModal${booking.bookingID}" tabindex="-1">
                                            <div class="modal-dialog modal-dialog-centered">
                                                <div class="modal-content border-0 shadow-lg confirm-delete-modal">
                                                    <div class="confirm-delete-modal-header d-flex justify-content-between align-items-start">
                                                        <div class="d-flex align-items-center">
                                                            <i class="fas fa-exclamation-triangle me-2"></i>
                                                            <div>
                                                                <h5 class="modal-title mb-0">Xác nhận xóa đơn đặt sân</h5>
                                                                <small>Hành động này không thể hoàn tác.</small>
                                                            </div>
                                                        </div>
                                                        <button type="button" class="btn-close btn-close-white ms-2" data-bs-dismiss="modal"></button>
                                                    </div>
                                                    <div class="confirm-delete-modal-body">
                                                        <p class="mb-3">Bạn có chắc chắn muốn xóa đơn: <strong>#BK${booking.bookingID}</strong>?</p>
                                                        <p class="text-muted small mb-0">Tất cả chi tiết đặt sân liên quan cũng sẽ bị xóa.</p>
                                                    </div>
                                                    <div class="modal-footer confirm-delete-modal-footer">
                                                        <button type="button" class="btn btn-light border" data-bs-dismiss="modal">
                                                            <i class="fas fa-times me-1"></i>Hủy
                                                        </button>
                                                        <form method="post" action="${pageContext.request.contextPath}/admin/bookings" class="d-inline">
                                                            <input type="hidden" name="action" value="delete">
                                                            <input type="hidden" name="id" value="${booking.bookingID}">
                                                            <button type="submit" class="btn btn-danger">
                                                                <i class="fas fa-trash me-1"></i>Xóa ngay
                                                            </button>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty bookings}">
                                <tr>
                                    <td colspan="8" class="text-center py-4 text-muted">
                                        <i class="fas fa-inbox fa-3x mb-3"></i>
                                        <p>Chưa có đơn đặt sân nào</p>
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
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
