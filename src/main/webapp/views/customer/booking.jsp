<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page import="java.time.format.DateTimeFormatter" %>
<%@page import="java.time.LocalDate" %>
<%@page import="java.math.BigDecimal" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Xác Nhận Đặt Sân - SportFieldHub</title>
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
                <a href="${pageContext.request.contextPath}/field-detail?id=${field.fieldID}" class="text-dark text-decoration-none mb-4 d-inline-block fw-bold hover-opacity-100">
                    <i class="fas fa-arrow-left me-2"></i>Chọn giờ khác
                </a>

                <div class="row g-5 align-items-start">
                    <div class="col-lg-5">
                        <div class="ticket-card">
                            <div class="badge bg-danger px-3 py-2 rounded-pill mb-3">Sân ${field.fieldType}</div>
                            <h2 class="fw-bold mb-4">${field.fieldName}</h2>

                            <%
                                LocalDate bookingDate = (LocalDate) request.getAttribute("bookingDate");
                                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
                            %>
                            <div class="row g-4 mb-4">
                                <div class="col-6">
                                    <div class="text-uppercase small opacity-50 fw-bold mb-1">Ngày đá</div>
                                    <div class="fs-5 fw-bold"><i class="far fa-calendar-alt text-danger me-2"></i><%= bookingDate.format(formatter)%></div>
                                </div>
                                <div class="col-6">
                                    <div class="text-uppercase small opacity-50 fw-bold mb-1">Khung giờ</div>
                                    <div class="fs-5 fw-bold"><i class="far fa-clock text-danger me-2"></i>${slot.startTime}</div>
                                </div>
                            </div>

                            <div class="ticket-divider"></div>

                            <div class="d-flex justify-content-between align-items-end">
                                <div class="text-uppercase fw-bold opacity-75">Giá sân</div>
                                <div class="fs-1 fw-bold text-success"><fmt:formatNumber value="${slot.price}" pattern="#,###"/>đ</div>
                            </div>

                        </div>
                    </div>

                    <div class="col-lg-7">
                        <div class="form-card">
                            <h3 class="fw-bold mb-4 border-bottom pb-3"><i class="fas fa-user-edit text-danger me-2"></i>Thông tin người đặt</h3>

                            <form method="post" action="${pageContext.request.contextPath}/booking" id="bookingForm">
                                <input type="hidden" name="fieldId" value="${field.fieldID}">
                                <input type="hidden" name="slotId" value="${slot.slotID}">
                                <input type="hidden" name="date" value="${bookingDate}">

                                <div class="mb-4">
                                    <label class="form-label fw-bold text-muted small text-uppercase">Họ và tên "Đội trưởng"</label>
                                    <input type="text" class="form-control custom-input" name="customerName" value="${user.fullName}" required placeholder="Vd: Nguyễn Văn A">
                                </div>

                                <div class="row g-4 mb-4">
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold text-muted small text-uppercase">Số điện thoại</label>
                                        <input type="tel" class="form-control custom-input" name="customerPhone" value="${user.phone}" required pattern="[0-9]{10,11}" placeholder="09xx...">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label fw-bold text-muted small text-uppercase">Email nhận vé</label>
                                        <input type="email" class="form-control custom-input" name="customerEmail" value="${user.email}" required>
                                    </div>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label fw-bold text-muted small text-uppercase">Ghi chú thêm (Tùy chọn)</label>
                                    <textarea class="form-control custom-input" name="note" rows="3" placeholder="Yêu cầu thuê bóng, áo bib..."></textarea>
                                </div>

                                <!-- Payment Method Selection -->
                                <div class="mb-4">
                                    <label class="form-label fw-bold text-muted small text-uppercase mb-3">
                                        <i class="fas fa-wallet me-1"></i>Phương thức thanh toán
                                    </label>

                                    <div class="payment-options">
                                        <!-- Option 1: Full Online -->
                                        <label class="payment-option" for="payFull">
                                            <input type="radio" name="paymentOption" id="payFull" value="FULL"
                                                   data-amount="${slot.price}">
                                            <div class="payment-option-content">
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="payment-icon payment-icon-online">
                                                        <i class="fas fa-credit-card"></i>
                                                    </div>
                                                    <div class="flex-grow-1">
                                                        <div class="fw-bold">Thanh toán</div>
                                                        <div class="small text-muted">Chuyển khoản qua VNPay / Ngân hàng</div>
                                                    </div>
                                                    <div class="text-end">
                                                        <div class="fw-bold text-success"><fmt:formatNumber value="${slot.price}" pattern="#,###"/>đ</div>
                                                    </div>
                                                </div>
                                            </div>
                                        </label>

                                        <!-- Option 2: 30% Deposit -->
                                        <label class="payment-option" for="payDeposit">
                                            <input type="radio" name="paymentOption" id="payDeposit" value="DEPOSIT"
                                                   data-amount="${depositAmount}" checked>
                                            <div class="payment-option-content">
                                                <div class="payment-recommend-tag">
                                                    <i class="fas fa-star me-1"></i>Khuyên dùng
                                                </div>
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="payment-icon payment-icon-deposit">
                                                        <i class="fas fa-shield-alt"></i>
                                                    </div>
                                                    <div class="flex-grow-1">
                                                        <div class="fw-bold">Cọc trước 30%</div>
                                                        <div class="small text-muted">Còn lại thanh toán tại sân sau trận</div>
                                                    </div>
                                                    <div class="text-end">
                                                        <div class="fw-bold text-success"><fmt:formatNumber value="${depositAmount}" pattern="#,###"/>đ</div>
                                                        <div class="small text-muted text-decoration-line-through"><fmt:formatNumber value="${slot.price}" pattern="#,###"/>đ</div>
                                                    </div>
                                                </div>
                                            </div>
                                        </label>

                                        <!-- Option 3: Thanh toán tại sân -->
                                        <label class="payment-option" for="payOnSite">
                                            <input type="radio" name="paymentOption" id="payOnSite" value="CASH"
                                                   data-amount="${slot.price}">
                                            <div class="payment-option-content">
                                                <div class="d-flex align-items-center gap-3">
                                                    <div class="payment-icon payment-icon-onsite">
                                                        <i class="fas fa-store"></i>
                                                    </div>
                                                    <div class="flex-grow-1">
                                                        <div class="fw-bold">Thanh toán tại sân</div>
                                                        <div class="small text-muted">Thanh toán khi đến sân (tiền mặt hoặc chuyển khoản)</div>
                                                    </div>
                                                    <div class="text-end">
                                                        <div class="fw-bold text-success"><fmt:formatNumber value="${slot.price}" pattern="#,###"/>đ</div>
                                                    </div>
                                                </div>
                                            </div>
                                        </label>

                                    </div>
                                </div>
                                
                                <div class="payment-summary-box mb-4">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <span class="text-uppercase small fw-bold text-muted">Tổng thanh toán:</span>
                                        <span class="fs-4 fw-bold text-success dynamic-price">
                                            <span class="price-full-text d-none"><fmt:formatNumber value="${slot.price}" pattern="#,###"/>đ</span>
                                            <span class="price-deposit-text d-none"><fmt:formatNumber value="${depositAmount}" pattern="#,###"/>đ</span>
                                            <span class="price-onsite-text d-none"><fmt:formatNumber value="${slot.price}" pattern="#,###"/>đ</span>
                                        </span>
                                    </div>
                                </div>

                                <button type="submit" class="btn btn-submit w-100 fs-5 mt-2 dynamic-btn">
                                    <i class="fas fa-bolt me-2"></i> 
                                    <span class="btn-text-full d-none">Thanh Toán & Đặt Ngay</span>
                                    <span class="btn-text-deposit d-none">Cọc</span>
                                    <span class="btn-text-onsite d-none">Xác Nhận Đặt Sân</span>
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <jsp:include page="../common/footer.jsp" />


    </body>
</html>
