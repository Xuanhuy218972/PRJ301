<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page import="java.time.format.DateTimeFormatter" %>
<%@page import="java.time.LocalDate" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Kết Quả Tìm Kiếm - SportFieldHub</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800;900&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/customer/base.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/customer/search-results.css" rel="stylesheet">
    </head>
    <body class="search-results-page">
        <jsp:include page="../common/header.jsp" />

        <main class="py-5">
            <div class="container">
                <%
                    LocalDate searchDate = (LocalDate) request.getAttribute("searchDate");
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
                    String displayDate = (searchDate != null) ? searchDate.format(formatter) : "";
                    pageContext.setAttribute("displayDate", displayDate);
                %>
                
                <c:set var="timeDisplay" value="Cả ngày" />
                <c:if test="${selectedTimeRange == 'MORNING'}"><c:set var="timeDisplay" value="Buổi sáng" /></c:if>
                <c:if test="${selectedTimeRange == 'AFTERNOON'}"><c:set var="timeDisplay" value="Buổi chiều" /></c:if>
                <c:if test="${selectedTimeRange == 'EVENING'}"><c:set var="timeDisplay" value="Buổi tối" /></c:if>

                <div class="search-results-hero text-center text-md-start">
                    <div class="row align-items-center">
                        <div class="col-md-8 position-relative z-1">
                            <span class="badge bg-danger rounded-pill px-3 py-2 mb-3 fs-6">Kết Quả Tìm Kiếm</span>
                            <h1 class="fw-bold mb-3">Ngày ${displayDate}</h1>
                            <p class="fs-5 opacity-75 mb-0">
                                <i class="far fa-clock me-2"></i>Khoảng thời gian: <strong>${timeDisplay}</strong>
                                <c:if test="${not empty selectedType}">
                                    <span class="mx-2">|</span><i class="fas fa-futbol me-2"></i>Loại sân: <strong>${selectedType} người</strong>
                                </c:if>
                            </p>
                        </div>
                        <div class="col-md-4 text-center mt-4 mt-md-0 position-relative z-1">
                            <i class="fas fa-search hero-search-icon"></i>
                        </div>
                    </div>
                </div>

                <div class="d-flex justify-content-between align-items-end border-bottom pb-3 mb-4">
                    <h3 class="fw-bold mb-0 text-dark">
                        <i class="fas fa-clipboard-check text-success me-2"></i>Sân Còn Chỗ (${fn:length(searchResults)})
                    </h3>
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-dark rounded-pill px-4 btn-sm fw-bold">
                        <i class="fas fa-search me-1"></i> Tìm lại
                    </a>
                </div>

                <div class="row g-4">
                    <c:forEach var="result" items="${searchResults}">
                        <div class="col-lg-6">
                            <div class="result-card h-100">
                                <div class="row g-0 h-100">
                                    <div class="col-md-5">
                                        <div class="result-img-wrapper h-100">
                                            <span class="result-badge shadow-sm"><i class="fas fa-fire me-1 text-warning"></i> Sân ${result.field.fieldType}</span>
                                            <c:choose>
                                                <c:when test="${not empty result.field.imageURL}">
                                                    <img src="${result.field.imageURL}" class="result-img" alt="${result.field.fieldName}">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="h-100 w-100 d-flex align-items-center justify-content-center bg-secondary text-white opacity-50">
                                                        <i class="fas fa-image fa-3x"></i>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                    <div class="col-md-7 d-flex flex-column">
                                        <div class="card-body p-4 pb-0 flex-grow-0">
                                            <h4 class="fw-bold mb-1">${result.field.fieldName}</h4>
                                            <p class="text-muted small mb-3"><i class="fas fa-map-marker-alt text-danger me-1"></i> Cơ sở trung tâm</p>
                                            <!-- <div class="d-flex align-items-center mb-3">
                                                <div class="text-muted small fw-medium me-3">Giá thuê:</div>
                                                <div class="result-price"><fmt:formatNumber value="${result.field.pricePerHour}" pattern="#,###"/>đ<span class="fs-6 text-muted fw-normal">/h</span></div>
                                            </div> -->
                                        </div>
                                        
                                        <div class="slots-container mt-auto">
                                            <div class="text-uppercase small fw-bold text-muted mb-3 d-flex align-items-center">
                                                <i class="fas fa-bolt text-warning me-2"></i> Giờ trống chốt ngay
                                            </div>
                                            <div class="d-flex flex-wrap">
                                                <c:forEach var="slot" items="${result.availableSlots}">
                                                    <a href="${pageContext.request.contextPath}/booking?fieldId=${result.field.fieldID}&date=${searchDate}&slotId=${slot.slotID}" class="slot-btn">
                                                        <span class="slot-btn-time">${slot.startTime} - ${slot.endTime} <i class="fas fa-arrow-right ms-1"></i></span>
                                                        <span class="slot-btn-price"><fmt:formatNumber value="${slot.price}" pattern="#,###"/>đ/h</span>
                                                    </a>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>

                    <c:if test="${empty searchResults}">
                        <div class="col-12 text-center py-5">
                            <div class="empty-state">
                                <div class="d-inline-flex align-items-center justify-content-center bg-light rounded-circle mb-4 empty-state-icon-wrapper">
                                    <i class="fas fa-frown fa-3x text-muted opacity-50"></i>
                                </div>
                                <h3 class="fw-bold">Rất tiếc! Đã "cháy" sân</h3>
                                <p class="text-muted fs-5 mb-4 max-w-md mx-auto">Không tìm thấy sân trống nào trong khoảng thời gian bạn yêu cầu. Các anh em khác đã nhanh tay chốt hết rồi!</p>
                                <a href="${pageContext.request.contextPath}/home" class="btn btn-danger btn-lg rounded-pill px-5">Tìm ngày khác</a>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </main>

        <jsp:include page="../common/footer.jsp" />
    </body>
</html>
