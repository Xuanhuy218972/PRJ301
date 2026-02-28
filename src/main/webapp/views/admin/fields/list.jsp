<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Sân Bóng - Admin</title>
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
                                <li class="breadcrumb-item active text-primary fw-medium">Quản lý sân bóng</li>
                            </ol>
                        </nav>
                        <h2 class="page-title text-uppercase mb-0">
                            <i class="fas fa-futbol"></i>
                            Quản lý sân bóng
                            <span class="count-badge">Tổng: ${fn:length(fields)}</span>
                        </h2>
                        <p class="page-subtitle">Quản lý thông tin sân, giá thuê và khung giờ hoạt động.</p>
                    </div>
                    <div class="d-flex gap-2">
                        <a href="?action=add" class="btn btn-primary btn-sm rounded-pill px-3 shadow-sm">
                            <i class="fas fa-plus me-1"></i> Thêm sân mới
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
                                                <th class="ps-4">Tên sân</th>
                                                <th>Loại sân</th>
                                                <th>Giá/giờ</th>
                                                <th>Trạng thái</th>
                                                <th>Ngày tạo</th>
                                                <th class="text-end pe-4">Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                            <c:forEach var="field" items="${fields}">
                                <tr>
                                    <td class="ps-4">
                                        <div class="d-flex align-items-center">
                                            <c:choose>
                                                <c:when test="${not empty field.imageURL}">
                                                    <img src="${field.imageURL}" alt="${field.fieldName}" class="rounded me-3" style="width: 50px; height: 50px; object-fit: cover;">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="bg-success-subtle text-success rounded p-2 me-3" style="width: 50px; height: 50px; display: flex; align-items: center; justify-content: center;">
                                                        <i class="fas fa-futbol fa-lg"></i>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                            <div>
                                                <div class="fw-bold">${field.fieldName}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${field.fieldType == 5}">Sân 5</c:when>
                                            <c:when test="${field.fieldType == 7}">Sân 7</c:when>
                                            <c:when test="${field.fieldType == 11}">Sân 11</c:when>
                                            <c:otherwise>Sân ${field.fieldType}</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="fw-bold text-success">
                                        <fmt:formatNumber value="${field.pricePerHour}" pattern="#,###"/>đ
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${field.status == 'ACTIVE'}">
                                                <span class="badge bg-success-subtle text-success">
                                                    <i class="fas fa-check-circle me-1"></i>Hoạt động
                                                </span>
                                            </c:when>
                                            <c:when test="${field.status == 'MAINTENANCE'}">
                                                <span class="badge bg-warning-subtle text-warning">
                                                    <i class="fas fa-tools me-1"></i>Bảo trì
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary-subtle text-secondary">
                                                    <i class="fas fa-eye-slash me-1"></i>Ẩn
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="text-muted small">
                                        <i class="far fa-calendar me-1"></i>
                                        ${field.createdAt != null ? field.createdAt.toString().substring(0, 10) : 'N/A'}
                                    </td>
                                    <td class="text-end pe-4">
                                        <div class="btn-group shadow-sm rounded-3 overflow-hidden">
                                            <a href="?action=manageSlots&id=${field.fieldID}" 
                                               class="btn btn-white btn-sm border-end" 
                                               title="Quản lý khung giờ">
                                                <i class="fas fa-clock text-info"></i>
                                            </a>
                                            <a href="?action=edit&id=${field.fieldID}" 
                                               class="btn btn-white btn-sm border-end" 
                                               title="Chỉnh sửa">
                                                <i class="fas fa-edit text-primary"></i>
                                            </a>
                                            <button class="btn btn-white btn-sm border-end" 
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#hideModal${field.fieldID}"
                                                    title="Ẩn/Hiện">
                                                <i class="fas fa-eye-slash text-warning"></i>
                                            </button>
                                            <button class="btn btn-white btn-sm" 
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#deleteModal${field.fieldID}"
                                                    title="Xóa">
                                                <i class="fas fa-trash text-danger"></i>
                                            </button>
                                        </div>

                                        <!-- Hide Modal -->
                                        <div class="modal fade" id="hideModal${field.fieldID}" tabindex="-1">
                                            <div class="modal-dialog modal-dialog-centered">
                                                <div class="modal-content border-0 shadow-lg">
                                                    <div class="modal-header bg-warning-subtle">
                                                        <h5 class="modal-title">
                                                            <i class="fas fa-eye-slash me-2"></i>Thay đổi trạng thái
                                                        </h5>
                                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                    </div>
                                                    <div class="modal-body">
                                                        <p>Chọn trạng thái mới cho sân: <strong>${field.fieldName}</strong></p>
                                                        <form method="post" action="${pageContext.request.contextPath}/admin/fields">
                                                            <input type="hidden" name="action" value="hide">
                                                            <input type="hidden" name="id" value="${field.fieldID}">
                                                            <select name="newStatus" class="form-select mb-3" required>
                                                                <option value="ACTIVE" ${field.status == 'ACTIVE' ? 'selected' : ''}>Hoạt động</option>
                                                                <option value="MAINTENANCE" ${field.status == 'MAINTENANCE' ? 'selected' : ''}>Bảo trì</option>
                                                                <option value="HIDDEN" ${field.status == 'HIDDEN' ? 'selected' : ''}>Ẩn</option>
                                                            </select>
                                                            <div class="d-flex gap-2 justify-content-end">
                                                                <button type="button" class="btn btn-light" data-bs-dismiss="modal">Hủy</button>
                                                                <button type="submit" class="btn btn-warning">Cập nhật</button>
                                                            </div>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Delete Modal -->
                                        <div class="modal fade" id="deleteModal${field.fieldID}" tabindex="-1">
                                            <div class="modal-dialog modal-dialog-centered">
                                                <div class="modal-content border-0 shadow-lg confirm-delete-modal">
                                                    <div class="confirm-delete-modal-header d-flex justify-content-between align-items-start">
                                                        <div class="d-flex align-items-center">
                                                            <i class="fas fa-exclamation-triangle me-2"></i>
                                                            <div>
                                                                <h5 class="modal-title mb-0">Xác nhận xóa sân</h5>
                                                                <small>Hành động này không thể hoàn tác.</small>
                                                            </div>
                                                        </div>
                                                        <button type="button" class="btn-close btn-close-white ms-2" data-bs-dismiss="modal"></button>
                                                    </div>
                                                    <div class="confirm-delete-modal-body">
                                                        <p class="mb-3">Bạn có chắc chắn muốn xóa sân: <strong>${field.fieldName}</strong>?</p>
                                                        <p class="text-muted small mb-0">Tất cả khung giờ của sân này cũng sẽ bị xóa.</p>
                                                    </div>
                                                    <div class="modal-footer confirm-delete-modal-footer">
                                                        <button type="button" class="btn btn-light border" data-bs-dismiss="modal">
                                                            <i class="fas fa-times me-1"></i>Hủy
                                                        </button>
                                                        <form method="post" action="${pageContext.request.contextPath}/admin/fields" class="d-inline">
                                                            <input type="hidden" name="action" value="delete">
                                                            <input type="hidden" name="id" value="${field.fieldID}">
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

                            <c:if test="${empty fields}">
                                <tr>
                                    <td colspan="6" class="text-center py-4 text-muted">
                                        <i class="fas fa-inbox fa-3x mb-3"></i>
                                        <p>Chưa có sân nào</p>
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
