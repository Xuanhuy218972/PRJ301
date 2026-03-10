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
    <link href="${pageContext.request.contextPath}/assets/css/admin/admin.css" rel="stylesheet"></head>
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

                    <!-- Unified Filter Bar -->
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
                    <!-- Pure CSS Monthly Revenue Chart -->
                    <div class="col-lg-8">
                        <div class="bg-white p-4 rounded-3 border border-light shadow-sm h-100">
                            <div class="d-flex justify-content-between align-items-center mb-5">
                                <h5 class="fw-bold text-dark m-0">Doanh thu theo ngày</h5>
                                <span class="badge bg-light text-dark border">Tháng ${selectedMonth}/${selectedYear}</span>
                            </div>

                            <c:set var="maxRevenue" value="0" />
                            <c:forEach var="entry" items="${dailyChart}">
                                <c:if test="${entry.value > maxRevenue}">
                                    <c:set var="maxRevenue" value="${entry.value}" />
                                </c:if>
                            </c:forEach>
                            <c:if test="${maxRevenue == 0}">
                                <c:set var="maxRevenue" value="1" />
                            </c:if>

                            <div class="css-chart-container">
                                <!-- Grid lines -->
                                <div class="css-chart-grid">
                                    <div class="css-chart-grid-line"></div>
                                    <div class="css-chart-grid-line"></div>
                                    <div class="css-chart-grid-line"></div>
                                    <div class="css-chart-grid-line"></div>
                                    <div class="css-chart-grid-line"></div>
                                </div>

                                <!-- Bars -->
                                <c:forEach var="entry" items="${dailyChart}" varStatus="status">
                                    <c:set var="pct" value="${(entry.value / maxRevenue) * 100}" />
                                    <!-- Xác định hôm nay (cùng năm/tháng/ngày hiện tại) -->
                                    <c:set var="isToday" value="false" />
                                    <jsp:useBean id="now" class="java.util.Date" />
                                    <fmt:formatDate var="currentDay" value="${now}" pattern="d" />
                                    <fmt:formatDate var="currentMonth" value="${now}" pattern="M" />
                                    <fmt:formatDate var="currentYear" value="${now}" pattern="yyyy" />
                                    
                                    <c:if test="${selectedYear == currentYear && selectedMonth == currentMonth && entry.key.toString() == currentDay}">
                                        <c:set var="isToday" value="true" />
                                    </c:if>
                                    
                                    <div class="css-chart-bar-wrapper">
                                        <div class="css-chart-bar daily-bar ${isToday ? 'active' : 'inactive'}" style="height: ${pct > 0 ? pct : 0}%;">
                                            <div class="css-chart-tooltip">
                                                Ngày ${entry.key}: <fmt:formatNumber value="${entry.value}" pattern="#,###"/> đ
                                            </div>
                                        </div>
                                        
                                        <!-- Show label only every 2nd or 3rd day, or specifically important days to prevent overlap -->
                                        <c:choose>
                                            <c:when test="${entry.key == 1 || entry.key % 5 == 0 || status.last}">
                                               <div class="css-chart-label ${isToday ? 'fw-bold text-dark' : ''}" style="font-size: 0.7rem;">${entry.key}</div>
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

            </div>
        </div>
    </div>

</body>
</html>
