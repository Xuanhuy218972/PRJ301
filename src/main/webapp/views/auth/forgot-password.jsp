<%-- 
    Document   : forgot-password
    Created on : Mar 12, 2026
    Author     : hxhbang
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quên Mật Khẩu - SportFieldHub</title>
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
                            <h1 class="brand-text">Sport Field</h1>
                            <p class="text-white fs-4 mt-2">Đặt sân nhanh chóng - Thỏa đam mê</p>
                        </div>
                    </div>
                </div>

                <div class="col-md-5 col-lg-4 login-section">
                    <div class="login-card">
                        <div class="text-center mb-4">
                            <div class="auth-logo"></div>
                            <h2 class="form-title">Quên mật khẩu</h2>
                            <p class="text-muted mb-4">
                                Nhập thông tin tài khoản để đặt lại mật khẩu
                            </p>
                        </div>

                        <c:if test="${not empty error}">
                            <div class="alert alert-danger d-flex align-items-center" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>
                                <div>${error}</div>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/forgot-password" method="post">
                            <div class="mb-3">
                                <label class="form-label fw-bold text-uppercase small">Tên đăng nhập</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-user"></i></span>
                                    <input type="text" class="form-control" name="username" 
                                           placeholder="Nhập tên đăng nhập" value="${username}" required>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-bold text-uppercase small">Email đăng ký</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                                    <input type="email" class="form-control" name="email" 
                                           placeholder="Nhập email đã đăng ký" value="${email}" required>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-bold text-uppercase small">Mật khẩu mới</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                    <input type="password" class="form-control" name="newPassword" 
                                           placeholder="Nhập mật khẩu mới" required minlength="6">
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-bold text-uppercase small">Nhập lại mật khẩu mới</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                    <input type="password" class="form-control" name="confirmPassword" 
                                           placeholder="Xác nhận mật khẩu mới" required minlength="6">
                                </div>
                            </div>

                            <div class="d-grid mb-4">
                                <button type="submit" class="btn btn-primary-custom">
                                    <i class="fas fa-key me-2"></i>Đặt lại mật khẩu
                                </button>
                            </div>

                            <div class="text-center">
                                <a href="${pageContext.request.contextPath}/login" class="text-decoration-none small text-danger fw-bold">
                                    <i class="fas fa-arrow-left me-1"></i>Quay lại đăng nhập
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
