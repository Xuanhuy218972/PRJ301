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

                <!-- ===== Alert messages ===== -->
                <c:if test="${not empty sessionScope.error}">
                    <div class="alert alert-danger alert-dismissible fade show mb-3" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>${sessionScope.error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="error" scope="session"/>
                </c:if>
                <c:if test="${not empty sessionScope.success}">
                    <div class="alert alert-success alert-dismissible fade show mb-3" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${sessionScope.success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="success" scope="session"/>
                </c:if>

                <!-- Stats Grid -->
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
                        <c:choose>
                            <c:when test="${sessionScope.account.role == 'ADMIN'}">
                                <a href="${pageContext.request.contextPath}/admin/users?role=CUSTOMER" class="text-decoration-none">
                            </c:when>
                            <c:otherwise>
                                <a class="text-decoration-none" style="cursor: default;">
                            </c:otherwise>
                        </c:choose>
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


                <!-- ===== ADMIN: 12-Month Revenue Chart ===== -->
                <c:if test="${sessionScope.account.role == 'ADMIN' && not empty monthlyChart}">
                <div class="row g-4 mb-4">
                    <div class="col-12">
                        <div class="bg-white p-4 rounded-3 border border-light shadow-sm">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <h5 class="fw-bold text-dark m-0"><i class="fas fa-chart-bar text-primary me-2"></i>Doanh thu theo tháng</h5>
                                <span class="badge bg-light text-dark border">Năm ${chartYear}</span>
                            </div>

                            <div class="css-chart-container" id="monthlyChartContainer">
                                <!-- Grid lines -->
                                <div class="css-chart-grid">
                                    <div class="css-chart-grid-line"></div>
                                    <div class="css-chart-grid-line"></div>
                                    <div class="css-chart-grid-line"></div>
                                    <div class="css-chart-grid-line"></div>
                                    <div class="css-chart-grid-line"></div>
                                </div>

                                <!-- Bars rendered by JS for correct proportions -->
                                <c:forEach var="entry" items="${monthlyChart}">
                                    <div class="css-chart-bar-wrapper">
                                        <div class="css-chart-bar" data-value="${entry.value}" style="height: 2px;">
                                            <div class="css-chart-tooltip">
                                                Tháng ${entry.key}: <fmt:formatNumber value="${entry.value}" pattern="#,###"/> đ
                                            </div>
                                        </div>
                                        <div class="css-chart-label">T${entry.key}</div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>
                </c:if>

                <!-- Main content: Bookings table + Sidebar -->
                <div class="row g-4">
                    <!-- Recent Bookings -->
                    <div class="col-lg-8">
                        <div class="table-container h-100">
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

                    <!-- Sidebar Area -->
                    <div class="col-lg-4">
                        <!-- ===== Quick Actions (Vertical Cards) ===== -->
                        <div class="quick-action-container mb-4 shadow-sm">
                            <div class="quick-action-header">
                                <i class="fas fa-bolt"></i>
                                <h5>Thao tác nhanh</h5>
                            </div>
                            
                            <!-- Action 1: Pending Bookings -->
                            <a href="${pageContext.request.contextPath}/admin/bookings?status=PENDING" class="quick-card">
                                <div class="quick-icon-box quick-icon-blue">
                                    <i class="fas fa-calendar-check"></i>
                                </div>
                                <div class="quick-info">
                                    <span class="quick-title">Xem các booking đang xử lý</span>
                                    <span class="quick-desc">Quản lý & xác nhận ${pendingBookings} đơn chờ</span>
                                </div>
                                <i class="fas fa-chevron-right quick-chevron"></i>
                            </a>

                            <!-- Action 2: Export Excel -->
                            <a href="${pageContext.request.contextPath}/admin/reports?action=export" class="quick-card">
                                <div class="quick-icon-box quick-icon-green">
                                    <i class="fas fa-file-excel"></i>
                                </div>
                                <div class="quick-info">
                                    <span class="quick-title">Xuất Excel tháng ${currentMonth}</span>
                                    <span class="quick-desc">Tải báo cáo doanh thu chi tiết</span>
                                </div>
                                <i class="fas fa-chevron-right quick-chevron"></i>
                            </a>

                            <!-- Action 3: New Customers -->
                            <a href="${pageContext.request.contextPath}/admin/users?role=CUSTOMER" class="quick-card">
                                <div class="quick-icon-box quick-icon-purple">
                                    <i class="fas fa-user-plus"></i>
                                </div>
                                <div class="quick-info">
                                    <span class="quick-title">Khách mới tháng ${currentMonth}</span>
                                    <span class="quick-desc">${newCustomersThisMonth} khách đăng ký — xem danh sách</span>
                                </div>
                                <i class="fas fa-chevron-right quick-chevron"></i>
                            </a>

                            <!-- Action 4: New Contacts -->
                            <a href="${pageContext.request.contextPath}/admin/contacts?status=NEW" class="quick-card">
                                <div class="quick-icon-box quick-icon-yellow">
                                    <i class="fas fa-envelope"></i>
                                </div>
                                <div class="quick-info">
                                    <span class="quick-title">Tin nhắn liên hệ chưa đọc</span>
                                    <span class="quick-desc">Xem & xử lý ${newContacts} yêu cầu từ khách</span>
                                </div>
                                <i class="fas fa-chevron-right quick-chevron"></i>
                            </a>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Chart JS: calculate bar heights correctly to avoid JSTL integer division -->
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        var container = document.getElementById('monthlyChartContainer');
        if (!container) return;

        var bars = container.querySelectorAll('.css-chart-bar');
        if (bars.length === 0) return;

        // Find max value
        var maxVal = 0;
        bars.forEach(function(bar) {
            var val = parseFloat(bar.getAttribute('data-value')) || 0;
            if (val > maxVal) maxVal = val;
        });

        if (maxVal === 0) return;

        // Current month (1-indexed)
        var currentMonth = new Date().getMonth() + 1;

        bars.forEach(function(bar, index) {
            var val = parseFloat(bar.getAttribute('data-value')) || 0;
            var pct = (val / maxVal) * 100;
            bar.style.height = Math.max(pct, 2) + '%';

            // Highlight current month
            if (index + 1 === currentMonth) {
                bar.classList.add('active');
            } else {
                bar.classList.add('inactive');
            }

            // Add value label on top of bar if > 0
            if (val > 0) {
                var label = document.createElement('div');
                label.className = 'css-chart-value-label';
                label.textContent = formatShort(val);
                bar.appendChild(label);
            }
        });

        function formatShort(val) {
            if (val >= 1000000) return (val / 1000000).toFixed(1).replace(/\.0$/, '') + 'tr';
            if (val >= 1000) return (val / 1000).toFixed(0) + 'k';
            return val;
        }
    });
    </script>

</body>
</html>
