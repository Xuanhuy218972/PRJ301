<%-- 
    Document   : register
    Created on : Feb 11, 2026, 8:21:18 AM
    Author     : hxhbang
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng Ký - SportFieldHub</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

        <link href="${pageContext.request.contextPath}/assets/css/auth.css" rel="stylesheet">
    </head>
    <body>

        <div class="container-fluid">
            <div class="row no-gutters">

                <div class="col-md-7 col-lg-8 d-none d-md-block p-0 bg-image">
                    <div class="bg-overlay">
                        <div class="text-center animate-fade-in">
                            <h1 class="brand-text">JOIN THE<br><span class="primary-text">GAME</span></h1>
                            <p class="text-white fs-4 mt-2" style="font-family: 'Roboto'; letter-spacing: 1px;">Tham gia vào cộng đồng của chúng tôi!</p>
                        </div>
                    </div>
                </div>

                <div class="col-md-5 col-lg-4 login-section">
                    <div class="login-card">

                        <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="Logo" class="auth-logo">

                        <h2 class="form-title text-center mb-2">SIGN UP</h2>
                        <p class="text-muted text-center mb-4">
                            Đã có tài khoản ? <a href="login.jsp" class="text-danger fw-bold text-decoration-none">Đăng nhập ngay</a>
                        </p>

                        <c:if test="${not empty error}">
                            <div class="alert alert-danger p-2 mb-3">
                                <i class="fas fa-exclamation-triangle me-1"></i> ${error}
                            </div>
                        </c:if>
                        <c:if test="${not empty success}">
                            <div class="alert alert-success p-2 mb-3">
                                <i class="fas fa-check-circle me-1"></i> ${success}
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/register" method="post">

                            <div class="mb-3">
                                <label class="form-label fw-bold">Full Name</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-id-card"></i></span>
                                    <input type="text" class="form-control" name="fullname" value="${param.fullname}" placeholder="Enter full name" required>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-bold">Username</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-user"></i></span>
                                    <input type="text" class="form-control" name="username" value="${param.username}" placeholder="Choose username" required>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold">Email</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                                        <input type="email" class="form-control" name="email" value="${param.email}" placeholder="Email" required>
                                    </div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label fw-bold">Điện thoại</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-phone"></i></span>
                                        <input type="tel" class="form-control" name="phone" value="${param.phone}" placeholder="Phone" required>
                                    </div>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-bold">Mật khẩu</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                    <input type="password" class="form-control" name="password" placeholder="Create password" required>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-bold">Nhập lại mật khẩu</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-check-double"></i></span>
                                    <input type="password" class="form-control" name="confirm_password" placeholder="Confirm password" required>
                                </div>
                            </div>

                            <div class="d-grid mb-3">
                                <button type="submit" class="btn btn-primary-custom">
                                    CREATE ACCOUNT
                                </button>
                            </div>

                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>