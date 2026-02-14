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
    </head>
    <body>     
        <c:choose>
            <c:when test="${not empty sessionScope.account}">
                <p>Succes!</p>
                <a href="<c:url value='/logout'/>" class="text-decoration-none">
                    <i class="fas fa-sign-out-alt"></i> Đăng Xuất
                </a>
            </c:when>
            <c:otherwise>
                <p>Hello</p>              
                <div>
                    <a href="<c:url value='/login'/>" class="text-decoration-none">
                        <i class="fas fa-sign-out-alt"></i> Đăng Nhập
                    </a>
                    <a href="<c:url value='/register'/>" class="text-decoration-none">
                        <i class="fas fa-sign-out-alt"></i> Đăng Ký
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>
