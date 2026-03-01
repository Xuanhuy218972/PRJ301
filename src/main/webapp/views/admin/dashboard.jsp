<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tổng Quan Hệ Thống - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/admin.css" rel="stylesheet">
</head>
<body>

    <div class="admin-layout">

        <jsp:include page="common/sidebar.jsp"></jsp:include>

        <div class="main-content">
            <div class="container-fluid px-0">
                <jsp:useBean id="now" class="java.util.Date" scope="page"/>

                <!-- Welcome Section -->
                <div class="dashboard-header d-flex flex-wrap justify-content-between align-items-center gap-3">
                    <div>
                        <h3 class="dashboard-title text-uppercase mb-1">HỆ THỐNG ĐẶT SÂN</h3>
                        <p class="dashboard-subtitle mb-0">
                            Chào mừng quay trở lại, <strong>${sessionScope.account.username}</strong>! Chúc bạn một ngày làm việc hiệu quả.
                        </p>
                    </div>
                    <div class="header-date bg-white px-3 py-2 rounded-3 shadow-sm border">
                        <i class="fas fa-calendar-alt text-primary me-2"></i>
                        <span class="fw-bold"><fmt:formatDate value="${now}" pattern="dd/MM/yyyy"/></span>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="quick-actions-row d-flex flex-wrap gap-2">
                    <a href="${pageContext.request.contextPath}/admin/bookings" class="quick-action-btn">
                        <i class="fas fa-plus"></i> Quản lý Booking
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/users" class="quick-action-btn">
                        <i class="fas fa-wallet"></i> Kiểm tra ví / Người dùng
                    </a>
                    <c:if test="${sessionScope.account.role == 'ADMIN'}">
                        <a href="${pageContext.request.contextPath}/admin/reports" class="quick-action-btn">
                            <i class="fas fa-file-export"></i> Xem báo cáo doanh thu
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/users" class="quick-action-btn">
                            <i class="fas fa-user-shield"></i> Quản lý khách hàng
                        </a>
                    </c:if>
                </div>

                <!-- Stats Grid -->
                <div class="row g-3 mb-4">
                    <div class="col-md-6 col-lg-3">
                        <div class="card stat-card stat-card-primary shadow-sm h-100 border-0">
                            <div class="card-body d-flex justify-content-between align-items-center p-4">
                                <div>
                                    <h6 class="text-muted text-uppercase small mb-1">Tổng số sân</h6>
                                    <h2 class="fw-bold mb-0">${totalFields}</h2>
                                </div>
                                <i class="fas fa-futbol widget-icon text-primary"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3">
                        <div class="card stat-card stat-card-success shadow-sm h-100 border-0">
                            <div class="card-body d-flex justify-content-between align-items-center p-4">
                                <div>
                                    <h6 class="text-muted text-uppercase small mb-1">Booking hôm nay</h6>
                                    <h2 class="fw-bold mb-0 text-success">${bookingsToday}</h2>
                                </div>
                                <i class="fas fa-calendar-check widget-icon text-success"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3">
                        <div class="card stat-card stat-card-warning shadow-sm h-100 border-0">
                            <div class="card-body d-flex justify-content-between align-items-center p-4">
                                <div>
                                    <h6 class="text-muted text-uppercase small mb-1">Tổng khách hàng</h6>
                                    <h2 class="fw-bold mb-0">${totalCustomers}</h2>
                                </div>
                                <i class="fas fa-users widget-icon text-warning"></i>
                            </div>
                        </div>
                    </div>
                    <c:if test="${sessionScope.account.role == 'ADMIN'}">
                        <div class="col-md-6 col-lg-3">
                            <div class="card stat-card stat-card-danger shadow-sm h-100 border-0">
                                <div class="card-body d-flex justify-content-between align-items-center p-4">
                                    <div>
                                        <h6 class="text-muted text-uppercase small mb-1">Doanh thu tháng</h6>
                                        <h3 class="fw-bold mb-0 text-danger"><fmt:formatNumber value="${monthlyRevenue}" pattern="#,###"/>đ</h3>
                                    </div>
                                    <i class="fas fa-wallet widget-icon text-danger"></i>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>

                <!-- Main content: Bookings table (70%) + Sidebar (30%) -->
                <div class="row g-4">
                    <!-- Recent Bookings -->
                    <div class="col-lg-8">
                        <div class="table-container">
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h5 class="fw-bold mb-0"><i class="fas fa-clock text-primary me-2"></i>Lượt đặt sân gần đây</h5>
                                <a href="${pageContext.request.contextPath}/admin/bookings" class="btn btn-primary btn-sm shadow-sm rounded-pill">Xem tất cả</a>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Mã Booking</th>
                                            <th>Khách hàng</th>
                                            <th>Loại</th>
                                            <th>Tổng tiền</th>
                                            <th>Trạng thái</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="booking" items="${latestBookings}">
                                            <tr>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/admin/bookings?action=detail&id=${booking.bookingID}" class="text-decoration-none">
                                                        <strong>#BK${booking.bookingID}</strong>
                                                    </a>
                                                </td>
                                                <td>${not empty booking.customerName ? booking.customerName : 'N/A'}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${booking.bookingType == 'EVENT'}">Sự kiện</c:when>
                                                        <c:otherwise>Lẻ</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="fw-bold text-success">
                                                    <fmt:formatNumber value="${booking.totalPrice}" pattern="#,###"/>đ
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${booking.status == 'PENDING'}">
                                                            <span class="badge bg-warning bg-opacity-10 text-dark">Chờ xử lý</span>
                                                        </c:when>
                                                        <c:when test="${booking.status == 'CONFIRMED'}">
                                                            <span class="badge bg-success bg-opacity-10 text-success">Đã xác nhận</span>
                                                        </c:when>
                                                        <c:when test="${booking.status == 'COMPLETED'}">
                                                            <span class="badge bg-info bg-opacity-10 text-info">Hoàn thành</span>
                                                        </c:when>
                                                        <c:when test="${booking.status == 'CANCELLED'}">
                                                            <span class="badge bg-danger bg-opacity-10 text-danger">Đã hủy</span>
                                                        </c:when>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>

                                        <c:if test="${empty latestBookings}">
                                            <tr>
                                                <td colspan="5" class="text-center py-4 text-muted">
                                                    <i class="fas fa-inbox fa-2x mb-2"></i>
                                                    <p class="mb-0">Chưa có đơn đặt sân nào</p>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Sidebar: Quick Actions + Occupancy + Alerts -->
                    <div class="col-lg-4">
                        <!-- Thao tac nhanh -->
                        <div class="dashboard-side-card">
                            <h6 class="card-title mb-3"><i class="fas fa-bolt me-1"></i> Thao tác nhanh</h6>
                            <div class="d-flex flex-column gap-2">
                                <a href="${pageContext.request.contextPath}/admin/bookings" class="quick-action-btn"><i class="fas fa-calendar-check"></i> Quản lý đặt sân</a>
                                <a href="${pageContext.request.contextPath}/admin/users" class="quick-action-btn"><i class="fas fa-user-plus"></i> Quản lý người dùng</a>
                                <a href="${pageContext.request.contextPath}/admin/fields" class="quick-action-btn"><i class="fas fa-futbol"></i> Quản lý sân bóng</a>
                            </div>
                        </div>

                        <!-- Court Occupancy -->
                        <div class="dashboard-side-card">
                            <h6 class="card-title mb-3"><i class="fas fa-futbol me-1"></i> Trạng thái sân</h6>
                            <c:set var="occupancyPct" value="${totalFields > 0 ? (activeFields * 100 / totalFields) : 0}" />
                            <div class="occupancy-label">Hiện có ${activeFields}/${totalFields} sân đang hoạt động</div>
                            <div class="progress rounded-pill progress-sm">
                                <div class="progress-bar bg-primary rounded-pill" role="progressbar" style="width: ${occupancyPct}%;" aria-valuenow="${occupancyPct}" aria-valuemin="0" aria-valuemax="100"></div>
                            </div>
                            <div class="occupancy-value mt-2"><fmt:formatNumber value="${occupancyPct}" maxFractionDigits="0"/>% đang hoạt động</div>
                        </div>

                        <!-- System Alerts -->
                        <div class="dashboard-side-card">
                            <h6 class="card-title mb-3"><i class="fas fa-bell me-1"></i> Thống kê nhanh</h6>
                            <div class="alert-list">
                                <div class="alert-item alert-topup">
                                    <span class="alert-icon"><i class="fas fa-coins"></i></span>
                                    Doanh thu tháng này: <strong><fmt:formatNumber value="${monthlyRevenue}" pattern="#,###"/>đ</strong>
                                </div>
                                <div class="alert-item alert-booking">
                                    <span class="alert-icon"><i class="fas fa-calendar-plus"></i></span>
                                    Booking hôm nay: <strong>${bookingsToday} đơn</strong>
                                </div>
                                <div class="alert-item alert-cancel">
                                    <span class="alert-icon"><i class="fas fa-users"></i></span>
                                    Tổng khách hàng: <strong>${totalCustomers} người</strong>
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
