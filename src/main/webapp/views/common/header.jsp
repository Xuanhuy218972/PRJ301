<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header class="main-header">
    <nav class="navbar navbar-expand-lg">
        <div class="container-fluid px-4">
            <!-- Logo -->
            <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
                <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="Logo" class="header-logo">
            </a>
            
            <!-- Mobile Toggle -->
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <!-- Navigation -->
            <div class="collapse navbar-collapse" id="navbarNav">
                <!-- Menu -->
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/home">TRANG CHỦ</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/shop">HỆ THỐNG SÂN</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/contact">LIÊN HỆ</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">VỀ CHÚNG TÔI</a>
                    </li>
                </ul>
                
                <!-- User Actions -->
                <ul class="navbar-nav ms-3 align-items-center">
                    <c:choose>
                        <c:when test="${not empty sessionScope.account}">
                            <!-- Logged In -->
                            <li class="nav-item dropdown user-dropdown">
                                <button type="button" class="nav-link dropdown-toggle user-menu border-0 bg-transparent" id="userDropdown" aria-haspopup="true" aria-expanded="false">
                                    <i class="fas fa-user-circle me-2"></i>${sessionScope.account.fullName}
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end">
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/profile">
                                            <i class="fas fa-user me-2"></i>Thông tin cá nhân
                                        </a>
                                    </li>
                                    <c:if test="${sessionScope.account.role == 'ADMIN' || sessionScope.account.role == 'STAFF'}">
                                        <li>
                                            <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard">
                                                <i class="fas fa-cog me-2"></i>Quản trị
                                            </a>
                                        </li>
                                    </c:if>
                                    <li><hr class="dropdown-divider"></li>
                                    <li>
                                        <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">
                                            <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                                        </a>
                                    </li>
                                </ul>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <!-- Guest -->
                            <li class="nav-item">
                                <a class="btn btn-header-login" href="${pageContext.request.contextPath}/login">ĐĂNG NHẬP</a>
                            </li>
                            <li class="nav-item ms-2">
                                <a class="btn btn-header-register" href="${pageContext.request.contextPath}/register">ĐĂNG KÝ</a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>
</header>
