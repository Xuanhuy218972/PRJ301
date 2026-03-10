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
    <link href="${pageContext.request.contextPath}/assets/css/admin/admin.css" rel="stylesheet">
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

                <!-- Stats Grid (Z-Pattern Priority) -->
                <div class="row g-3 mb-4">
                    <c:if test="${sessionScope.account.role == 'ADMIN'}">
                        <div class="col-md-6 col-lg-3">
                            <div class="card stat-card stat-card-danger shadow-sm h-100 border-0">
                                <div class="card-body d-flex justify-content-between align-items-center p-4">
                                    <div>
                                        <h6 class="text-muted text-uppercase small mb-1">Doanh thu tháng này</h6>
                                        <h3 class="fw-bold mb-0 text-danger"><fmt:formatNumber value="${monthlyRevenue}" pattern="#,###"/>đ</h3>
                                    </div>
                                    <i class="fas fa-wallet widget-icon text-danger opacity-75"></i>
                                </div>
                            </div>
                        </div>
                    </c:if>
                    
                    <div class="col-md-6 col-lg-3">
                        <div class="card stat-card stat-card-success shadow-sm h-100 border-0">
                            <div class="card-body d-flex justify-content-between align-items-center p-4">
                                <div>
                                    <h6 class="text-muted text-uppercase small mb-1">Booking hôm nay</h6>
                                    <h2 class="fw-bold mb-0">${bookingsToday}</h2>
                                </div>
                                <i class="fas fa-calendar-check widget-icon text-success opacity-75"></i>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-6 col-lg-3">
                        <a href="${pageContext.request.contextPath}/admin/users?role=CUSTOMER" class="text-decoration-none">
                            <div class="card stat-card stat-card-warning shadow-sm h-100 border-0">
                                <div class="card-body d-flex justify-content-between align-items-center p-4">
                                    <div>
                                        <h6 class="text-muted text-uppercase small mb-1">Tổng khách hàng</h6>
                                        <h2 class="fw-bold mb-0">${totalCustomers}</h2>
                                    </div>
                                    <i class="fas fa-users widget-icon text-warning opacity-75"></i>
                                </div>
                            </div>
                        </a>
                    </div>
                    
                    <div class="col-md-6 col-lg-3">
                        <div class="card stat-card stat-card-primary shadow-sm h-100 border-0">
                            <div class="card-body d-flex justify-content-between align-items-center p-4">
                                <div>
                                    <h6 class="text-muted text-uppercase small mb-1">Tổng số sân</h6>
                                    <h2 class="fw-bold mb-0">${totalFields}</h2>
                                </div>
                                <i class="fas fa-futbol widget-icon text-primary opacity-75"></i>
                            </div>
                        </div>
                    </div>
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
                                <table class="table clean-table align-middle mb-0">
                                    <thead class="table-light rounded-top">
                                        <tr>
                                            <th class="ps-4">Mã Booking</th>
                                            <th>Khách hàng</th>
                                            <th>Loại</th>
                                            <th>Tổng tiền</th>
                                            <th>Trạng thái</th>
                                            <th class="text-end pe-4">Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="booking" items="${latestBookings}">
                                            <tr class="bg-white hover-shadow transition-base">
                                                <td class="ps-4">
                                                    <span class="fw-bold text-primary">#BK${booking.bookingID}</span>
                                                </td>
                                                <td class="fw-medium text-dark">${not empty booking.customerName ? booking.customerName : 'N/A'}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${booking.bookingType == 'EVENT'}"><span class="text-secondary"><i class="fas fa-calendar-day me-1"></i>Sự kiện</span></c:when>
                                                        <c:otherwise><span class="text-secondary"><i class="fas fa-clock me-1"></i>Lẻ</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="fw-bold text-success">
                                                    <fmt:formatNumber value="${booking.totalPrice}" pattern="#,###"/>đ
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${booking.status == 'PENDING'}">
                                                            <span class="badge bg-warning text-dark px-3 py-2 rounded-pill shadow-sm"><i class="fas fa-hourglass-half me-1"></i>Chờ xử lý</span>
                                                        </c:when>
                                                        <c:when test="${booking.status == 'CONFIRMED'}">
                                                            <span class="badge bg-success text-white px-3 py-2 rounded-pill shadow-sm"><i class="fas fa-check me-1"></i>Đã xác nhận</span>
                                                        </c:when>
                                                        <c:when test="${booking.status == 'COMPLETED'}">
                                                            <span class="badge bg-info text-dark px-3 py-2 rounded-pill shadow-sm"><i class="fas fa-check-double me-1"></i>Hoàn thành</span>
                                                        </c:when>
                                                        <c:when test="${booking.status == 'CANCELLED'}">
                                                            <span class="badge bg-danger text-white px-3 py-2 rounded-pill shadow-sm"><i class="fas fa-times me-1"></i>Đã hủy</span>
                                                        </c:when>
                                                    </c:choose>
                                                </td>
                                                <td class="text-end pe-4">
                                                    <a href="${pageContext.request.contextPath}/admin/bookings?action=detail&id=${booking.bookingID}" 
                                                       class="btn btn-sm btn-light rounded-circle shadow-sm hover-primary d-inline-flex align-items-center justify-content-center" style="width: 32px; height: 32px;" title="Xem chi tiết">
                                                        <i class="fas fa-chevron-right"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>

                                        <c:if test="${empty latestBookings}">
                                            <tr>
                                                <td colspan="6" class="text-center py-5 text-muted bg-white">
                                                    <div class="d-flex flex-column align-items-center">
                                                        <div class="bg-light rounded-circle p-4 mb-3">
                                                            <i class="fas fa-inbox fa-3x text-secondary opacity-50"></i>
                                                        </div>
                                                        <h6 class="fw-bold text-dark">Chưa có đơn đặt sân nào</h6>
                                                        <p class="small mb-0">Các đơn đặt sân mới sẽ hiển thị tại đây.</p>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Sidebar: Occupancy -->
                    <div class="col-lg-4">
                        <!-- Court Occupancy -->
                        <div class="dashboard-side-card">
                            <h6 class="card-title mb-3"><i class="fas fa-futbol me-1"></i> Trạng thái sân</h6>
                            <c:set var="occupancyPct" value="${totalFields > 0 ? (activeFields * 100 / totalFields) : 0}" />
                            <div class="occupancy-label">Hiện có ${activeFields}/${totalFields} sân đang hoạt động</div>
                            <div class="progress rounded-pill progress-sm">
                                <div class="progress-bar bg-success rounded-pill" role="progressbar" style="width: ${occupancyPct}%;" aria-valuenow="${occupancyPct}" aria-valuemin="0" aria-valuemax="100"></div>
                            </div>
                            <div class="occupancy-value mt-2"><fmt:formatNumber value="${occupancyPct}" maxFractionDigits="0"/>% đang hoạt động</div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

</body>
</html>
