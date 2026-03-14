<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đặt Sân Thành Công - SportFieldHub</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800;900&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/customer/base.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/customer/booking.css" rel="stylesheet">
    </head>
    <body>
        <jsp:include page="../common/header.jsp" />

        <main class="py-5">
            <div class="container py-4">
                <div class="row justify-content-center">
                    <div class="col-lg-7">
                        <div class="text-center mb-5">
                            <div class="success-icon-wrapper mb-4">
                                <i class="fas fa-check-circle"></i>
                            </div>
                            <h1 class="fw-bold mb-2">Đặt Sân Thành Công!</h1>
                            <p class="text-muted fs-5">Mã đơn: <strong class="text-dark">#BK${sessionScope.successBookingID}</strong></p>
                        </div>

                        <div class="success-card">
                            <!-- Field Info -->
                            <div class="d-flex align-items-center gap-3 mb-4 pb-4" style="border-bottom: 2px dashed #e9ecef;">
                                <div class="success-field-icon">
                                    <i class="fas fa-futbol"></i>
                                </div>
                                <div>
                                    <h4 class="fw-bold mb-1">${sessionScope.successFieldName}</h4>
                                    <span class="badge bg-danger rounded-pill px-3">Sân ${sessionScope.successFieldType}</span>
                                </div>
                            </div>

                            <!-- Date & Time -->
                            <div class="row g-4 mb-4">
                                <div class="col-6">
                                    <div class="text-uppercase small text-muted fw-bold mb-1">Ngày đá</div>
                                    <div class="fs-5 fw-bold"><i class="far fa-calendar-alt text-danger me-2"></i>${sessionScope.successDate}</div>
                                </div>
                                <div class="col-6">
                                    <div class="text-uppercase small text-muted fw-bold mb-1">Khung giờ</div>
                                    <div class="fs-5 fw-bold"><i class="far fa-clock text-danger me-2"></i>${sessionScope.successSlotTime}</div>
                                </div>
                            </div>

                            <!-- Payment Summary -->
                            <div class="payment-summary-box">
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted">Giá sân</span>
                                    <span class="fw-bold"><fmt:formatNumber value="${sessionScope.successTotalPrice}" pattern="#,###"/>đ</span>
                                </div>

                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted">Đã thanh toán</span>
                                    <span class="fw-bold text-success"><fmt:formatNumber value="${sessionScope.successPaidAmount}" pattern="#,###"/>đ</span>
                                </div>

                                <c:if test="${sessionScope.successPaymentStatus == 'DEPOSITED' || sessionScope.successPaymentStatus == 'UNPAID'}">
                                    <div class="d-flex justify-content-between pt-2 mt-2" style="border-top: 1px solid #e9ecef;">
                                        <span class="fw-bold">Còn phải trả tại sân</span>
                                        <span class="fw-bold fs-5 text-danger">
                                            <fmt:formatNumber value="${sessionScope.successTotalPrice - sessionScope.successPaidAmount}" pattern="#,###"/>đ
                                        </span>
                                    </div>
                                </c:if>
                            </div>

                            <!-- Payment Status Badge -->
                            <div class="text-center mt-4">
                                <c:choose>
                                    <c:when test="${sessionScope.successPaymentStatus == 'PAID'}">
                                        <span class="badge bg-success-subtle text-success fs-6 px-4 py-2 rounded-pill">
                                            <i class="fas fa-check-circle me-1"></i>Đã thanh toán đủ
                                        </span>
                                    </c:when>
                                    <c:when test="${sessionScope.successPaymentStatus == 'DEPOSITED'}">
                                         <span class="badge bg-info-subtle text-info fs-6 px-4 py-2 rounded-pill">
                                             <i class="fas fa-shield-alt me-1"></i>Đã cọc — Chỗ được giữ 100%
                                         </span>
                                     </c:when>
                                     <c:when test="${sessionScope.successPaymentStatus == 'UNPAID'}">
                                         <span class="badge bg-warning-subtle text-warning fs-6 px-4 py-2 rounded-pill">
                                             <i class="fas fa-clock me-1"></i>Chờ thanh toán tại sân
                                         </span>
                                     </c:when>
                                 </c:choose>
                            </div>

                            <!-- Payment Method Info -->
                            <div class="text-center mt-3">
                                 <small class="text-muted">
                                     <i class="fas fa-wallet me-1"></i>
                                     Phương thức: 
                                     <c:choose>
                                         <c:when test="${sessionScope.successPaymentMethod == 'VNPAY'}">Chuyển khoản Online (VNPay)</c:when>
                                         <c:when test="${sessionScope.successPaymentMethod == 'ON_SITE'}">Thanh toán tại sân</c:when>
                                         <c:otherwise>${sessionScope.successPaymentMethod}</c:otherwise>
                                     </c:choose>
                                 </small>
                             </div>
                        </div>

                        <!-- Action Buttons -->
                        <div class="d-flex gap-3 justify-content-center mt-4">
                            <a href="${pageContext.request.contextPath}/profile" class="btn btn-outline-dark rounded-pill px-4 py-2">
                                <i class="fas fa-list-alt me-2"></i>Lịch sử đặt sân
                            </a>
                            <a href="${pageContext.request.contextPath}/shop" class="btn btn-submit rounded-pill px-4 py-2">
                                <i class="fas fa-futbol me-2"></i>Đặt sân khác
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <%-- Clean up session attributes --%>
        <c:remove var="successBookingID" scope="session" />
        <c:remove var="successFieldName" scope="session" />
        <c:remove var="successFieldType" scope="session" />
        <c:remove var="successDate" scope="session" />
        <c:remove var="successSlotTime" scope="session" />
        <c:remove var="successTotalPrice" scope="session" />
        <c:remove var="successPaidAmount" scope="session" />
        <c:remove var="successPaymentStatus" scope="session" />
        <c:remove var="successPaymentMethod" scope="session" />

        <jsp:include page="../common/footer.jsp" />
    </body>
</html>
