<%-- 
    Document   : login-internal
    Created on : Feb 13, 2026
    Author     : hxhbang
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng Nhập Quản Trị - SportFieldHub</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/auth.css" rel="stylesheet">
    </head>
    <body>

        <div class="internal-login-wrapper">
            <div class="internal-login-card">
                <div class="internal-login-logo"></div>
                <h1 class="internal-form-title">QUẢN TRỊ VIÊN</h1>
                <p class="internal-subtitle">Hệ thống quản lý sân bóng</p>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-triangle me-2"></i> ${error}
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/login" method="post" onsubmit="return validateForm()">

                    <div class="internal-input-group" id="username-group">
                        <span class="input-group-text"><i class="fas fa-user"></i></span>
                        <input type="text" class="form-control" name="username" placeholder="Tài khoản nhân viên" value="${username}" autofocus>
                    </div>

                    <div class="internal-input-group" id="password-group">
                        <span class="input-group-text"><i class="fas fa-lock"></i></span>
                        <input type="password" class="form-control" name="password" placeholder="Mật khẩu">
                    </div>

                    <button type="submit" class="internal-btn-primary">
                        ĐĂNG NHẬP HỆ THỐNG
                    </button>
                </form>
                <a href="login" class="internal-back-link">
                    <i class="fas fa-arrow-left me-1"></i> Quay lại trang Khách hàng
                </a>
            </div>
        </div>

    </body>
</html>