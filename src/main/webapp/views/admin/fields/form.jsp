<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty field ? 'Thêm' : 'Sửa'} Sân Bóng - Admin</title>
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

                <div class="page-header">
                    <nav aria-label="breadcrumb" class="mb-2">
                        <ol class="breadcrumb small mb-0">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard" class="text-decoration-none text-muted">Hệ thống</a></li>
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/fields" class="text-decoration-none text-muted">Quản lý sân</a></li>
                            <li class="breadcrumb-item active text-primary fw-medium">${empty field ? 'Thêm mới' : 'Chỉnh sửa'}</li>
                        </ol>
                    </nav>
                    <h2 class="page-title text-uppercase mb-0">
                        <i class="fas ${empty field ? 'fa-plus' : 'fa-edit'}"></i>
                        ${empty field ? 'Thêm sân mới' : 'Chỉnh sửa sân'}
                    </h2>
                </div>

                <div class="row">
                    <div class="col-lg-8">
                        <div class="card border-0 shadow-sm rounded-4">
                            <div class="card-body p-4">
                                <form method="post" action="${pageContext.request.contextPath}/admin/fields">
                                    <input type="hidden" name="action" value="${empty field ? 'insert' : 'update'}">
                                    <c:if test="${not empty field}">
                                        <input type="hidden" name="fieldID" value="${field.fieldID}">
                                    </c:if>

                                    <div class="mb-3">
                                        <label for="fieldName" class="form-label fw-semibold">
                                            Tên sân <span class="text-danger">*</span>
                                        </label>
                                        <input type="text" class="form-control" id="fieldName" name="fieldName" 
                                               value="${field.fieldName}" required>
                                    </div>

                                    <div class="mb-3">
                                        <label for="fieldType" class="form-label fw-semibold">
                                            Loại sân <span class="text-danger">*</span>
                                        </label>
                                        <select class="form-select" id="fieldType" name="fieldType" required>
                                            <option value="">-- Chọn loại sân --</option>
                                            <option value="5" ${field.fieldType == 5 ? 'selected' : ''}>Sân 5 người</option>
                                            <option value="7" ${field.fieldType == 7 ? 'selected' : ''}>Sân 7 người</option>
                                            <option value="11" ${field.fieldType == 11 ? 'selected' : ''}>Sân 11 người</option>
                                        </select>
                                    </div>

                                    <div class="mb-3">
                                        <label for="pricePerHour" class="form-label fw-semibold">
                                            Giá thuê/giờ (VNĐ) <span class="text-danger">*</span>
                                        </label>
                                        <input type="number" class="form-control" id="pricePerHour" name="pricePerHour" 
                                               value="${field.pricePerHour}" min="0" step="1000" required>
                                        <small class="text-muted">Giá mặc định cho sân, có thể tùy chỉnh theo từng khung giờ</small>
                                    </div>

                                    <div class="mb-3">
                                        <label for="imageURL" class="form-label fw-semibold">
                                            URL hình ảnh
                                        </label>
                                        <input type="url" class="form-control" id="imageURL" name="imageURL" 
                                               value="${field.imageURL}" placeholder="https://example.com/image.jpg">
                                        <small class="text-muted">Link ảnh sân bóng</small>
                                    </div>

                                    <div class="mb-4">
                                        <label for="status" class="form-label fw-semibold">
                                            Trạng thái <span class="text-danger">*</span>
                                        </label>
                                        <select class="form-select" id="status" name="status" required>
                                            <option value="ACTIVE" ${field.status == 'ACTIVE' || empty field ? 'selected' : ''}>Hoạt động</option>
                                            <option value="MAINTENANCE" ${field.status == 'MAINTENANCE' ? 'selected' : ''}>Bảo trì</option>
                                            <option value="HIDDEN" ${field.status == 'HIDDEN' ? 'selected' : ''}>Ẩn</option>
                                        </select>
                                    </div>

                                    <div class="d-flex gap-2">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save me-1"></i>
                                            ${empty field ? 'Thêm sân' : 'Cập nhật'}
                                        </button>
                                        <a href="${pageContext.request.contextPath}/admin/fields" class="btn btn-light border">
                                            <i class="fas fa-times me-1"></i>Hủy
                                        </a>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-4">
                        <div class="card border-0 shadow-sm rounded-4 bg-info-subtle">
                            <div class="card-body p-4">
                                <h5 class="card-title mb-3">
                                    <i class="fas fa-info-circle me-2"></i>Hướng dẫn
                                </h5>
                                <ul class="small mb-0">
                                    <li class="mb-2">Điền đầy đủ thông tin sân bóng</li>
                                    <li class="mb-2">Giá thuê/giờ là giá mặc định, bạn có thể tùy chỉnh giá cho từng khung giờ sau</li>
                                    <li class="mb-2">Sau khi tạo sân, vào "Quản lý khung giờ" để thêm các slot thời gian</li>
                                    <li>Trạng thái "Ẩn" sẽ không hiển thị sân cho khách hàng</li>
                                </ul>
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
