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
    <link href="${pageContext.request.contextPath}/assets/css/admin.css?v=2" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/admin-roles.css?v=2" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/admin-modals.css?v=2" rel="stylesheet">
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

                <div class="d-flex align-items-center mb-4 gap-2">
                    <a href="?role=ALL" class="btn btn-sm ${empty selectedRole || selectedRole == 'ALL' ? 'btn-dark' : 'btn-outline-dark'} rounded-pill px-4 fw-medium shadow-sm">
                        <i class="fas fa-layer-group me-1"></i> Tất cả
                    </a>
                    <a href="?role=STAFF" class="btn btn-sm ${selectedRole == 'STAFF' ? 'btn-warning text-white' : 'btn-outline-warning'} rounded-pill px-4 fw-medium shadow-sm">
                        <i class="fas fa-user-tie me-1"></i> Staff
                    </a>
                    <a href="?role=CUSTOMER" class="btn btn-sm ${selectedRole == 'CUSTOMER' ? 'btn-primary' : 'btn-outline-primary'} rounded-pill px-4 fw-medium shadow-sm">
                        <i class="fas fa-user me-1"></i> Customer
                    </a>
                    <a href="?type=new_customers" class="btn btn-sm ${selectedRole == 'NEW_CUSTOMERS' ? 'btn-success' : 'btn-outline-success'} rounded-pill px-4 fw-medium shadow-sm">
                        <i class="fas fa-user-plus me-1"></i> Khách hàng mới
                    </a>
                </div>

                <c:if test="${selectedRole == 'NEW_CUSTOMERS'}">
                    <div class="alert alert-info border-0 shadow-sm rounded-3 mb-4">
                        <i class="fas fa-info-circle me-2"></i>
                        Danh sách khách hàng mới đăng ký trong <strong>Tháng ${filterMonth}/${filterYear}</strong>
                    </div>

                    <!-- Bộ lọc tháng/năm đơn giản, tự submit bằng onchange -->
                    <form method="get" class="row g-2 align-items-end mb-4">
                        <input type="hidden" name="type" value="new_customers">
                        <div class="col-auto">
                            <label class="form-label small fw-bold text-muted mb-1">Tháng</label>
                            <select name="month" class="form-select form-select-sm" onchange="this.form.submit()">
                                <c:forEach var="m" begin="1" end="12">
                                    <option value="${m}" <c:if test="${m == filterMonth}">selected</c:if>>Tháng ${m}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-auto">
                            <label class="form-label small fw-bold text-muted mb-1">Năm</label>
                            <select name="year" class="form-select form-select-sm" onchange="this.form.submit()">
                                <c:forEach var="y" begin="${filterYear - 2}" end="${filterYear}">
                                    <option value="${y}" <c:if test="${y == filterYear}">selected</c:if>>${y}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </form>
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
                                        <div class="dropdown role-dropdown">
                                            <button class="dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false" ${sessionScope.account.userID == user.userID ? 'disabled' : ''}>
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
                                            </button>
                                            
                                            <ul class="dropdown-menu dropdown-menu-modern">
                                                <li class="dropdown-header-modern">
                                                    <i class="fas fa-user-tag me-1"></i>Chọn vai trò mới
                                                </li>
                                                <li><hr class="dropdown-divider dropdown-divider-modern"></li>
                                                
                                                <!-- CUSTOMER Role -->
                                                <li class="dropdown-item-modern role-item-customer ${user.role == 'CUSTOMER' ? 'active' : ''}">
                                                    <form method="post" action="${pageContext.request.contextPath}/admin/users" class="role-submit-btn">
                                                        <input type="hidden" name="action" value="changeRole">
                                                        <input type="hidden" name="id" value="${user.userID}">
                                                        <input type="hidden" name="newRole" value="CUSTOMER">
                                                        <button type="submit" class="role-submit-btn" ${user.role == 'CUSTOMER' ? 'disabled' : ''}>
                                                            <div class="role-item-content">
                                                                <div class="role-icon">
                                                                    <i class="fas fa-user"></i>
                                                                </div>
                                                                <div class="role-info">
                                                                    <div class="role-name">CUSTOMER</div>
                                                                    <div class="role-desc">Khách hàng sử dụng dịch vụ</div>
                                                                </div>
                                                                <c:if test="${user.role == 'CUSTOMER'}">
                                                                    <i class="fas fa-check-circle role-check"></i>
                                                                </c:if>
                                                            </div>
                                                        </button>
                                                    </form>
                                                </li>
                                                
                                                <!-- STAFF Role -->
                                                <li class="dropdown-item-modern role-item-staff ${user.role == 'STAFF' ? 'active' : ''}">
                                                    <form method="post" action="${pageContext.request.contextPath}/admin/users" class="role-submit-btn">
                                                        <input type="hidden" name="action" value="changeRole">
                                                        <input type="hidden" name="id" value="${user.userID}">
                                                        <input type="hidden" name="newRole" value="STAFF">
                                                        <button type="submit" class="role-submit-btn" ${user.role == 'STAFF' ? 'disabled' : ''}>
                                                            <div class="role-item-content">
                                                                <div class="role-icon">
                                                                    <i class="fas fa-user-shield"></i>
                                                                </div>
                                                                <div class="role-info">
                                                                    <div class="role-name">STAFF</div>
                                                                    <div class="role-desc">Nhân viên quản lý vận hành</div>
                                                                </div>
                                                                <c:if test="${user.role == 'STAFF'}">
                                                                    <i class="fas fa-check-circle role-check"></i>
                                                                </c:if>
                                                            </div>
                                                        </button>
                                                    </form>
                                                </li>
                                                
                                                <!-- ADMIN Role -->
                                                <li class="dropdown-item-modern role-item-admin ${user.role == 'ADMIN' ? 'active' : ''}">
                                                    <form method="post" action="${pageContext.request.contextPath}/admin/users" class="role-submit-btn">
                                                        <input type="hidden" name="action" value="changeRole">
                                                        <input type="hidden" name="id" value="${user.userID}">
                                                        <input type="hidden" name="newRole" value="ADMIN">
                                                        <button type="submit" class="role-submit-btn" ${user.role == 'ADMIN' ? 'disabled' : ''}>
                                                            <div class="role-item-content">
                                                                <div class="role-icon">
                                                                    <i class="fas fa-crown"></i>
                                                                </div>
                                                                <div class="role-info">
                                                                    <div class="role-name">ADMIN</div>
                                                                    <div class="role-desc">Toàn quyền quản trị hệ thống</div>
                                                                </div>
                                                                <c:if test="${user.role == 'ADMIN'}">
                                                                    <i class="fas fa-check-circle role-check"></i>
                                                                </c:if>
                                                            </div>
                                                        </button>
                                                    </form>
                                                </li>
                                            </ul>
                                        </div>
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
                                            <a href="#deleteModal${user.userID}" 
                                               class="btn btn-white btn-sm ${sessionScope.account.userID == user.userID ? 'disabled' : ''}" 
                                               title="Xóa"
                                               ${sessionScope.account.userID == user.userID ? 'aria-disabled="true" style="pointer-events: none; opacity: 0.6;"' : ''}>
                                                <i class="fas fa-trash text-danger"></i>
                                            </a>
                                        </div>

                                        <!-- CSS Pure Modal (:target) -->
                                        <div id="deleteModal${user.userID}" class="css-modal-overlay">
                                            <div class="css-modal-content animate-slide-up">
                                                <div class="d-flex flex-column align-items-center text-center">
                                                    <div class="css-modal-icon">
                                                        <i class="fas fa-exclamation-triangle fa-lg"></i>
                                                    </div>
                                                    <h3 class="css-modal-title">Xóa người dùng?</h3>
                                                    <p class="css-modal-text">
                                                        Bạn có chắc chắn muốn xóa người dùng <strong>${user.fullName}</strong> (@${user.username})? 
                                                        <br>Hành động này không thể hoàn tác.
                                                    </p>
                                                    <div class="css-modal-actions w-100 justify-content-center">
                                                        <a href="#" class="css-modal-btn stay">
                                                            Hủy bỏ
                                                        </a>
                                                        <form method="post" action="${pageContext.request.contextPath}/admin/users" class="d-inline">
                                                            <input type="hidden" name="action" value="delete">
                                                            <input type="hidden" name="id" value="${user.userID}">
                                                            <button type="submit" class="css-modal-btn leave cursor-pointer border-0">
                                                                Xóa ngay
                                                            </button>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                            <a href="#" class="css-modal-close-area" style="position: absolute; inset: 0; z-index: -1;"></a>
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
