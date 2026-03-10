<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page import="java.time.LocalDate" %>
<%@page import="java.time.LocalDateTime" %>
<%@page import="java.time.format.DateTimeFormatter" %>

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
    <link href="${pageContext.request.contextPath}/assets/css/admin/admin-components.css" rel="stylesheet">
</head>
<body>

    <div class="admin-layout">

        <jsp:include page="../common/sidebar.jsp"></jsp:include>

        <div class="main-content">
            <div class="container-fluid px-0">

                <div class="page-header d-flex flex-wrap justify-content-between align-items-start gap-3">
                    <div>
                        <nav aria-label="breadcrumb" class="mb-2">
                            <ol class="breadcrumb small mb-0">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard" class="text-decoration-none text-muted">Hệ thống</a></li>
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/fields" class="text-decoration-none text-muted">Quản lý sân</a></li>
                                <li class="breadcrumb-item active text-primary fw-medium">Lịch sân</li>
                            </ol>
                        </nav>
                        <h2 class="page-title text-uppercase mb-0">
                            <i class="fas fa-calendar-alt"></i> Lịch: ${field.fieldName}
                        </h2>
                    </div>
                    
                    <div class="d-flex gap-2">
                        <a href="${pageContext.request.contextPath}/admin/fields" class="btn btn-outline-secondary btn-sm rounded-pill px-3 shadow-sm">
                            <i class="fas fa-arrow-left me-1"></i> Quay lại
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/fields?action=manageSlots&id=${field.fieldID}" class="btn btn-primary btn-sm rounded-pill px-3 shadow-sm">
                            <i class="fas fa-cog me-1"></i> Quản lý khung giờ
                        </a>
                    </div>
                </div>

                <div class="card border-0 shadow-sm rounded-4 mb-4">
                    <div class="card-body p-3 d-flex flex-wrap justify-content-between align-items-center gap-3">
                        
                        <div class="d-inline-flex align-items-center bg-light border rounded-pill p-1">
                            <a href="?fieldId=${field.fieldID}&week=${prevWeek}" class="btn btn-sm btn-white rounded-circle px-2 text-muted hover-primary">
                                <i class="fas fa-chevron-left"></i>
                            </a>
                            <span class="mx-3 fw-bold text-dark d-flex align-items-center" style="font-size: 0.9rem;">
                                <i class="far fa-calendar me-2 text-primary"></i>
                                ${weekStart} <i class="fas fa-arrow-right mx-2 text-muted" style="font-size: 0.7rem;"></i> ${weekStart.plusDays(6)}
                            </span>
                            <a href="?fieldId=${field.fieldID}&week=${nextWeek}" class="btn btn-sm btn-white rounded-circle px-2 text-muted hover-primary">
                                <i class="fas fa-chevron-right"></i>
                            </a>
                        </div>

                        <div class="d-flex flex-wrap gap-3 small fw-medium text-secondary">
                            <span class="d-flex align-items-center"><span class="legend-dot" style="background:#10b981;"></span> Trống</span>
                            <span class="d-flex align-items-center"><span class="legend-dot" style="background:#ef4444;"></span> Đã đặt</span>
                            <span class="d-flex align-items-center"><span class="legend-dot" style="background:#cbd5e1;"></span> Quá giờ</span>
                            <span class="d-flex align-items-center">
                                <span class="legend-dot" style="background: repeating-linear-gradient(45deg, #cbd5e1, #cbd5e1 2px, #94a3b8 2px, #94a3b8 4px);"></span> Khóa
                            </span>
                        </div>
                    </div>
                </div>

                <c:if test="${not empty sessionScope.error}">
                    <div class="alert alert-warning alert-dismissible fade show rounded-4 border-0 shadow-sm" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>${sessionScope.error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="error" scope="session" />
                </c:if>

                <c:choose>
                    <c:when test="${empty slots}">
                        <div class="card border-0 shadow-sm rounded-4 text-center py-5">
                            <div class="py-5">
                                <i class="fas fa-calendar-times fa-4x text-muted opacity-25 mb-3"></i>
                                <h5 class="fw-bold text-dark">Chưa có khung giờ</h5>
                                <p class="text-muted">Quản lý sân chưa thiết lập khung giờ hoạt động cho sân này.</p>
                                <a href="${pageContext.request.contextPath}/admin/fields?action=manageSlots&id=${field.fieldID}" class="btn btn-primary rounded-pill px-4 mt-2">
                                    <i class="fas fa-plus me-1"></i> Thêm khung giờ ngay
                                </a>
                            </div>
                        </div>
                    </c:when>
                    
                    <c:otherwise>
                        <div class="schedule-wrapper">
                            <table class="schedule-table">
                                <thead>
                                    <tr>
                                        <th class="time-col-header text-center align-middle">
                                            <i class="far fa-clock text-muted fs-5"></i>
                                        </th>
                                        
                                        <%
                                            LocalDate weekStart = (LocalDate) request.getAttribute("weekStart");
                                            DateTimeFormatter dayFormatter = DateTimeFormatter.ofPattern("dd/MM");
                                            String[] dayNames = {"Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7", "CN"};
                                            for (int i = 0; i < 7; i++) {
                                                LocalDate day = weekStart.plusDays(i);
                                                boolean isToday = day.equals(LocalDate.now());
                                        %>
                                        <th>
                                            <div class="d-flex flex-column align-items-center">
                                                <span class="fw-bold <%= isToday ? "text-primary" : "text-dark" %>" style="font-size: 0.95rem;"><%= dayNames[i] %></span>
                                                <span class="fw-normal <%= isToday ? "badge bg-primary text-white mt-1" : "text-muted" %>" style="font-size: 0.8rem;"><%= day.format(dayFormatter) %></span>
                                            </div>
                                        </th>
                                        <% } %>
                                    </tr>
                                </thead>
                                
                                <tbody>
                                    <c:forEach var="slot" items="${slots}">
                                        <tr>
                                            <th class="time-col">
                                                <div class="d-flex flex-column lh-1">
                                                    <span>${slot.startTime}</span>
                                                    <span class="text-muted fw-normal mt-1" style="font-size:0.75rem;">${slot.endTime}</span>
                                                </div>
                                            </th>
                                            
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

                                            <td>
                                                <c:choose>
                                                    <c:when test="${slot.status eq 'INACTIVE'}">
                                                        <div class="slot-cell slot-locked" title="Khung giờ bị khóa">
                                                            <i class="fas fa-lock mb-1 opacity-50"></i>
                                                        </div>
                                                    </c:when>
                                                    <c:when test="${isBooked}">
                                                        <div class="slot-cell slot-booked" title="Đã có khách đặt">
                                                            <i class="fas fa-user-check mb-1"></i>
                                                            <span>Đã đặt</span>
                                                        </div>
                                                    </c:when>
                                                    <c:when test="${isPast}">
                                                        <div class="slot-cell slot-past" title="Thời gian đã qua">
                                                            <i class="fas fa-minus mb-1 opacity-25"></i>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="${pageContext.request.contextPath}/booking?fieldId=${field.fieldID}&slotId=${slot.slotID}&date=${currentDay}" 
                                                           class="slot-cell slot-available" title="Click để đặt sân">
                                                            <i class="fas fa-plus mb-1 opacity-50"></i>
                                                        </a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <% } %>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>

            </div>
        </div>
    </div>

    <!-- We keep the Bootstrap JS as required by possible dropdowns/modals in admin layout/sidebar, but logic calculation uses nothing. -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
