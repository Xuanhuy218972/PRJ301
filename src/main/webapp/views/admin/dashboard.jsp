<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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
                    <a href="#" class="quick-action-btn">
                        <i class="fas fa-plus"></i> Thêm Booking mới
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/users" class="quick-action-btn">
                        <i class="fas fa-wallet"></i> Kiểm tra ví / Người dùng
                    </a>
                    <a href="#" class="quick-action-btn">
                        <i class="fas fa-file-export"></i> Xuất báo cáo tháng
                    </a>
                    <c:if test="${sessionScope.account.role == 'ADMIN'}">
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
                                    <h2 class="fw-bold mb-0">6</h2>
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
                                    <h2 class="fw-bold mb-0 text-success">28</h2>
                                </div>
                                <i class="fas fa-calendar-check widget-icon text-success"></i>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3">
                        <div class="card stat-card stat-card-warning shadow-sm h-100 border-0">
                            <div class="card-body d-flex justify-content-between align-items-center p-4">
                                <div>
                                    <h6 class="text-muted text-uppercase small mb-1">Khách hàng mới</h6>
                                    <h2 class="fw-bold mb-0">150</h2>
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
                                        <h3 class="fw-bold mb-0 text-danger">25.5M</h3>
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
                                <a href="#" class="btn btn-primary btn-sm shadow-sm rounded-pill">Xem tất cả</a>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Mã Booking</th>
                                            <th>Khách hàng</th>
                                            <th>Sân</th>
                                            <th>Giờ đá</th>
                                            <th>Trạng thái</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td><strong>#BK001</strong></td>
                                            <td>Nguyễn Văn A</td>
                                            <td>Sân Tuyên Sơn 1</td>
                                            <td>18:00 - 19:30</td>
                                            <td><span class="badge bg-success bg-opacity-10 text-success">Đã xác nhận</span></td>
                                        </tr>
                                        <tr>
                                            <td><strong>#BK002</strong></td>
                                            <td>Trần Thị B</td>
                                            <td>Sân VIP 2</td>
                                            <td>19:30 - 21:00</td>
                                            <td><span class="badge bg-warning bg-opacity-10 text-dark">Chờ thanh toán</span></td>
                                        </tr>
                                        <tr>
                                            <td><strong>#BK003</strong></td>
                                            <td>Lê Văn C</td>
                                            <td>Sân 5</td>
                                            <td>20:00 - 21:30</td>
                                            <td><span class="badge bg-info bg-opacity-10 text-info">Mới tạo</span></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Sidebar: Quick Actions + Occupancy + Alerts -->
                    <div class="col-lg-4">
                        <!-- Thao tác nhanh (compact) -->
                        <div class="dashboard-side-card">
                            <h6 class="card-title mb-3"><i class="fas fa-bolt me-1"></i> Thao tác nhanh</h6>
                            <div class="d-flex flex-column gap-2">
                                <a href="#" class="quick-action-btn"><i class="fas fa-plus"></i> Đặt sân mới</a>
                                <a href="${pageContext.request.contextPath}/admin/users" class="quick-action-btn"><i class="fas fa-user-plus"></i> Quản lý người dùng</a>
                                <a href="#" class="quick-action-btn"><i class="fas fa-cog"></i> Cài đặt hệ thống</a>
                            </div>
                        </div>

                        <!-- Court Occupancy (CSS progress bar) -->
                        <div class="dashboard-side-card">
                            <h6 class="card-title mb-3"><i class="fas fa-futbol me-1"></i> Trạng thái sân</h6>
                            <div class="occupancy-label">Hiện có 6/6 sân đang có khách đá</div>
                            <div class="progress rounded-pill progress-sm">
                                <div class="progress-bar bg-primary progress-full" role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100"></div>
                            </div>
                            <div class="occupancy-value mt-2">100% đang sử dụng</div>
                        </div>

                        <!-- System Alerts -->
                        <div class="dashboard-side-card">
                            <h6 class="card-title mb-3"><i class="fas fa-bell me-1"></i> Thông báo gần đây</h6>
                            <div class="alert-list">
                                <div class="alert-item alert-topup">
                                    <span class="alert-icon"><i class="fas fa-coins"></i></span>
                                    Người dùng <strong>huyhieu21</strong> vừa nạp 200,000 VNĐ.
                                </div>
                                <div class="alert-item alert-booking">
                                    <span class="alert-icon"><i class="fas fa-calendar-plus"></i></span>
                                    Booking <strong>#BK003</strong> vừa được tạo — Sân 5, 20:00.
                                </div>
                                <div class="alert-item alert-cancel">
                                    <span class="alert-icon"><i class="fas fa-times-circle"></i></span>
                                    Sân VIP 2 — lịch 19:30 đã được hủy.
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
