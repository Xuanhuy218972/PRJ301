<%@page contentType="text/html" pageEncoding="UTF-8" isErrorPage="true"%>
<%
    int code = response.getStatus();
    String bodyClass = (code >= 500) ? "error-5xx" : "error-4xx";

    String title;
    String message;
    switch (code) {
        case 404:
            title = "Oops! Trang không tồn tại";
            message = "Trang bạn đang tìm kiếm có thể đã bị xóa, đổi tên hoặc tạm thời không khả dụng.";
            break;
        case 403:
            title = "Truy cập bị từ chối";
            message = "Bạn không có quyền truy cập trang này.";
            break;
        case 500:
            title = "Lỗi máy chủ nội bộ";
            message = "Đã xảy ra lỗi không mong muốn. Vui lòng thử lại sau.";
            break;
        default:
            title = "Đã xảy ra lỗi";
            message = "Có gì đó không đúng. Vui lòng thử lại sau.";
            break;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= code %> - <%= title %></title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;800&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/error.css" rel="stylesheet">
</head>
<body class="<%= bodyClass %>">
    <div class="error-container">
        <div class="error-code"><%= code %></div>
        <h1 class="error-title"><%= title %></h1>
        <p class="error-message"><%= message %></p>
        <div class="error-actions">
            <a href="${pageContext.request.contextPath}/home" class="btn-home">
                &#127968; Về trang chủ
            </a>
            <a href="javascript:history.back()" class="btn-back">
                &#8592; Quay lại
            </a>
        </div>
        <p class="error-decoration">SportFieldHub &bull; Đặt sân nhanh chóng</p>
    </div>
</body>
</html>
