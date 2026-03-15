<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo Cáo Doanh Thu - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/admin/admin.css" rel="stylesheet">
</head>
<body class="bg-light">

    <div class="admin-layout">

        <jsp:include page="../common/sidebar.jsp"></jsp:include>

        <div class="main-content">
            <div class="container-fluid px-4 py-4">

                <div class="d-flex justify-content-between align-items-end mb-4">
                    <div>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb mb-1">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard" class="text-decoration-none text-muted">Hệ thống</a></li>
                                <li class="breadcrumb-item active" aria-current="page">Báo cáo doanh thu</li>
                            </ol>
                        </nav>
                        <h2 class="fw-bold mb-0 text-dark">Báo Cáo Doanh Thu</h2>
                    </div>

                    <div class="d-flex align-items-center gap-3">
                        <!-- Export Excel Button -->
                        <a href="${pageContext.request.contextPath}/admin/reports?action=exportExcel&month=${selectedMonth}&year=${selectedYear}" 
                           class="btn btn-success shadow-sm rounded-pill px-4" id="exportExcelBtn">
                            <i class="fas fa-file-excel me-2"></i>Xuất Excel
                        </a>

                        <!-- Filter Bar -->
                        <form action="${pageContext.request.contextPath}/admin/reports" method="GET" class="unified-filter-bar d-flex align-items-center gap-3">
                            <input type="hidden" name="action" value="revenue">
                            <div class="d-flex align-items-center">
                                <label for="monthFilter" class="form-label mb-0 fw-medium text-muted me-2 small uppercase">Tháng</label>
                                <select name="month" id="monthFilter" class="form-select border-0 shadow-none bg-light" style="width: auto; cursor:pointer;" onchange="this.form.submit()">
                                    <c:forEach var="m" begin="1" end="12">
                                        <option value="${m}" ${m == selectedMonth ? 'selected' : ''}>Tháng ${m}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="d-flex align-items-center border-start ps-3">
                                <label for="yearFilter" class="form-label mb-0 fw-medium text-muted me-2 small uppercase">Năm</label>
                                <select name="year" id="yearFilter" class="form-select border-0 shadow-none bg-light" style="width: auto; cursor:pointer;" onchange="this.form.submit()">
                                    <c:forEach var="y" begin="2024" end="2030">
                                        <option value="${y}" ${y == selectedYear ? 'selected' : ''}>${y}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Clean Stats Row -->
                <div class="row g-4 mb-5">
                    <div class="col-md-6 col-lg-3">
                        <div class="stat-card-clean border-start border-4 border-primary">
                            <span class="stat-label">Doanh thu hôm nay</span>
                            <span class="stat-value text-dark"><fmt:formatNumber value="${dailyRevenue}" pattern="#,###"/>đ</span>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3">
                        <div class="stat-card-clean">
                            <span class="stat-label">Doanh thu tháng ${selectedMonth}</span>
                            <span class="stat-value text-success"><fmt:formatNumber value="${monthlyRevenue}" pattern="#,###"/>đ</span>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3">
                        <div class="stat-card-clean">
                            <span class="stat-label">Tổng đơn tháng ${selectedMonth}</span>
                            <span class="stat-value">${totalBookings}</span>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3">
                        <a href="${pageContext.request.contextPath}/admin/users?type=new_customers&month=${selectedMonth}&year=${selectedYear}" class="text-decoration-none h-100 d-block">
                            <div class="stat-card-clean">
                                <span class="stat-label">Khách mới tháng ${selectedMonth}</span>
                                <span class="stat-value">${newCustomers}</span>
                            </div>
                        </a>
                    </div>
                </div>

                <div class="row g-4 mb-4">
                    <!-- Daily Revenue Chart -->
                    <div class="col-lg-8">
                        <div class="bg-white p-4 rounded-3 border border-light shadow-sm h-100">
                            <div class="d-flex justify-content-between align-items-center mb-5">
                                <h5 class="fw-bold text-dark m-0">Doanh thu theo ngày</h5>
                                <span class="badge bg-light text-dark border">Tháng ${selectedMonth}/${selectedYear}</span>
                            </div>

                            <div class="css-chart-container" id="dailyChartContainer">
                                <!-- Grid lines -->
                                <div class="css-chart-grid">
                                    <div class="css-chart-grid-line"></div>
                                    <div class="css-chart-grid-line"></div>
                                    <div class="css-chart-grid-line"></div>
                                    <div class="css-chart-grid-line"></div>
                                    <div class="css-chart-grid-line"></div>
                                </div>

                                <!-- Bars — heights set by JS for correct proportions -->
                                <c:forEach var="entry" items="${dailyChart}" varStatus="status">
                                    <div class="css-chart-bar-wrapper">
                                        <div class="css-chart-bar daily-bar" data-value="${entry.value}" data-day="${entry.key}" style="height: 2px;">
                                            <div class="css-chart-tooltip">
                                                Ngày ${entry.key}: <fmt:formatNumber value="${entry.value}" pattern="#,###"/> đ
                                            </div>
                                        </div>
                                        
                                        <c:choose>
                                            <c:when test="${entry.key == 1 || entry.key % 5 == 0 || status.last}">
                                               <div class="css-chart-label" style="font-size: 0.7rem;">${entry.key}</div>
                                            </c:when>
                                            <c:otherwise>
                                               <div class="css-chart-label" style="opacity: 0;">-</div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>

                    <!-- Right Side: Booking Stats + Top Fields -->
                    <div class="col-lg-4">
                        <div class="d-flex flex-column gap-4 h-100">
                        
                            <!-- Booking Stats -->
                            <div class="bg-white p-4 rounded-3 border border-light shadow-sm">
                                <h6 class="fw-bold text-dark mb-4"><i class="fas fa-chart-pie text-secondary me-2"></i>Thống kê đơn tháng ${selectedMonth}</h6>
                                <div class="d-flex flex-column gap-3">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <span class="text-muted"><i class="fas fa-list text-secondary me-2"></i>Tổng đơn</span>
                                        <span class="fw-bold text-dark">${totalBookings}</span>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <span class="text-muted"><i class="fas fa-check-circle text-success me-2"></i>Thành công</span>
                                        <span class="fw-bold text-success">${completedBookings}</span>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <span class="text-muted"><i class="fas fa-times-circle text-danger me-2"></i>Đã hủy</span>
                                        <span class="fw-bold text-danger">${cancelledBookings}</span>
                                    </div>
                                    <c:if test="${totalBookings > 0}">
                                        <hr class="my-2 border-light">
                                        <div class="d-flex justify-content-between align-items-center mb-1">
                                            <span class="text-muted small fw-medium">Tỉ lệ thành công</span>
                                            <c:set var="successRate" value="${(completedBookings * 100) / totalBookings}" />
                                            <span class="fw-bold text-primary small">
                                                <fmt:formatNumber value="${successRate}" maxFractionDigits="1"/>%
                                            </span>
                                        </div>
                                        <div class="progress rounded-pill" style="height: 6px;">
                                            <div class="progress-bar bg-success" style="width: ${successRate}%;"></div>
                                            <div class="progress-bar bg-danger" style="width: ${100 - successRate}%;"></div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>

                            <!-- Top Fields Table -->
                            <div class="bg-white p-4 rounded-3 border border-light shadow-sm flex-fill">
                                <h6 class="fw-bold text-dark mb-4"><i class="fas fa-trophy text-warning me-2"></i>Sân thu nhiều nhất</h6>
                                <c:choose>
                                    <c:when test="${empty topFields}">
                                        <div class="text-center py-4">
                                            <p class="text-muted small mb-0">Chưa có dữ liệu cho tháng này.</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <table class="clean-table">
                                            <thead>
                                                <tr>
                                                    <th>Tên sân</th>
                                                    <th class="text-end">Doanh thu</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="field" items="${topFields}" varStatus="status">
                                                    <tr>
                                                        <td>
                                                            <div class="d-flex align-items-center">
                                                                <div class="fw-bold text-muted me-2 small" style="width: 15px;">${status.index + 1}.</div>
                                                                <div>
                                                                    <div class="fw-medium text-dark lh-1">${field.fieldName}</div>
                                                                    <small class="text-muted" style="font-size: 0.7rem;">${field.totalBookings} lượt</small>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td class="text-end fw-bold text-success small">
                                                            <fmt:formatNumber value="${field.totalRevenue}" pattern="#,###"/>đ
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                        </div>
                    </div>
                </div>

                <!-- Bottom Section: Top days + Quick actions -->
                <div class="row g-4 mb-4">
                    <!-- Top revenue days -->
                    <div class="col-lg-7">
                        <div class="bg-white p-4 rounded-3 border border-light shadow-sm h-100">
                            <h6 class="fw-bold text-dark mb-4"><i class="fas fa-calendar-check text-primary me-2"></i>Ngày doanh thu cao nhất — Tháng ${selectedMonth}</h6>
                            <c:choose>
                                <c:when test="${empty dailyChart}">
                                    <div class="text-center py-4 text-muted small">Chưa có dữ liệu.</div>
                                </c:when>
                                <c:otherwise>
                                    <div id="topDaysContainer">
                                        <!-- Rendered by JS from dailyChart data -->
                                    </div>
                                    <!-- Hidden data for JS -->
                                    <div id="dailyChartData" style="display:none;">
                                        <c:forEach var="entry" items="${dailyChart}">
                                            <span data-day="${entry.key}" data-value="${entry.value}"></span>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Quick actions for manager -->
                    <div class="col-lg-5">
                        <div class="quick-action-container shadow-sm">
                            <div class="quick-action-header">
                                <i class="fas fa-bolt"></i>
                                <h5>Thao tác nhanh</h5>
                            </div>
                            
                            <!-- Action 1: View Bookings -->
                            <a href="${pageContext.request.contextPath}/admin/bookings" class="quick-card">
                                <div class="quick-icon-box quick-icon-blue">
                                    <i class="fas fa-list-ul"></i>
                                </div>
                                <div class="quick-info">
                                    <span class="quick-title">Quản lý Booking</span>
                                    <span class="quick-desc">Xem và xử lý tất cả đơn đặt sân</span>
                                </div>
                                <i class="fas fa-chevron-right quick-chevron"></i>
                            </a>

                            <!-- Action 2: Export Excel -->
                            <a href="${pageContext.request.contextPath}/admin/reports?action=exportExcel&month=${selectedMonth}&year=${selectedYear}" class="quick-card">
                                <div class="quick-icon-box quick-icon-green">
                                    <i class="fas fa-file-excel"></i>
                                </div>
                                <div class="quick-info">
                                    <span class="quick-title">Xuất file Excel</span>
                                    <span class="quick-desc">Tải báo cáo chi tiết tháng ${selectedMonth}</span>
                                </div>
                                <i class="fas fa-chevron-right quick-chevron"></i>
                            </a>

                            <!-- Action 3: View Customers -->
                            <a href="${pageContext.request.contextPath}/admin/users?role=CUSTOMER" class="quick-card">
                                <div class="quick-icon-box quick-icon-purple">
                                    <i class="fas fa-users"></i>
                                </div>
                                <div class="quick-info">
                                    <span class="quick-title">Danh sách khách hàng</span>
                                    <span class="quick-desc">Quản lý thông tin người dùng</span>
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

    <!-- Fix: Use JS to calculate bar heights correctly (avoids JSTL integer division) -->
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        // ===== Daily chart bars =====
        var container = document.getElementById('dailyChartContainer');
        if (container) {
            var bars = container.querySelectorAll('.css-chart-bar');
            var maxVal = 0;
            bars.forEach(function(bar) {
                var val = parseFloat(bar.getAttribute('data-value')) || 0;
                if (val > maxVal) maxVal = val;
            });

            if (maxVal > 0) {
                var today = new Date();
                var currentDay = today.getDate();
                var currentMonth = today.getMonth() + 1;
                var currentYear = today.getFullYear();
                var selectedMonth = parseInt('${selectedMonth}') || 0;
                var selectedYear = parseInt('${selectedYear}') || 0;

                bars.forEach(function(bar) {
                    var val = parseFloat(bar.getAttribute('data-value')) || 0;
                    var day = parseInt(bar.getAttribute('data-day')) || 0;
                    var pct = (val / maxVal) * 100;
                    bar.style.height = Math.max(pct, 0.5) + '%';

                    if (selectedYear === currentYear && selectedMonth === currentMonth && day === currentDay) {
                        bar.classList.add('active');
                        var label = bar.parentElement.querySelector('.css-chart-label');
                        if (label) { label.classList.add('fw-bold', 'text-dark'); label.style.opacity = '1'; }
                    } else {
                        bar.classList.add('inactive');
                    }
                });
            }
        }

        // ===== Top 5 days by revenue =====
        var dataContainer = document.getElementById('dailyChartData');
        var topDaysContainer = document.getElementById('topDaysContainer');
        if (dataContainer && topDaysContainer) {
            var spans = dataContainer.querySelectorAll('span[data-day]');
            var days = [];
            spans.forEach(function(s) {
                var v = parseFloat(s.getAttribute('data-value')) || 0;
                if (v > 0) days.push({ day: parseInt(s.getAttribute('data-day')), value: v });
            });
            days.sort(function(a, b) { return b.value - a.value; });
            var top5 = days.slice(0, 5);

            if (top5.length === 0) {
                topDaysContainer.innerHTML = '<div class="text-center py-3 text-muted small">Chưa có ngày nào có doanh thu.</div>';
                return;
            }

            var maxTopVal = top5[0].value;
            var medals = ['🥇','🥈','🥉','4.','5.'];
            var colors = ['#4f46e5','#6366f1','#818cf8','#a5b4fc','#c7d2fe'];
            var html = '<div class="d-flex flex-column gap-2">';
            top5.forEach(function(item, i) {
                var pct = Math.round((item.value / maxTopVal) * 100);
                var formatted = item.value >= 1000000
                    ? (item.value / 1000000).toFixed(1).replace(/\.0$/, '') + ' triệu đ'
                    : item.value.toLocaleString('vi-VN') + 'đ';
                html += '<div class="d-flex align-items-center gap-3">'
                    + '<div style="width:28px;text-align:center;font-size:1rem;flex-shrink:0;">' + medals[i] + '</div>'
                    + '<div style="width:60px;flex-shrink:0;" class="text-muted small fw-medium">Ngày ' + item.day + '</div>'
                    + '<div class="flex-fill">'
                    +   '<div class="d-flex justify-content-between mb-1">'
                    +     '<div class="progress rounded-pill flex-fill me-2" style="height:8px;">'
                    +       '<div class="progress-bar rounded-pill" style="width:' + pct + '%;background:' + colors[i] + ';"></div>'
                    +     '</div>'
                    +     '<span class="fw-bold text-dark" style="font-size:0.78rem;white-space:nowrap;">' + formatted + '</span>'
                    +   '</div>'
                    + '</div>'
                    + '</div>';
            });
            html += '</div>';
            topDaysContainer.innerHTML = html;
        }
    });
    </script>

</body>
</html>
