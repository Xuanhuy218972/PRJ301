<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link href="${pageContext.request.contextPath}/assets/css/admin.css" rel="stylesheet">

<div class="d-flex flex-column flex-shrink-0 p-3 text-white bg-dark shadow-lg sidebar">
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto text-white text-decoration-none sidebar-brand">
        <i class="fas fa-futbol fs-3 me-2 text-primary"></i>
        <span class="fs-5 fw-bold text-uppercase">Sport Admin</span>
    </a>
    <hr>
    
    <ul class="nav nav-pills flex-column mb-auto gap-2">
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link active bg-primary sidebar-link">
                <i class="fas fa-home me-2"></i> Tổng quan
            </a>
        </li>
        <li>
            <a href="#" class="nav-link text-white sidebar-link">
                <i class="fas fa-layer-group me-2"></i> Quản lý Sân Bóng
            </a>
        </li>
        <li>
            <a href="#" class="nav-link text-white sidebar-link">
                <i class="fas fa-calendar-check me-2"></i> Quản lý Đặt Sân
            </a>
        </li>

        <%-- Chỉ ADMIN mới thấy khu vực này --%>
        <c:if test="${sessionScope.account.role == 'ADMIN'}">
            <hr class="text-secondary">
            <small class="text-uppercase text-muted fw-bold mb-2">Quản trị nâng cao</small>
            <li>
                <a href="#" class="nav-link text-white sidebar-link">
                    <i class="fas fa-users-cog me-2"></i> Quản lý Nhân sự
                </a>
            </li>
            <li>
                <a href="#" class="nav-link text-white sidebar-link">
                    <i class="fas fa-chart-line me-2"></i> Báo cáo doanh thu
                </a>
            </li>
        </c:if>
    </ul>
    
    <hr>
    <div class="dropdown">
        <a href="#" class="d-flex align-items-center text-white text-decoration-none dropdown-toggle" data-bs-toggle="dropdown">
            <div class="bg-secondary rounded-circle d-flex justify-content-center align-items-center me-2 user-avatar">
                <i class="fas fa-user"></i>
            </div>
            <strong>${sessionScope.account.username}</strong>
        </a>
        <ul class="dropdown-menu dropdown-menu-dark text-small shadow">
            <li><a class="dropdown-item" href="#"><i class="fas fa-id-badge me-2"></i>Hồ sơ</a></li>
            <li><hr class="dropdown-divider"></li>
            <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt me-2"></i>Đăng xuất</a></li>
        </ul>
    </div>
</div>
