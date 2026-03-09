<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page import="java.time.LocalDate" %>
<%@page import="java.time.LocalDateTime" %>
<%@page import="java.time.format.DateTimeFormatter" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>${field.fieldName} - SportFieldHub</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600;800;900&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/customer/base.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/customer/detail.css" rel="stylesheet">
    </head>
    <body>
        <jsp:include page="../common/header.jsp" />

        <main class="pb-5">
            <div class="bg-dark text-white pt-5 pb-5 mb-5 detail-hero-header">
                <div class="container pb-5">
                    <a href="${pageContext.request.contextPath}/shop" class="text-white text-decoration-none mb-4 d-inline-block opacity-75 hover-opacity-100">
                        <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
                    </a>
                    <div class="row align-items-center g-5">
                        <div class="col-lg-6">
                            <span class="badge bg-danger px-3 py-2 fs-6 rounded-pill mb-3">Sân ${field.fieldType} Người</span>
                            <h1 class="display-4 fw-bold mb-3">${field.fieldName}</h1>
                            <p class="lead opacity-75 mb-4"><i class="fas fa-map-marker-alt text-danger me-2"></i>Cơ sở chính - Sân cỏ nhân tạo chất lượng cao.</p>


                        </div>
                        <div class="col-lg-6">
                            <c:choose>
                                <c:when test="${not empty field.imageURL}">
                                    <img src="${field.imageURL}" class="detail-img" alt="${field.fieldName}">
                                </c:when>
                                <c:otherwise>
                                    <div class="detail-img bg-secondary d-flex justify-content-center align-items-center">
                                        <i class="fas fa-futbol fa-5x opacity-25"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <div class="container">
                <div class="schedule-card">
                    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3 border-bottom pb-3">
                        <h3 class="fw-bold mb-0 text-dark"><i class="fas fa-calendar-check text-danger me-2"></i>Lịch Đá Tuần Này</h3>

                        <div class="bg-light rounded-pill p-1 d-inline-flex align-items-center border">
                            <a href="?id=${field.fieldID}&week=${prevWeek}" class="btn btn-sm btn-white rounded-circle"><i class="fas fa-chevron-left"></i></a>
                            <span class="mx-3 fw-bold text-dark">${weekStart} <i class="fas fa-arrow-right mx-1 text-muted small"></i> ${weekStart.plusDays(6)}</span>
                            <a href="?id=${field.fieldID}&week=${nextWeek}" class="btn btn-sm btn-white rounded-circle"><i class="fas fa-chevron-right"></i></a>
                        </div>
                    </div>

                    <div class="d-flex gap-4 mb-4">
                        <span class="d-flex align-items-center fw-medium"><span class="bg-success rounded-circle me-2 status-indicator"></span> Bấm để đặt</span>
                        <span class="d-flex align-items-center fw-medium text-muted"><span class="bg-danger rounded-circle me-2 status-indicator"></span> Kín lịch</span>
                        <span class="d-flex align-items-center fw-medium text-muted"><span class="bg-secondary rounded-circle me-2 status-indicator"></span> Đóng cửa</span>
                        <span class="d-flex align-items-center fw-medium text-muted"><span class="bg-secondary rounded-circle me-2 status-indicator"></span> Đã quá giờ</span>
                    </div>

                    <c:if test="${not empty sessionScope.error}">
                        <div class="alert alert-warning mb-4" role="alert">
                            <i class="fas fa-exclamation-triangle me-2"></i>${sessionScope.error}
                            <c:remove var="error" scope="session" />
                        </div>
                    </c:if>

                    <c:choose>
                        <c:when test="${empty slots}">
                            <div class="text-center py-5 bg-light rounded-4">
                                <i class="fas fa-clipboard-list fa-3x text-muted mb-3 opacity-50"></i>
                                <h5 class="fw-bold">Chưa mở lịch đặt</h5>
                                <p class="text-muted">Quản lý sân chưa thiết lập khung giờ cho tuần này.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-bordered text-center align-middle mb-0 field-schedule-table">
                                    <thead>
                                        <tr>
                                            <th class="py-3 time-col-header">Khung giờ</th>
                                                <%
                                                    LocalDate weekStart = (LocalDate) request.getAttribute("weekStart");
                                                    DateTimeFormatter dayFormatter = DateTimeFormatter.ofPattern("dd/MM");
                                                    String[] dayNames = {"Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7", "CN"};
                                                    for (int i = 0; i < 7; i++) {
                                                        LocalDate day = weekStart.plusDays(i);
                                                %>
                                            <th class="py-3">
                                                <div class="fw-bold"><%= dayNames[i]%></div>
                                                <small class="fw-normal opacity-75"><%= day.format(dayFormatter)%></small>
                                            </th>
                                            <% } %>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="slot" items="${slots}">
                                            <tr>
                                                <td class="time-col fw-bold fs-6">
                                                    ${slot.startTime} <br> <small class="text-muted fw-normal">${slot.endTime}</small>
                                                </td>
                                                <%
                                                    for (int i = 0; i < 7; i++) {
                                                        LocalDate day = weekStart.plusDays(i);
                                                        pageContext.setAttribute("currentDay", day);
                                                %>
                                                <c:set var="isBooked" value="false" />
                                                <c:forEach var="booking" items="${bookings}">
                                                    <c:if test="${booking.bookingDate eq currentDay && booking.slotID eq slot.slotID}">
                                                        <c:set var="isBooked" value="true" />
                                                    </c:if>
                                                </c:forEach>
                                                <%
                                                    LocalDate currentDayVal = (LocalDate) pageContext.getAttribute("currentDay");
                                                    com.sportfield.model.FieldSlot s = (com.sportfield.model.FieldSlot) pageContext.getAttribute("slot");
                                                    LocalDateTime slotEnd = currentDayVal.atTime(s.getEndTime());
                                                    boolean isPast = slotEnd.isBefore(LocalDateTime.now());
                                                    pageContext.setAttribute("isPast", isPast);
                                                %>

                                                <td class="p-2">
                                                    <c:choose>
                                                        <c:when test="${slot.status eq 'INACTIVE'}">
                                                            <div class="slot-card bg-secondary-subtle">
                                                                <i class="fas fa-lock mb-1"></i> <small>Khóa</small>
                                                            </div>
                                                        </c:when>
                                                        <c:when test="${isBooked}">
                                                            <div class="slot-card bg-danger-subtle">
                                                                <i class="fas fa-times-circle mb-1"></i> <small class="fw-bold">Đã đặt</small>
                                                            </div>
                                                        </c:when>
                                                        <c:when test="${isPast}">
                                                            <div class="slot-card bg-secondary-subtle">
                                                                <i class="fas fa-clock mb-1"></i> <small>Đã quá giờ</small>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="${pageContext.request.contextPath}/booking?fieldId=${field.fieldID}&slotId=${slot.slotID}&date=${currentDay}" class="slot-card-link h-100">
                                                                <div class="slot-card bg-success-subtle h-100">
                                                                    <i class="fas fa-plus-circle mb-1"></i> <small class="fw-bold">Trống</small>
                                                                </div>
                                                            </a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <% }%>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>

        <jsp:include page="../common/footer.jsp" />
    </body>
</html>

