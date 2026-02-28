<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Người Dùng - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/admin.css" rel="stylesheet">
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
                                <li class="breadcrumb-item active text-primary fw-medium">Quản lý nhân sự</li>
                            </ol>
                        </nav>
                        <h2 class="page-title text-uppercase mb-0">
                            <i class="fas fa-user-shield"></i>
                            Quản lý người dùng
                            <span class="count-badge">Tổng: ${fn:length(users)}</span>
                        </h2>
                        <p class="page-subtitle">Quản lý tài khoản, phân quyền vai trò và theo dõi số dư ví thành viên.</p>
                    </div>
                    <div class="d-flex gap-2">
                        <a href="#" class="btn btn-outline-primary btn-sm rounded-pill px-3 shadow-sm">
                            <i class="fas fa-file-export me-1"></i> Xuất Excel
                        </a>
                    </div>
                </div>

                <c:if test="${not empty sessionScope.success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${sessionScope.success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="success" scope="session" />
                </c:if>

                <c:if test="${not empty sessionScope.error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>${sessionScope.error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="error" scope="session" />
                </c:if>

                <div class="row">
                    <div class="col-12">
                        <div class="card border-0 shadow-sm rounded-4">
                            <div class="card-body p-0">
                                <div class="table-container">
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle">
                                        <thead>
                                            <tr>
                                                <th class="ps-4">Người dùng</th>
                                                <th>Email</th>
                                                <th>Vai trò</th>
                                                <th>Ngày tạo</th>
                                                <th class="text-end pe-4">Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                            <c:forEach var="user" items="${users}">
                                <tr>
                                    <td class="ps-4">
                                        <div class="d-flex align-items-center">
                                            <c:choose>
                                                <c:when test="${not empty user.avatar}">
                                                    <img src="${user.avatar}" alt="${user.fullName}" class="rounded-circle me-3 user-avatar">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="bg-primary-subtle text-primary rounded-circle p-2 me-3 user-avatar-fallback user-avatar-fallback-show">
                                                        <span class="fw-bold">${user.fullName.substring(0,1).toUpperCase()}</span>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                            <div>
                                                <div class="fw-bold">${user.fullName}</div>
                                                <div class="small text-muted">@${user.username}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>${user.email}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${user.role == 'ADMIN'}">
                                                <span class="badge-modern badge-admin">
                                                    <i class="fas fa-crown me-2"></i>ADMIN
                                                </span>
                                            </c:when>
                                            <c:when test="${user.role == 'STAFF'}">
                                                <span class="badge-modern badge-staff">
                                                    <i class="fas fa-user-shield me-2"></i>STAFF
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-modern badge-customer">
                                                    <i class="fas fa-user me-2"></i>CUSTOMER
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-muted small">
                                        <i class="far fa-calendar me-1"></i>
                                        <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy"/>
                                    </td>
                                    <td class="text-end pe-4">
                                        <div class="btn-group shadow-sm rounded-3 overflow-hidden">
                                            <a href="?action=edit&id=${user.userID}" 
                                               class="btn btn-white btn-sm border-end" 
                                               title="Chỉnh sửa">
                                                <i class="fas fa-edit text-primary"></i>
                                            </a>
                                            <button class="btn btn-white btn-sm" 
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#deleteModal${user.userID}"
                                                    title="Xóa"
                                                    ${sessionScope.account.userID == user.userID ? 'disabled' : ''}>
                                                <i class="fas fa-trash text-danger"></i>
                                            </button>
                                        </div>

                                        <div class="modal fade" id="deleteModal${user.userID}" tabindex="-1">
                                            <div class="modal-dialog modal-dialog-centered">
                                                <div class="modal-content border-0 shadow-lg confirm-delete-modal">
                                                    <div class="confirm-delete-modal-header d-flex justify-content-between align-items-start">
                                                        <div class="d-flex align-items-center">
                                                            <i class="fas fa-exclamation-triangle me-2"></i>
                                                            <div>
                                                                <h5 class="modal-title mb-0">Xác nhận xóa người dùng</h5>
                                                                <small>Hành động này không thể hoàn tác.</small>
                                                            </div>
                                                        </div>
                                                        <button type="button" class="btn-close btn-close-white ms-2" data-bs-dismiss="modal"></button>
                                                    </div>
                                                    <div class="confirm-delete-modal-body">
                                                        <p class="mb-3">Bạn có chắc chắn muốn xóa tài khoản sau khỏi hệ thống?</p>
                                                        <div class="user-confirm-card d-flex align-items-center p-3 mb-2">
                                                            <div class="avatar-circle me-3">
                                                                <c:choose>
                                                                    <c:when test="${not empty user.avatar}">
                                                                        <img src="${user.avatar}" alt="${user.fullName}">
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span>${fn:toUpperCase(user.fullName.substring(0,1))}</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                            <div class="flex-grow-1">
                                                                <div class="user-confirm-name">${user.fullName}</div>
                                                                <div class="user-confirm-username">@${user.username}</div>
                                                            </div>
                                                        </div>
                                                        <p class="text-muted small mb-0">Mọi dữ liệu liên quan đến người dùng này có thể bị ảnh hưởng sau khi xóa.</p>
                                                    </div>
                                                    <div class="modal-footer confirm-delete-modal-footer">
                                                        <button type="button" class="btn btn-light border" data-bs-dismiss="modal">
                                                            <i class="fas fa-times me-1"></i>Hủy
                                                        </button>
                                                        <form method="post" action="${pageContext.request.contextPath}/admin/users" class="d-inline">
                                                            <input type="hidden" name="action" value="delete">
                                                            <input type="hidden" name="id" value="${user.userID}">
                                                            <button type="submit" class="btn btn-danger">
                                                                <i class="fas fa-trash me-1"></i>Xóa ngay
                                                            </button>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>

                            <c:if test="${empty users}">
                                <tr>
                                    <td colspan="5" class="text-center py-4 text-muted">
                                        <i class="fas fa-inbox fa-3x mb-3"></i>
                                        <p>Không có người dùng nào</p>
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
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
