<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tổng Quan Hệ Thống - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/0/css/all.min6.0..css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/admin.css" rel="stylesheet">
</head>
<body>

    <div class="admin-layout">
        
        <jsp:include page="common/sidebar.jsp"></jsp:include>

        <div class="main-content">
            
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="fw-bold m-0">TỔNG QUAN HỆ THỐNG</h2>
                <div class="text-muted">
                    <i class="fas fa-calendar-alt me-1"></i> Hôm nay: <strong><%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date()) %></strong>
                </div>
            </div>

            <div class="row g-4 mb-4">
                
                <div class="col-md-3">
                    <div class="card widget-card shadow-sm" style="background: linear-gradient(135deg, #3498db, #2980b9);">
                        <div class="card-body d-flex justify-content-between align-items-center p-4">
                            <div>
                                <h6 class="text-uppercase mb-1">Tổng Số Sân</h6>
                                <h2 class="fw-bold mb-0">12</h2>
                            </div>
                            <i class="fas fa-futbol widget-icon"></i>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="card widget-card shadow-sm" style="background: linear-gradient(135deg, #2ecc71, #27ae60);">
                        <div class="card-body d-flex justify-content-between align-items-center p-4">
                            <div>
                                <h6 class="text-uppercase mb-1">Booking Hôm Nay</h6>
                                <h2 class="fw-bold mb-0">28</h2>
                            </div>
                            <i class="fas fa-calendar-check widget-icon"></i>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="card widget-card shadow-sm" style="background: linear-gradient(135deg, #f1c40f, #f39c12);">
                        <div class="card-body d-flex justify-content-between align-items-center p-4">
                            <div>
                                <h6 class="text-uppercase mb-1">Khách Hàng Mới</h6>
                                <h2 class="fw-bold mb-0">150</h2>
                            </div>
                            <i class="fas fa-users widget-icon"></i>
                        </div>
                    </div>
                </div>

                <c:if test="${sessionScope.account.role == 'ADMIN'}">
                    <div class="col-md-3">
                        <div class="card widget-card shadow-sm" style="background: linear-gradient(135deg, #e74c3c, #c0392b);">
                            <div class="card-body d-flex justify-content-between align-items-center p-4">
                                <div>
                                    <h6 class="text-uppercase mb-1">Doanh thu tháng</h6>
                                    <h3 class="fw-bold mb-0">25.5M</h3>
                                </div>
                                <i class="fas fa-wallet widget-icon"></i>
                            </div>
                        </div>
                    </div>
                </c:if>

            </div>

            <div class="card shadow-sm border-0">
                <div class="card-header bg-white py-3">
                    <h5 class="mb-0 fw-bold"><i class="fas fa-clock text-primary me-2"></i>Lượt đặt sân gần đây</h5>
                </div>
                <div class="card-body p-0">
                    <table class="table table-hover table-borderless mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Mã Booking</th>
                                <th>Khách Hàng</th>
                                <th>Sân</th>
                                <th>Giờ Đá</th>
                                <th>Trạng Thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>#BK001</td>
                                <td>Nguyễn Văn A</td>
                                <td>Sân Tuyên Sơn 1</td>
                                <td>18:00 - 19:30</td>
                                <td><span class="badge bg-success">Đã xác nhận</span></td>
                            </tr>
                            <tr>
                                <td>#BK002</td>
                                <td>Trần Thị B</td>
                                <td>Sân VIP 2</td>
                                <td>19:30 - 21:00</td>
                                <td><span class="badge bg-warning text-dark">Chờ thanh toán</span></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <%-- Ví dụ nút chỉ dành riêng cho ADMIN, STAFF sẽ không thấy --%>
            <c:if test="${sessionScope.account.role == 'ADMIN'}">
                <div class="mt-4">
                    <button class="btn btn-danger">
                        <i class="fas fa-user-slash me-1"></i> Xóa người dùng (Chỉ ADMIN)
                    </button>
                    <button class="btn btn-outline-secondary ms-2">
                        <i class="fas fa-cog me-1"></i> Cài đặt hệ thống (Chỉ ADMIN)
                    </button>
                </div>
            </c:if>

        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
