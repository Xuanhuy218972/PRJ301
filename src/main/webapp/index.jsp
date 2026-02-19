<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>SportFieldHub - Trang Chủ</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/layout.css" rel="stylesheet">
    </head>
    <body>
        <!-- Header -->
        <jsp:include page="views/common/header.jsp" />

        <section>
            <h1>Chào Mừng Đến SportFieldHub</h1>
            <p>Đặt sân bóng nhanh chóng - Tiện lợi - Uy tín</p>
            <a href="/register">Đăng Ký Ngay</a> | <a href="/login">Đăng Nhập</a>
        </section>

        <main>
            <h2>Tại Sao Chọn SportFieldHub?</h2>
            <ul>
                <li>Đặt sân nhanh chóng</li>
                <li>An toàn & uy tín</li>
                <li>Hỗ trợ 24/7</li>
            </ul>
        </main>


        <!-- Footer -->
        <jsp:include page="views/common/footer.jsp" />

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
