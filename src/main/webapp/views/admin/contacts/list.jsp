<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản Lý Liên Hệ - Admin</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/assets/css/admin/admin.css" rel="stylesheet">
    </head>
    <body>
        <div class="admin-wrapper">
            <jsp:include page="../common/sidebar.jsp" />

            <div class="admin-content">
                <div class="container-fluid">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="fw-bold"><i class="fas fa-envelope me-2"></i>Quản Lý Liên Hệ</h2>
                    </div>

                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success alert-dismissible fade show">
                            <i class="fas fa-check-circle me-2"></i>${successMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show">
                            <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <div class="card shadow-sm">
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead class="table-light">
                                        <tr>
                                            <th>ID</th>
                                            <th>Họ Tên</th>
                                            <th>Email</th>
                                            <th>SĐT</th>
                                            <th>Chủ Đề</th>
                                            <th>Nội Dung</th>
                                            <th>Ngày Gửi</th>
                                            <th>Trạng Thái</th>
                                            <th>Thao Tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="msg" items="${contactMessages}">
                                            <tr>
                                                <td>${msg.contactID}</td>
                                                <td>${msg.fullName}</td>
                                                <td>${msg.email}</td>
                                                <td>${msg.phone}</td>
                                                <td><span class="badge bg-info">${msg.subject}</span></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${msg.message.length() > 50}">
                                                            ${msg.message.substring(0, 50)}...
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${msg.message}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <fmt:formatDate value="${msg.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${msg.status == 'NEW'}">
                                                            <span class="badge bg-primary">Mới</span>
                                                        </c:when>
                                                        <c:when test="${msg.status == 'IN_PROGRESS'}">
                                                            <span class="badge bg-warning">Đang xử lý</span>
                                                        </c:when>
                                                        <c:when test="${msg.status == 'RESOLVED'}">
                                                            <span class="badge bg-success">Đã giải quyết</span>
                                                        </c:when>
                                                        <c:when test="${msg.status == 'CLOSED'}">
                                                            <span class="badge bg-secondary">Đã đóng</span>
                                                        </c:when>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div class="btn-group">
                                                        <button type="button" class="btn btn-sm btn-primary" 
                                                                data-bs-toggle="modal" 
                                                                data-bs-target="#detailModal${msg.contactID}">
                                                            <i class="fas fa-eye"></i>
                                                        </button>
                                                        <div class="dropdown">
                                                            <button class="btn btn-sm btn-secondary dropdown-toggle" 
                                                                    type="button" data-bs-toggle="dropdown">
                                                                <i class="fas fa-edit"></i>
                                                            </button>
                                                            <ul class="dropdown-menu">
                                                                <li>
                                                                    <a class="dropdown-item" 
                                                                       href="?action=updateStatus&id=${msg.contactID}&status=IN_PROGRESS">
                                                                        Đang xử lý
                                                                    </a>
                                                                </li>
                                                                <li>
                                                                    <a class="dropdown-item" 
                                                                       href="?action=updateStatus&id=${msg.contactID}&status=RESOLVED">
                                                                        Đã giải quyết
                                                                    </a>
                                                                </li>
                                                                <li>
                                                                    <a class="dropdown-item" 
                                                                       href="?action=updateStatus&id=${msg.contactID}&status=CLOSED">
                                                                        Đóng
                                                                    </a>
                                                                </li>
                                                            </ul>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>

                                            <!-- Detail Modal -->
                                            <div class="modal fade" id="detailModal${msg.contactID}" tabindex="-1">
                                                <div class="modal-dialog modal-lg">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title">Chi Tiết Liên Hệ #${msg.contactID}</h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <div class="row mb-3">
                                                                <div class="col-md-6">
                                                                    <strong>Họ tên:</strong> ${msg.fullName}
                                                                </div>
                                                                <div class="col-md-6">
                                                                    <strong>Email:</strong> ${msg.email}
                                                                </div>
                                                            </div>
                                                            <div class="row mb-3">
                                                                <div class="col-md-6">
                                                                    <strong>SĐT:</strong> ${msg.phone}
                                                                </div>
                                                                <div class="col-md-6">
                                                                    <strong>Chủ đề:</strong> ${msg.subject}
                                                                </div>
                                                            </div>
                                                            <div class="mb-3">
                                                                <strong>Nội dung:</strong>
                                                                <p class="mt-2 p-3 bg-light rounded">${msg.message}</p>
                                                            </div>
                                                            <div class="row">
                                                                <div class="col-md-6">
                                                                    <strong>Ngày gửi:</strong> 
                                                                    <fmt:formatDate value="${msg.createdAt}" pattern="dd/MM/yyyy HH:mm:ss" />
                                                                </div>
                                                                <div class="col-md-6">
                                                                    <strong>Trạng thái:</strong> ${msg.status}
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>

                                        <c:if test="${empty contactMessages}">
                                            <tr>
                                                <td colspan="9" class="text-center py-4">
                                                    <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                                    <p class="text-muted">Chưa có tin nhắn liên hệ nào</p>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
