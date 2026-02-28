<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<nav id="sidebar" class="d-flex flex-column flex-shrink-0 text-white shadow sidebar">
    <div class="sidebar-brand-wrap">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-brand-link">
            <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="Logo" class="sidebar-logo-img">
            <div class="sidebar-logo-fallback" aria-hidden="true"><span>S</span></div>
            <div class="sidebar-brand-text">
                <p class="sidebar-brand-title mb-0">SPORT ADMIN</p>
                <p class="sidebar-brand-subtitle">Dashboard quản lý sân bóng</p>
            </div>
        </a>
    </div>

    <c:set var="currentURI" value="${pageContext.request.requestURI}" />

    <div class="sidebar-nav">
        <ul class="nav flex-column mb-auto">
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link sidebar-link ${fn:contains(currentURI, '/views/admin/dashboard.jsp') ? 'active' : ''}">
                    <i class="fas fa-th-large"></i> Tổng quan
                </a>
            </li>
            <li class="nav-item">
                <a href="#" class="nav-link sidebar-link">
                    <i class="fas fa-layer-group"></i> Quản lý Sân Bóng
                </a>
            </li>
            <li class="nav-item">
                <a href="#" class="nav-link sidebar-link">
                    <i class="fas fa-calendar-check"></i> Quản lý Đặt Sân
                </a>
            </li>

            <c:if test="${sessionScope.account.role == 'ADMIN'}">
                <li class="nav-item">
                    <span class="sidebar-section-title d-block">Quản trị hệ thống</span>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/users" class="nav-link sidebar-link ${fn:contains(currentURI, '/views/admin/users/') ? 'active' : ''}">
                        <i class="fas fa-user-shield"></i> Quản lý Người Dùng
                    </a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link sidebar-link">
                        <i class="fas fa-chart-pie"></i> Báo cáo doanh thu
                    </a>
                </li>
            </c:if>
        </ul>
    </div>

    <div class="sidebar-user-block">
        <div class="sidebar-user-inner">
            <div class="avatar-circle">
                <c:choose>
                    <c:when test="${not empty sessionScope.account.avatar}">
                        <img src="${sessionScope.account.avatar}" alt="">
                    </c:when>
                    <c:otherwise>
                        <c:set var="name" value="${sessionScope.account.fullName}" />
                        <c:set var="letter" value="${fn:length(name) > 0 ? fn:toUpperCase(fn:substring(name, 0, 1)) : 'A'}" />
                        <span>${letter}</span>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="sidebar-user-info">
                <p class="sidebar-username mb-0">${sessionScope.account.username}</p>
                <p class="sidebar-user-role mb-0">
                    <c:choose>
                        <c:when test="${sessionScope.account.role == 'ADMIN'}">Administrator</c:when>
                        <c:when test="${sessionScope.account.role == 'STAFF'}">Staff</c:when>
                        <c:otherwise>User</c:otherwise>
                    </c:choose>
                </p>
            </div>
            <a href="${pageContext.request.contextPath}/logout" class="sidebar-logout" title="Đăng xuất">
                <i class="fas fa-power-off"></i>
            </a>
        </div>
    </div>
</nav>
