<%-- 
    Document   : login
    Created on : Feb 10, 2026, 8:37:48 PM
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
                            <h2 class="fw-bold">Xin Chào! 👋</h2>
                            <p class="text-muted">Đăng nhập để quản lý sân hoặc đặt lịch.</p>
                        </div>

                        <c:if test="${not empty error}">
                            <div class="alert alert-danger d-flex align-items-center" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>
                                <div>${error}</div>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/login" method="post">
                            <div class="mb-4">
                                <label class="form-label fw-bold">Tên đăng nhập</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-user text-muted"></i></span>
                                    <input type="text" class="form-control" name="username" placeholder="Nhập username..." value="${username}" required>
                                </div>
                            </div>

                            <div class="mb-4">
                                <div class="d-flex justify-content-between">
                                    <label class="form-label fw-bold">Mật khẩu</label>
                                    <a href="#" class="text-decoration-none small text-success">Quên mật khẩu?</a>
                                </div>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-lock text-muted"></i></span>
                                    <input type="password" class="form-control" name="password" placeholder="Nhập mật khẩu..." required>
                                </div>
                            </div>

                            <div class="d-grid mb-4">
                                <button type="submit" class="btn btn-primary btn-primary-custom text-white">
                                    Đăng Nhập Ngay
                                </button>
                            </div>

                            <div class="text-center">
                                <span class="text-muted">Chưa có tài khoản?</span>
                                <a href="register" class="fw-bold text-success text-decoration-none">Tạo tài khoản mới</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>