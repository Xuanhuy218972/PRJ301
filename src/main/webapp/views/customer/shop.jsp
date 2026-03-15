<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Danh Sách Sân Bóng - SportFieldHub</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800;900&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/customer/base.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/customer/shop.css" rel="stylesheet">
    </head>
    <body>
        <jsp:include page="../common/header.jsp" />

        <main class="shop-page py-5">
            <div class="container">
                <div class="shop-hero mb-5 text-center text-md-start d-md-flex justify-content-between align-items-center">
                    <div class="position-relative z-1">
                        <h1 class="fw-bold mb-2 text-uppercase">Hệ Thống Sân Cỏ</h1>
                        <p class="mb-0 fs-5 opacity-75 fw-normal">Lựa chọn mặt sân ưng ý và chốt kèo ngay hôm nay!</p>
                    </div>
                    <div class="mt-4 mt-md-0 position-relative z-1">
                        <i class="fas fa-futbol hero-futbol-icon"></i>
                    </div>
                </div>

                <div class="filter-container d-flex flex-wrap gap-3 mb-5 justify-content-center justify-content-md-start">
                    <a href="${pageContext.request.contextPath}/shop" class="btn filter-btn rounded-pill px-4 py-2 ${empty selectedType || selectedType == 'ALL' ? 'active' : ''}">
                        <i class="fas fa-layer-group me-2"></i>Tất cả
                    </a>
                    <a href="${pageContext.request.contextPath}/shop?type=5" class="btn filter-btn rounded-pill px-4 py-2 ${selectedType == '5' ? 'active' : ''}">
                        Sân 5 người
                    </a>
                    <a href="${pageContext.request.contextPath}/shop?type=7" class="btn filter-btn rounded-pill px-4 py-2 ${selectedType == '7' ? 'active' : ''}">
                        Sân 7 người
                    </a>
                </div>

                <div class="row g-4">
                    <c:forEach var="field" items="${fields}">
                        <div class="col-md-6 col-lg-4 reveal">
                            <a href="${pageContext.request.contextPath}/field-detail?id=${field.fieldID}" class="text-decoration-none text-dark d-block h-100">
                                <div class="shop-field-card shadow-sm">
                                    <div class="shop-field-card-image">
                                        <c:choose>
                                            <c:when test="${not empty field.imageURL}">
                                                <img src="${field.imageURL}" alt="${field.fieldName}">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="h-100 w-100 d-flex align-items-center justify-content-center text-muted">
                                                    <i class="fas fa-image fa-3x opacity-25"></i>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                        <span class="field-type-badge shadow-sm"><i class="fas fa-fire me-1 text-warning"></i> Sân ${field.fieldType}</span>
                                    </div>
                                    <div class="card-body p-4">
                                        <h4 class="fw-bold mb-1">${field.fieldName}</h4>
                                        <p class="text-muted small mb-3"><i class="fas fa-map-marker-alt text-danger me-1"></i> Cơ sở trung tâm</p>

                                        <div class="d-flex justify-content-between align-items-end mt-4 pt-3 border-top">
                                            <div>
                                                <div class="text-muted small fw-medium">Giá thuê từ</div>
                                                <div class="price-text"><fmt:formatNumber value="${field.pricePerHour}" pattern="#,###"/>đ<span class="fs-6 text-muted fw-normal">/h</span></div>
                                            </div>
                                            <div class="btn btn-dark rounded-circle detail-link-btn">
                                                <i class="fas fa-arrow-right"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </c:forEach>

                    <c:if test="${empty fields}">
                        <div class="col-12 text-center py-5">
                            <div class="d-inline-flex align-items-center justify-content-center bg-white rounded-circle shadow-sm mb-3 empty-state-icon-wrapper">
                                <i class="fas fa-search-minus fa-3x text-muted opacity-50"></i>
                            </div>
                            <h4 class="fw-bold">Không tìm thấy sân!</h4>
                            <p class="text-muted">Chưa có sân phù hợp với bộ lọc hiện tại của bạn.</p>
                            <a href="${pageContext.request.contextPath}/shop" class="btn btn-danger rounded-pill px-4 mt-2">Xóa bộ lọc</a>
                        </div>
                    </c:if>
                </div>
            </div>
        </main>

        <jsp:include page="../common/footer.jsp" />
        <%@ include file="/views/customer/ai-chat-widget.jsp" %>
    </body>
</html>

