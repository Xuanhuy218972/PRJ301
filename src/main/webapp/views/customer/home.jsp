<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page import="java.time.LocalDate" %>


<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>SportFieldHub - Bùng Cháy Đam Mê</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800;900&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/customer/base.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/customer/home.css" rel="stylesheet">
    </head>
    <body>
        <jsp:include page="../common/header.jsp" />

        <section class="hero-section">
            <div class="container text-center position-relative z-1">
                <h1 class="hero-title mb-3">Sân Xịn Lên Đèn<br><span class="text-highlight">Anh Em Lên Đồ!</span></h1>
                <p class="fs-4 text-light opacity-75 fw-normal mb-5">Hệ thống đặt sân bóng đá nhanh nhất thị trường. Chọn giờ, chốt sân trong 30 giây.</p>
            </div>

            <div class="search-box-wrapper">
                <div class="search-card">
                    <form action="${pageContext.request.contextPath}/search" method="GET" class="row gx-5 gy-3 align-items-end">
                        <div class="col-md-3">
                            <label class="form-label fw-bold text-muted small text-uppercase">Ngày đá</label>
                            <input type="date" class="form-control form-control-lg border-0 bg-light" name="date" min="<%= LocalDate.now() %>" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-bold text-muted small text-uppercase">Loại sân</label>
                            <select class="form-select form-control-lg border-0 bg-light" name="type">
                                <option value="">Tất cả</option>
                                <option value="5">Sân 5 người</option>
                                <option value="7">Sân 7 người</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-bold text-muted small text-uppercase">Khoảng thời gian</label>
                            <select class="form-select form-control-lg border-0 bg-light" name="timeRange">
                                <option value="ALL">Tất cả các giờ</option>
                                <option value="MORNING">Buổi sáng (06:00 - 12:00)</option>
                                <option value="AFTERNOON">Buổi chiều (12:00 - 18:00)</option>
                                <option value="EVENING">Buổi tối (18:00 - 23:30)</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-danger btn-lg w-100 fw-bold search-submit-btn">
                                <i class="fas fa-search me-1"></i> TÌM SÂN
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </section>

        <c:if test="${not empty requestScope.hotSlots}">
        <section class="hot-fields-section bg-light">
            <div class="container">
                <div class="d-flex justify-content-between align-items-end mb-4">
                    <div>
                        <h2 class="fw-bold mb-1 text-danger"><i class="fas fa-bolt"></i> Giờ Vàng Chớp Nhoáng</h2>
                        <p class="text-muted mb-0">Những khung giờ đẹp nhất có thể bị đặt bất cứ lúc nào!</p>
                    </div>
                </div>

                <div class="row g-5">
                    <c:forEach var="item" items="${hotSlots}">
                        <div class="col-md-4 reveal">
                            <div class="card home-field-card h-100 shadow-sm border-danger border border-2">
                                <div class="home-field-img-wrapper">
                                    <c:set var="dateBadgeClass" value="bg-secondary text-white"/>
                                    <c:if test="${item.isToday}">
                                        <c:set var="dateBadgeClass" value="bg-success text-white"/>
                                    </c:if>
                                    <c:if test="${item.isTomorrow}">
                                        <c:set var="dateBadgeClass" value="bg-info text-dark"/>
                                    </c:if>

                                    <span class="home-field-badge ${dateBadgeClass}">
                                        <i class="far fa-calendar-alt me-1"></i> ${item.displayDate}
                                    </span>
                                    
                                    <span class="position-absolute top-0 end-0 m-3 badge bg-danger fs-6 z-2 border border-white">
                                        Sân ${item.fieldType} Người
                                    </span>

                                    <c:choose>
                                        <c:when test="${not empty item.imageURL}">
                                            <img src="${item.imageURL}" class="home-field-img" alt="${item.fieldName}">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="https://images.unsplash.com/photo-1529900748604-07564a03e7a6?q=80&w=600&auto=format&fit=crop" class="home-field-img" alt="Default Field">
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="card-body p-4 text-center">
                                    <h4 class="fw-bold mb-1 text-dark">${item.fieldName}</h4>
                                    
                                    <div class="my-3 py-2 bg-light rounded text-center border">
                                        <h3 class="mb-0 fw-bold text-primary">
                                            <i class="far fa-clock me-1"></i>
                                            ${item.startTime} - ${item.endTime}
                                        </h3>
                                        <c:choose>
                                            <c:when test="${item.isGoldenHour && (item.isToday || item.isTomorrow)}">
                                                <div class="text-danger fw-bold mt-2 animation-pulse small">
                                                     Vừa có người hủy. Chốt gấp!
                                                </div>
                                            </c:when>
                                            <c:when test="${item.isGoldenHour && !(item.isToday || item.isTomorrow)}">
                                                <div class="text-warning fw-bold mt-2 small text-dark">
                                                    Thường kín lịch trước 3 ngày!
                                                </div>
                                            </c:when>
                                        </c:choose>
                                    </div>

                                    <div class="d-flex justify-content-between align-items-center mt-3">
                                        <div class="text-start">
                                            <div class="text-muted small">Chỉ với</div>
                                            <div class="home-field-price"><fmt:formatNumber value="${item.price}" pattern="#,###"/>đ</div>
                                        </div>
                                        <form action="${pageContext.request.contextPath}/booking" method="GET">
                                            <input type="hidden" name="fieldId" value="${item.fieldID}">
                                            <input type="hidden" name="date" value="${item.date}">
                                            <input type="hidden" name="slotId" value="${item.slotID}">
                                            <button type="submit" class="btn btn-danger rounded-pill px-4 py-2 fw-bold text-uppercase">
                                                Chốt Sân <i class="fas fa-chevron-right ms-1"></i>
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </section>
        </c:if>

        <section class="hot-fields-section">
            <div class="container">
                <div class="d-flex justify-content-between align-items-end mb-4">
                    <div>
                        <h2 class="fw-bold mb-1">Cụm Sân Tiêu Biểu</h2>
                        <p class="text-muted mb-0">Những mặt cỏ chất lượng nhất đang chờ bạn</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/shop" class="btn btn-outline-dark rounded-pill px-4 fw-bold">
                        Xem tất cả <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>

                <div class="row g-4">
                    <c:forEach var="field" items="${hotFields}">
                        <div class="col-md-4 reveal">
                            <div class="card home-field-card h-100 shadow-sm">
                                <div class="home-field-img-wrapper">

                                    <c:set var="badgeClass" value="bg-primary text-white"/>
                                    <c:if test="${field.fieldType == 5}"><c:set var="badgeClass" value="bg-warning text-dark"/></c:if>
                                    <c:if test="${field.fieldType == 7}"><c:set var="badgeClass" value="bg-primary text-white"/></c:if>

                                        <span class="home-field-badge ${badgeClass}">
                                        <i class="fas fa-fire me-1"></i> Sân ${field.fieldType} Người
                                    </span>

                                    <c:choose>
                                        <c:when test="${not empty field.imageURL}">
                                            <img src="${field.imageURL}" class="home-field-img" alt="${field.fieldName}">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="https://images.unsplash.com/photo-1529900748604-07564a03e7a6?q=80&w=600&auto=format&fit=crop" class="home-field-img" alt="Default Field">
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="card-body p-4">
                                    <h4 class="fw-bold mb-2">${field.fieldName}</h4>
                                    <p class="text-muted small mb-3"><i class="fas fa-map-marker-alt text-danger me-1"></i> Cơ sở trung tâm</p>
                                    <div class="d-flex justify-content-between align-items-center mt-4">
                                        <div>
                                            <div class="text-muted small">Giá từ</div>
                                            <div class="home-field-price"><fmt:formatNumber value="${field.pricePerHour}" pattern="#,###"/>đ<span class="fs-6 text-muted fw-normal">/h</span></div>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/field-detail?id=${field.fieldID}" class="btn btn-dark rounded-pill px-4 fw-bold">Đặt Ngay</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>

                    <c:if test="${empty hotFields}">
                        <div class="col-12 text-center py-5">
                            <p class="text-muted">Chưa có sân nào được cập nhật.</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </section>

        <section class="steps-section border-top">
            <div class="container">
                <div class="text-center mb-5">
                    <h2 class="fw-bold mb-3">3 Bước Lên Kèo Chớp Nhoáng</h2>
                    <p class="text-muted fs-5">Không rườm rà, thủ tục nhanh gọn để anh em giữ sức ra sân.</p>
                </div>

                <div class="row g-4">
                    <div class="col-md-4">
                        <div class="step-card">
                            <div class="step-number">1</div>
                            <div class="step-content">
                                <i class="fas fa-search step-icon"></i>
                                <h4 class="fw-bold mb-2">Tìm Sân & Giờ</h4>
                                <p class="text-muted">Nhập ngày và giờ bạn muốn đá. Hệ thống sẽ lọc ra những sân cỏ còn trống chất lượng nhất.</p>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="step-card">
                            <div class="step-number">2</div>
                            <div class="step-content">
                                <i class="fas fa-check-circle step-icon"></i>
                                <h4 class="fw-bold mb-2">Chốt Thông Tin</h4>
                                <p class="text-muted">Kiểm tra lại giá tiền, điền thông tin liên hệ và tiến hành đặt cọc qua ví điện tử siêu bảo mật.</p>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4">
                        <div class="step-card">
                            <div class="step-number">3</div>
                            <div class="step-content">
                                <i class="fas fa-running step-icon"></i>
                                <h4 class="fw-bold mb-2">Xỏ Giày Ra Sân</h4>
                                <p class="text-muted">Nhận ngay mã xác nhận qua Email/Zalo. Đến sân đọc mã và thỏa mãn đam mê thôi!</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <jsp:include page="../common/footer.jsp" />
    </body>
</html>