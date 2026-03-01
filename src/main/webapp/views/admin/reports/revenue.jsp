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
                                <li class="breadcrumb-item active text-primary fw-medium">Báo cáo doanh thu</li>
                            </ol>
                        </nav>
                        <h2 class="page-title text-uppercase mb-0">
                            <i class="fas fa-chart-pie"></i>
                            Báo cáo doanh thu
                        </h2>
                        <p class="page-subtitle">Thống kê doanh thu, lượt đặt sân và khách hàng theo tháng/năm.</p>
                    </div>
                </div>

                <!-- Filter Form -->
                <div class="card border-0 shadow-sm rounded-4 mb-4">
                    <div class="card-body p-4">
                        <form method="get" action="${pageContext.request.contextPath}/admin/reports" class="d-flex flex-wrap align-items-end gap-3">
                            <div>
                                <label class="form-label small fw-bold text-muted">Năm</label>
                                <select name="year" class="form-select" style="min-width: 120px;">
                                    <c:forEach var="y" items="${availableYears}">
                                        <option value="${y}" ${y.toString() == selectedYear ? 'selected' : ''}>${y}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div>
                                <label class="form-label small fw-bold text-muted">Tháng</label>
                                <select name="month" class="form-select" style="min-width: 120px;">
                                    <option value="1" ${selectedMonth == '1' ? 'selected' : ''}>Tháng 1</option>
                                    <option value="2" ${selectedMonth == '2' ? 'selected' : ''}>Tháng 2</option>
                                    <option value="3" ${selectedMonth == '3' ? 'selected' : ''}>Tháng 3</option>
                                    <option value="4" ${selectedMonth == '4' ? 'selected' : ''}>Tháng 4</option>
                                    <option value="5" ${selectedMonth == '5' ? 'selected' : ''}>Tháng 5</option>
                                    <option value="6" ${selectedMonth == '6' ? 'selected' : ''}>Tháng 6</option>
                                    <option value="7" ${selectedMonth == '7' ? 'selected' : ''}>Tháng 7</option>
                                    <option value="8" ${selectedMonth == '8' ? 'selected' : ''}>Tháng 8</option>
                                    <option value="9" ${selectedMonth == '9' ? 'selected' : ''}>Tháng 9</option>
                                    <option value="10" ${selectedMonth == '10' ? 'selected' : ''}>Tháng 10</option>
                                    <option value="11" ${selectedMonth == '11' ? 'selected' : ''}>Tháng 11</option>
                                    <option value="12" ${selectedMonth == '12' ? 'selected' : ''}>Tháng 12</option>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-primary btn-sm rounded-pill px-4 shadow-sm">
                                <i class="fas fa-filter me-1"></i> Xem báo cáo
                            </button>
                        </form>
                    </div>
                </div>

                <!-- Stats Cards -->
                <div class="row g-3 mb-4">
                    <div class="col-md-6 col-lg-3">
                        <div class="card stat-card stat-card-primary shadow-sm h-100 border-0">
                            <div class="card-body d-flex justify-content-between align-items-center p-4">
                                <div>
                                    <h6 class="text-muted text-uppercase small mb-1">Doanh thu tháng ${selectedMonth}</h6>
                                    <h3 class="fw-bold mb-0 text-primary"><fmt:formatNumber value="${monthlyRevenue}" pattern="#,###"/>đ</h3>
                                </div>
                                <i class="fas fa-wallet widget-icon text-primary"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3">
                        <div class="card stat-card stat-card-success shadow-sm h-100 border-0">
                            <div class="card-body d-flex justify-content-between align-items-center p-4">
                                <div>
                                    <h6 class="text-muted text-uppercase small mb-1">Tổng đơn tháng ${selectedMonth}</h6>
                                    <h2 class="fw-bold mb-0 text-success">${totalBookings}</h2>
                                </div>
                                <i class="fas fa-calendar-check widget-icon text-success"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3">
                        <div class="card stat-card stat-card-warning shadow-sm h-100 border-0">
                            <div class="card-body d-flex justify-content-between align-items-center p-4">
                                <div>
                                    <h6 class="text-muted text-uppercase small mb-1">Khách mới tháng ${selectedMonth}</h6>
                                    <h2 class="fw-bold mb-0">${newCustomers}</h2>
                                </div>
                                <i class="fas fa-user-plus widget-icon text-warning"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3">
                        <div class="card stat-card stat-card-danger shadow-sm h-100 border-0">
                            <div class="card-body d-flex justify-content-between align-items-center p-4">
                                <div>
                                    <h6 class="text-muted text-uppercase small mb-1">Doanh thu cả năm ${selectedYear}</h6>
                                    <h3 class="fw-bold mb-0 text-danger"><fmt:formatNumber value="${yearlyRevenue}" pattern="#,###"/>đ</h3>
                                </div>
                                <i class="fas fa-chart-line widget-icon text-danger"></i>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row g-4">
                    <!-- Monthly Revenue Chart -->
                    <div class="col-lg-8">
                        <div class="card border-0 shadow-sm rounded-4">
                            <div class="card-body p-4">
                                <h5 class="fw-bold mb-4"><i class="fas fa-chart-bar text-primary me-2"></i>Doanh thu theo tháng - Năm ${selectedYear}</h5>
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Tháng</th>
                                                <th>Doanh thu</th>
                                                <th style="width: 50%;">Biểu đồ</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:set var="maxRevenue" value="0" />
                                            <c:forEach var="entry" items="${monthlyChart}">
                                                <c:if test="${entry.value > maxRevenue}">
                                                    <c:set var="maxRevenue" value="${entry.value}" />
                                                </c:if>
                                            </c:forEach>
                                            <c:if test="${maxRevenue == 0}">
                                                <c:set var="maxRevenue" value="1" />
                                            </c:if>

                                            <c:forEach var="entry" items="${monthlyChart}">
                                                <c:set var="pct" value="${(entry.value / maxRevenue) * 100}" />
                                                <tr class="${entry.key.toString() == selectedMonth ? 'table-primary' : ''}">
                                                    <td class="fw-bold">
                                                        <c:if test="${entry.key.toString() == selectedMonth}">
                                                            <i class="fas fa-arrow-right text-primary me-1"></i>
                                                        </c:if>
                                                        Tháng ${entry.key}
                                                    </td>
                                                    <td class="fw-bold text-success">
                                                        <fmt:formatNumber value="${entry.value}" pattern="#,###"/>đ
                                                    </td>
                                                    <td>
                                                        <div class="progress rounded-pill" style="height: 20px;">
                                                            <div class="progress-bar ${entry.key.toString() == selectedMonth ? 'bg-primary' : 'bg-success bg-opacity-75'} rounded-pill"
                                                                 role="progressbar"
                                                                 style="width: ${pct > 0 ? pct : 0}%;">
                                                            </div>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Right Side: Booking Stats + Top Fields -->
                    <div class="col-lg-4">
                        <!-- Booking Stats -->
                        <div class="dashboard-side-card">
                            <h6 class="card-title mb-3"><i class="fas fa-chart-pie me-1"></i> Thống kê đơn tháng ${selectedMonth}</h6>
                            <div class="d-flex flex-column gap-3">
                                <div class="d-flex justify-content-between align-items-center">
                                    <span class="text-muted"><i class="fas fa-list text-secondary me-2"></i>Tổng đơn</span>
                                    <span class="fw-bold">${totalBookings}</span>
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
                                    <hr class="my-1">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <span class="text-muted small">Tỉ lệ thành công</span>
                                        <c:set var="successRate" value="${(completedBookings * 100) / totalBookings}" />
                                        <span class="fw-bold text-primary">
                                            <fmt:formatNumber value="${successRate}" maxFractionDigits="1"/>%
                                        </span>
                                    </div>
                                    <div class="progress rounded-pill" style="height: 8px;">
                                        <div class="progress-bar bg-success rounded-pill" style="width: ${successRate}%;"></div>
                                        <div class="progress-bar bg-danger rounded-pill" style="width: ${100 - successRate}%;"></div>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <!-- Top Fields -->
                        <div class="dashboard-side-card">
                            <h6 class="card-title mb-3"><i class="fas fa-trophy me-1"></i> Top sân doanh thu cao tháng ${selectedMonth}</h6>
                            <c:choose>
                                <c:when test="${not empty topFields}">
                                    <div class="d-flex flex-column gap-3">
                                        <c:forEach var="field" items="${topFields}" varStatus="loop">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div>
                                                    <span class="badge ${loop.index == 0 ? 'bg-warning' : loop.index == 1 ? 'bg-secondary' : 'bg-dark bg-opacity-25'} rounded-circle me-2"
                                                          style="width: 24px; height: 24px; line-height: 16px; text-align: center;">
                                                        ${loop.index + 1}
                                                    </span>
                                                    <span class="fw-bold">${field.fieldName}</span>
                                                    <span class="text-muted small ms-1">(${field.totalBookings} lượt)</span>
                                                </div>
                                                <span class="fw-bold text-success small">
                                                    <fmt:formatNumber value="${field.totalRevenue}" pattern="#,###"/>đ
                                                </span>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-muted small mb-0">Chưa có dữ liệu cho tháng này.</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
