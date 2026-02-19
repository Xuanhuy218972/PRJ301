<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header class="main-header">
    <nav class="navbar navbar-expand-lg">
        <div class="container-fluid px-4">
            <!-- Logo -->
            <a class="navbar-brand" href="${pageContext.request.contextPath}/index.jsp">
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
                        <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp">TRANG CHỦ</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">ĐẶT SÂN</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">SÂN BÓNG</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">LIÊN HỆ</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">VỀ CHÚNG TÔI</a>
                    </li>
                </ul>
                
                <!-- Sponsor Logos -->
                <div class="sponsor-logos d-none d-lg-flex">
                    <img src="${pageContext.request.contextPath}/assets/images/konami.png" alt="Konami" class="sponsor-logo">
                    <img src="${pageContext.request.contextPath}/assets/images/tiger.png" alt="Tiger" class="sponsor-logo">
                    <img src="${pageContext.request.contextPath}/assets/images/adidas.png" alt="Adidas" class="sponsor-logo">
                </div>
                
                <!-- User Actions -->
                <ul class="navbar-nav ms-3 align-items-center">
                    <c:choose>
                        <c:when test="${not empty sessionScope.account}">
                            <!-- Logged In -->
                            <li class="nav-item dropdown user-dropdown">
                                <a class="nav-link dropdown-toggle user-menu" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                                    <i class="fas fa-user-circle me-2"></i>${sessionScope.account.fullName}
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end">
                                    <li>
                                        <a class="dropdown-item" href="#">
                                            <i class="fas fa-user me-2"></i>Thông Tin
                                        </a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item" href="#">
                                            <i class="fas fa-history me-2"></i>Lịch Sử Đặt Sân
                                        </a>
                                    </li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li>
                                        <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">
                                            <i class="fas fa-sign-out-alt me-2"></i>Đăng Xuất
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
