<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page import="java.time.LocalDate" %>
<%@page import="java.time.format.DateTimeFormatter" %>
<%@page import="java.time.DayOfWeek" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Sân - ${field.fieldName}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/admin/admin.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/admin/admin-schedule.css" rel="stylesheet">
</head>
<body>

    <div class="admin-layout">

        <jsp:include page="../common/sidebar.jsp"></jsp:include>

        <div class="main-content">
            <div class="container-fluid px-4 py-4">

                <div class="page-header mb-4">
                    <nav aria-label="breadcrumb" class="mb-3">
                        <ol class="breadcrumb mb-0">
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/admin/dashboard" class="text-decoration-none">
                                    <i class="fas fa-home me-1"></i>Hệ thống
                                </a>
                            </li>
                            <li class="breadcrumb-item">
                                <a href="${pageContext.request.contextPath}/admin/fields" class="text-decoration-none">
                                    Quản lý sân
                                </a>
                            </li>
                            <li class="breadcrumb-item active">Lịch sân</li>
                        </ol>
                    </nav>
                    <h1 class="h3 fw-bold mb-2">
                        <i class="fas fa-calendar-alt text-primary me-2"></i>
                        ${field.fieldName}
                    </h1>
                    <p class="text-muted mb-0">Xem và quản lý lịch đặt sân theo tuần</p>
                </div>

                <div class="row mb-4 align-items-center g-3">
                    <!-- Week Navigation -->
                    <div class="col-lg-6 mb-3 mb-lg-0">
                        <div class="bg-white rounded-pill shadow-sm p-2 d-inline-flex align-items-center">
                            <a href="?fieldId=${field.fieldID}&week=${prevWeek}" 
                               class="btn btn-sm btn-light rounded-pill px-3">
                                <i class="fas fa-chevron-left"></i>
                            </a>
                            <span class="mx-3 fw-bold text-primary">
                                <i class="far fa-calendar-alt me-2"></i>
                                ${weekStart} - ${weekStart.plusDays(6)}
                            </span>
                            <a href="?fieldId=${field.fieldID}&week=${nextWeek}" 
                               class="btn btn-sm btn-light rounded-pill px-3">
                                <i class="fas fa-chevron-right"></i>
                            </a>
                        </div>
                    </div>

                    <div class="col-lg-6 text-lg-end">
                        <div class="d-inline-flex gap-3 bg-white rounded-pill shadow-sm p-2 px-4">
                            <span class="d-flex align-items-center small">
                                <span class="legend-dot bg-success me-2"></span>
                                Trống
                            </span>
                            <span class="d-flex align-items-center small">
                                <span class="legend-dot bg-danger me-2"></span>
                                Đã đặt
                            </span>
                            <span class="d-flex align-items-center small">
                                <span class="legend-dot bg-secondary me-2"></span>
                                Khóa
                            </span>
                        </div>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${empty slots}">
                        <!-- Empty State -->
                        <div class="card border-0 shadow-sm rounded-4">
                            <div class="card-body text-center py-5">
                                <div class="empty-state d-flex flex-column align-items-center justify-content-center py-5">
                                    <div class="bg-light rounded-circle p-4 mb-3 d-inline-block text-muted">
                                        <i class="fas fa-calendar-times fa-3x"></i>
                                    </div>
                                    <h5 class="text-dark fw-bold mb-2">Chưa có khung giờ</h5>
                                    <p class="text-muted mb-4">Sân này chưa được thiết lập khung giờ hoạt động.</p>
                                    <a href="${pageContext.request.contextPath}/admin/fields?action=manageSlots&id=${field.fieldID}" 
                                       class="btn btn-primary rounded-pill px-4">
                                        <i class="fas fa-plus me-2"></i>Thêm khung giờ ngay
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                            <div class="card-body p-0">
                                <div class="table-responsive schedule-wrapper">
                                    <table class="table table-bordered mb-0 schedule-table text-center align-middle">
                                        <thead class="bg-light">
                                            <tr>
                                                <th class="time-col bg-white shadow-sm border-bottom-0">
                                                    <span class="text-muted small text-uppercase">Khung giờ</span>
                                                </th>
                                                <%
                                                    LocalDate weekStart = (LocalDate) request.getAttribute("weekStart");
                                                    DateTimeFormatter dayFormatter = DateTimeFormatter.ofPattern("dd/MM");
                                                    String[] dayNames = {"Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7", "CN"};
                                                    
                                                    for (int i = 0; i < 7; i++) {
                                                        LocalDate day = weekStart.plusDays(i);
                                                        String dayName = dayNames[i];
                                                        String dateStr = day.format(dayFormatter);
                                                %>
                                                <th class="py-3">
                                                    <div class="fw-bold text-dark"><%= dayName %></div>
                                                    <small class="text-muted fw-normal"><%= dateStr %></small>
                                                </th>
                                                <%
                                                    }
                                                %>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="slot" items="${slots}">
                                                <tr>
                                                    <td class="time-col bg-white fw-bold text-secondary shadow-sm">
                                                        ${slot.startTime}
                                                        <br>
                                                        <span class="text-muted small fw-normal">${slot.endTime}</span>
                                                    </td>
                                                    <%
                                                        for (int i = 0; i < 7; i++) {
                                                            LocalDate day = weekStart.plusDays(i);
                                                            pageContext.setAttribute("currentDay", day);
                                                    %>
                                                    <%-- Tìm booking cụ thể thay vì chỉ check true/false --%>
                                                    <c:set var="currentBooking" value="${null}" />
                                                    <c:forEach var="booking" items="${bookings}">
                                                        <c:if test="${booking.bookingDate eq currentDay && booking.slotID eq slot.slotID}">
                                                            <c:set var="currentBooking" value="${booking}" />
                                                        </c:if>
                                                    </c:forEach>
                                                    
                                                    <td class="p-2 schedule-cell position-relative">
                                                        <c:choose>
                                                            <c:when test="${slot.status eq 'INACTIVE'}">
                                                                <div class="slot-card bg-light text-muted border border-secondary-subtle">
                                                                    <div class="d-flex flex-column align-items-center justify-content-center slot-inner-wrapper">
                                                                        <i class="fas fa-lock mb-2"></i>
                                                                        <small>Khóa</small>
                                                                    </div>
                                                                </div>
                                                            </c:when>
                                                            <%-- Tích hợp Cách 1 & Cách 3 khi có người đặt --%>
                                                            <c:when test="${not empty currentBooking}">
                                                                <div class="slot-card bg-danger-subtle text-danger border border-danger-subtle position-relative slot-hoverable booked-slot-card"
                                                                     data-bs-toggle="modal" 
                                                                     data-bs-target="#bookingModal_${currentBooking.bookingID}_${slot.slotID}"
                                                                     title="Xem chi tiết đơn">
                                                                    <i class="fas fa-info-circle position-absolute top-0 end-0 m-1 slot-info-icon"></i>
                                                                    <div class="d-flex flex-column align-items-center justify-content-center slot-inner-wrapper">
                                                                        <i class="fas fa-user-check mb-2"></i>
                                                                        <small class="fw-bold text-center lh-sm booked-customer-name">
                                                                            ${not empty currentBooking.customerName ? currentBooking.customerName : 'Đã đặt'}
                                                                        </small>
                                                                    </div>
                                                                </div>
                                                                
                                                                <%-- Modal chi tiết booking --%>
                                                                <div class="modal fade text-start" 
                                                                     id="bookingModal_${currentBooking.bookingID}_${slot.slotID}" 
                                                                     tabindex="-1" 
                                                                     aria-hidden="true">
                                                                    <div class="modal-dialog modal-dialog-centered">
                                                                        <div class="modal-content border-0 shadow-lg">
                                                                            <div class="modal-header bg-danger-subtle border-0">
                                                                                <h5 class="modal-title text-danger fw-bold">
                                                                                    <i class="fas fa-calendar-check me-2"></i>Chi tiết đặt sân
                                                                                </h5>
                                                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                            </div>
                                                                            <div class="modal-body p-4">
                                                                                <div class="d-flex justify-content-between align-items-center mb-3 pb-3 border-bottom">
                                                                                    <h6 class="mb-0 text-muted">Mã đơn đặt:</h6>
                                                                                    <span class="fw-bold fs-5 text-primary">#BK${currentBooking.bookingID}</span>
                                                                                </div>
                                                                                
                                                                                <div class="mb-3 d-flex align-items-start">
                                                                                    <i class="fas fa-user text-muted mt-1 me-3 modal-icon-width"></i>
                                                                                    <div>
                                                                                        <div class="text-muted small">Khách hàng</div>
                                                                                        <div class="fw-bold text-dark fs-6">
                                                                                            ${not empty currentBooking.customerName ? currentBooking.customerName : 'N/A'}
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                                
                                                                                <div class="mb-3 d-flex align-items-start">
                                                                                    <i class="fas fa-phone-alt text-muted mt-1 me-3 modal-icon-width"></i>
                                                                                    <div>
                                                                                        <div class="text-muted small">Số điện thoại</div>
                                                                                        <c:choose>
                                                                                            <c:when test="${not empty currentBooking.customerPhone}">
                                                                                                <div class="fw-bold text-dark fs-6">
                                                                                                    ${currentBooking.customerPhone}
                                                                                                </div>
                                                                                            </c:when>
                                                                                            <c:otherwise>
                                                                                                <div class="fw-bold text-dark fs-6">N/A</div>
                                                                                            </c:otherwise>
                                                                                        </c:choose>
                                                                                    </div>
                                                                                </div>
                                                                                
                                                                                <div class="mb-3 d-flex align-items-start">
                                                                                    <i class="fas fa-clock text-muted mt-1 me-3 modal-icon-width"></i>
                                                                                    <div>
                                                                                        <div class="text-muted small">Khung giờ</div>
                                                                                        <div class="fw-bold text-dark fs-6">
                                                                                            ${slot.startTime} - ${slot.endTime}
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                                
                                                                                <div class="mb-2 d-flex align-items-start">
                                                                                    <i class="fas fa-money-bill-wave text-muted mt-1 me-3 modal-icon-width"></i>
                                                                                    <div>
                                                                                        <div class="text-muted small">Giá tiền</div>
                                                                                        <div class="fw-bold text-success fs-6">
                                                                                            <fmt:formatNumber value="${currentBooking.price != null ? currentBooking.price : slot.price}" 
                                                                                                            pattern="#,###"/>đ
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                            <div class="modal-footer bg-light border-0">
                                                                                <a href="${pageContext.request.contextPath}/admin/bookings?action=detail&id=${currentBooking.bookingID}" 
                                                                                   class="btn btn-primary w-100 rounded-pill fw-medium">
                                                                                    <i class="fas fa-external-link-alt me-2"></i>Quản lý đơn này
                                                                                </a>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </c:when>
                                                            <%-- Ô Trống --%>
                                                            <c:otherwise>
                                                                <div class="slot-card bg-success-subtle text-success border border-success-subtle slot-hoverable empty-slot-card">
                                                                    <div class="d-flex flex-column align-items-center justify-content-center slot-inner-wrapper">
                                                                        <i class="far fa-circle mb-2"></i>
                                                                        <small class="fw-medium">Trống</small>
                                                                    </div>
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <%
                                                        }
                                                    %>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>

                <!-- Action Buttons -->
                <div class="mt-4 d-flex gap-2 flex-wrap">
                    <a href="${pageContext.request.contextPath}/admin/fields" 
                       class="btn btn-outline-secondary">
                        <i class="fas fa-arrow-left me-2"></i>Quay lại
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/fields?action=manageSlots&id=${field.fieldID}" 
                       class="btn btn-outline-primary">
                        <i class="fas fa-cog me-2"></i>Quản lý khung giờ
                    </a>
                </div>

            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
