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
        <div class="admin-layout">
            <jsp:include page="../common/sidebar.jsp" />

            <div class="main-content">
                <div class="container-fluid px-0">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb mb-1">
                                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard" class="text-decoration-none text-muted">Hệ thống</a></li>
                                    <li class="breadcrumb-item active" aria-current="page">Quản lý liên hệ</li>
                                </ol>
                            </nav>
                            <h2 class="fw-bold mb-0 text-dark"><i class="fas fa-envelope me-2 text-info"></i>Quản Lý Liên Hệ</h2>
                        </div>
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

                    <div class="bg-white rounded-3 border border-light shadow-sm">
                        <table class="table table-hover align-middle mb-0" style="table-layout: fixed; width: 100%;">
                            <colgroup>
                                <col style="width: 50px;">
                                <col style="width: 120px;">
                                <col style="width: 200px;">
                                <col style="width: 120px;">
                                <col style="width: 130px;">
                                <col style="width: 130px;">
                                <col style="width: 110px;">
                                <col style="width: 100px;">
                            </colgroup>
                            <thead class="table-light">
                                <tr>
                                    <th class="ps-3">ID</th>
                                    <th>Họ Tên</th>
                                    <th>Email</th>
                                    <th>SĐT</th>
                                    <th>Chủ Đề</th>
                                    <th>Ngày Gửi</th>
                                    <th>Trạng Thái</th>
                                    <th class="text-end pe-3">Thao Tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="msg" items="${contactMessages}">
                                    <tr>
                                        <td class="ps-3 text-muted small">#${msg.contactID}</td>
                                        <td class="fw-medium text-dark text-truncate" style="max-width:120px;" title="${msg.fullName}">${msg.fullName}</td>
                                        <td class="text-truncate text-muted small" style="max-width:200px;" title="${msg.email}">${msg.email}</td>
                                        <td class="small">${msg.phone}</td>
                                        <td><span class="badge bg-info text-truncate d-inline-block" style="max-width:120px;" title="${msg.subject}">${msg.subject}</span></td>
                                        <td class="small text-muted">
                                            <fmt:formatDate value="${msg.createdAtAsDate}" pattern="dd/MM/yyyy HH:mm" />
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${msg.status == 'NEW'}"><span class="badge bg-primary">Mới</span></c:when>
                                                <c:when test="${msg.status == 'READ'}"><span class="badge bg-info text-dark">Đã xem</span></c:when>
                                                <c:when test="${msg.status == 'REPLIED'}"><span class="badge bg-success">Đã phản hồi</span></c:when>
                                                <c:otherwise><span class="badge bg-secondary">${msg.status}</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end pe-3">
                                            <div class="d-flex gap-1 justify-content-end">
                                                <button type="button" class="btn btn-sm btn-light border" 
                                                        data-bs-toggle="modal" 
                                                        data-bs-target="#detailModal${msg.contactID}" title="Xem chi tiết">
                                                    <i class="fas fa-eye text-primary"></i>
                                                </button>
                                                <div class="dropdown">
                                                    <button class="btn btn-sm btn-light border dropdown-toggle" 
                                                            type="button" data-bs-toggle="dropdown" title="Đổi trạng thái">
                                                        <i class="fas fa-edit text-secondary"></i>
                                                    </button>
                                                    <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0">
                                                        <c:if test="${msg.status != 'READ'}">
                                                            <li><a class="dropdown-item small" href="${pageContext.request.contextPath}/admin/contacts?action=updateStatus&id=${msg.contactID}&status=READ"><i class="fas fa-check-circle text-info me-2"></i>Đã xem</a></li>
                                                        </c:if>
                                                        <c:if test="${msg.status != 'REPLIED'}">
                                                            <li><a class="dropdown-item small" href="${pageContext.request.contextPath}/admin/contacts?action=updateStatus&id=${msg.contactID}&status=REPLIED"><i class="fas fa-reply text-success me-2"></i>Đã phản hồi</a></li>
                                                        </c:if>
                                                        <c:if test="${msg.status != 'NEW'}">
                                                            <li><a class="dropdown-item small" href="${pageContext.request.contextPath}/admin/contacts?action=updateStatus&id=${msg.contactID}&status=NEW"><i class="fas fa-undo text-secondary me-2"></i>Đánh dấu chưa đọc</a></li>
                                                        </c:if>
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
                                                    <h5 class="modal-title"><i class="fas fa-envelope me-2 text-info"></i>Chi Tiết Liên Hệ #${msg.contactID}</h5>
                                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                </div>
                                                <div class="modal-body">
                                                    <div class="row g-3 mb-3">
                                                        <div class="col-md-6">
                                                            <div class="text-muted small mb-1">Họ tên</div>
                                                            <div class="fw-medium">${msg.fullName}</div>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <div class="text-muted small mb-1">Email</div>
                                                            <div class="fw-medium">${msg.email}</div>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <div class="text-muted small mb-1">SĐT</div>
                                                            <div class="fw-medium">${msg.phone}</div>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <div class="text-muted small mb-1">Chủ đề</div>
                                                            <span class="badge bg-info">${msg.subject}</span>
                                                        </div>
                                                    </div>
                                                    <div class="mb-3">
                                                        <div class="text-muted small mb-1">Nội dung</div>
                                                        <div class="p-3 bg-light rounded border">${msg.message}</div>
                                                    </div>
                                                    <div class="row g-3">
                                                        <div class="col-md-6">
                                                            <div class="text-muted small mb-1">Ngày gửi</div>
                                                            <div class="fw-medium"><fmt:formatDate value="${msg.createdAtAsDate}" pattern="dd/MM/yyyy HH:mm:ss" /></div>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <div class="text-muted small mb-1">Trạng thái</div>
                                                            <c:choose>
                                                                <c:when test="${msg.status == 'NEW'}"><span class="badge bg-primary">Mới</span></c:when>
                                                                <c:when test="${msg.status == 'READ'}"><span class="badge bg-info text-dark">Đã xem</span></c:when>
                                                                <c:when test="${msg.status == 'REPLIED'}"><span class="badge bg-success">Đã phản hồi</span></c:when>
                                                                <c:otherwise><span class="badge bg-secondary">${msg.status}</span></c:otherwise>
                                                            </c:choose>
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
                                        <td colspan="8" class="text-center py-5 text-muted">
                                            <i class="fas fa-inbox fa-2x mb-2 d-block opacity-50"></i>
                                            Chưa có tin nhắn liên hệ nào
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
