<%-- 
    Document   : login
    Created on : Feb 10, 2026, 8:37:48 PM
    Author     : hxhbang
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng Nhập - SportFieldHub</title>
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
                        <div class="text-center mb-5">
                            <div class="auth-logo"></div>
                            <h2 class="form-title">Đăng nhập</h2>
                            <p class="text-muted mb-4">
                                Chưa có tài khoản ? <a href="register" class="text-danger fw-bold text-decoration-none">Tạo tài khoản ngay</a>
                            </p>
                        </div>

                        <c:if test="${not empty error}">
                            <div class="alert alert-danger d-flex align-items-center" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>
                                <div>${error}</div>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/login" method="post">
                            <div class="mb-3">
                                <label class="form-label fw-bold text-uppercase small">Username</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-user"></i></span>
                                    <input type="text" class="form-control" name="username" placeholder="Type your username" value="${username}" required>
                                </div>
                            </div>

                            <div class="mb-4">
                                <div class="d-flex justify-content-between mb-2">
                                    <label class="form-label fw-bold text-uppercase small">Mật khẩu</label>
                                    <a href="#" class="text-decoration-none small text-danger fw-bold">Quên mật khẩu?</a>
                                </div>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                    <input type="password" class="form-control"     name="password" placeholder="Type your password" required>
                                </div>
                            </div>

                            <div class="d-grid mb-4">
                                <button type="submit" class="btn btn-primary-custom">Đăng nhập</button>
                            </div>

                            <div class="position-relative text-center my-4">
                                <hr class="text-muted">
                                <span class="position-absolute top-50 start-50 translate-middle bg-white px-3 text-muted">OR</span>
                            </div>

                            <div class="d-grid">
                                <a href="login-internal" class="btn btn-outline-secondary">
                                    <i class="fas fa-user-shield me-2"></i> Đăng nhập với tư cách Nhân viên
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
