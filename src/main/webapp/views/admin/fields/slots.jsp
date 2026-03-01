<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Khung Giờ - ${field.fieldName}</title>
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
                            <li class="breadcrumb-item active text-primary fw-medium">Khung giờ</li>
                        </ol>
                    </nav>
                    <h2 class="page-title text-uppercase mb-0">
                        <i class="fas fa-clock"></i>
                        Quản lý khung giờ - ${field.fieldName}
                    </h2>
                    <p class="page-subtitle">Thiết lập giá và thời gian cho từng khung giờ trong ngày</p>
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
                    <div class="col-lg-8">
                        <div class="card border-0 shadow-sm rounded-4 mb-4">
                            <div class="card-header bg-white border-0 p-4">
                                <div class="d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0">
                                        <i class="fas fa-list me-2"></i>Danh sách khung giờ
                                    </h5>
                                    <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#addSlotModal">
                                        <i class="fas fa-plus me-1"></i>Thêm khung giờ
                                    </button>
                                </div>
                            </div>
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-hover align-middle mb-0">
                                        <thead class="bg-light">
                                            <tr>
                                                <th class="ps-4">Thời gian</th>
                                                <th>Giá thuê</th>
                                                <th>Trạng thái</th>
                                                <th class="text-end pe-4">Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="slot" items="${slots}">
                                                <tr>
                                                    <td class="ps-4">
                                                        <i class="far fa-clock me-2 text-primary"></i>
                                                        <strong>${slot.startTime}</strong> - <strong>${slot.endTime}</strong>
                                                    </td>
                                                    <td class="fw-bold text-success">
                                                        <fmt:formatNumber value="${slot.price}" pattern="#,###"/>đ
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${slot.status == 'ACTIVE'}">
                                                                <span class="badge bg-success-subtle text-success">
                                                                    <i class="fas fa-check-circle me-1"></i>Hoạt động
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge bg-secondary-subtle text-secondary">
                                                                    <i class="fas fa-ban me-1"></i>Không hoạt động
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="text-end pe-4">
                                                        <div class="btn-group shadow-sm rounded-3 overflow-hidden">
                                                            <button class="btn btn-white btn-sm border-end" 
                                                                    data-bs-toggle="modal" 
                                                                    data-bs-target="#editSlotModal${slot.slotID}"
                                                                    title="Chỉnh sửa">
                                                                <i class="fas fa-edit text-primary"></i>
                                                            </button>
                                                            <button class="btn btn-white btn-sm" 
                                                                    data-bs-toggle="modal" 
                                                                    data-bs-target="#deleteSlotModal${slot.slotID}"
                                                                    title="Xóa">
                                                                <i class="fas fa-trash text-danger"></i>
                                                            </button>
                                                        </div>

                                                        <!-- Edit Slot Modal -->
                                                        <div class="modal fade" id="editSlotModal${slot.slotID}" tabindex="-1">
                                                            <div class="modal-dialog modal-dialog-centered">
                                                                <div class="modal-content border-0 shadow-lg">
                                                                    <div class="modal-header bg-primary-subtle">
                                                                        <h5 class="modal-title">
                                                                            <i class="fas fa-edit me-2"></i>Chỉnh sửa khung giờ
                                                                        </h5>
                                                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                                    </div>
                                                                    <form method="post" action="${pageContext.request.contextPath}/admin/fields">
                                                                        <div class="modal-body">
                                                                            <input type="hidden" name="action" value="updateSlot">
                                                                            <input type="hidden" name="slotID" value="${slot.slotID}">
                                                                            <input type="hidden" name="fieldID" value="${field.fieldID}">

                                                                            <div class="mb-3">
                                                                                <label class="form-label fw-semibold">Giờ bắt đầu</label>
                                                                                <input type="time" class="form-control" name="startTime" value="${slot.startTime}" required>
                                                                            </div>

                                                                            <div class="mb-3">
                                                                                <label class="form-label fw-semibold">Giờ kết thúc</label>
                                                                                <input type="time" class="form-control" name="endTime" value="${slot.endTime}" required>
                                                                            </div>

                                                                            <div class="mb-3">
                                                                                <label class="form-label fw-semibold">Giá thuê (VNĐ)</label>
                                                                                <input type="number" class="form-control" name="price" value="${slot.price}" min="0" step="1000" required>
                                                                            </div>

                                                                            <div class="mb-3">
                                                                                <label class="form-label fw-semibold">Trạng thái</label>
                                                                                <select class="form-select" name="status" required>
                                                                                    <option value="ACTIVE" ${slot.status == 'ACTIVE' ? 'selected' : ''}>Hoạt động</option>
                                                                                    <option value="INACTIVE" ${slot.status == 'INACTIVE' ? 'selected' : ''}>Không hoạt động</option>
                                                                                </select>
                                                                            </div>
                                                                        </div>
                                                                        <div class="modal-footer">
                                                                            <button type="button" class="btn btn-light" data-bs-dismiss="modal">Hủy</button>
                                                                            <button type="submit" class="btn btn-primary">
                                                                                <i class="fas fa-save me-1"></i>Cập nhật
                                                                            </button>
                                                                        </div>
                                                                    </form>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <!-- Delete Slot Modal -->
                                                        <div class="modal fade" id="deleteSlotModal${slot.slotID}" tabindex="-1">
                                                            <div class="modal-dialog modal-dialog-centered">
                                                                <div class="modal-content border-0 shadow-lg">
                                                                    <div class="modal-header bg-danger text-white">
                                                                        <h5 class="modal-title">
                                                                            <i class="fas fa-exclamation-triangle me-2"></i>Xác nhận xóa
                                                                        </h5>
                                                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                                                    </div>
                                                                    <div class="modal-body">
                                                                        <p>Bạn có chắc chắn muốn xóa khung giờ: <strong>${slot.startTime} - ${slot.endTime}</strong>?</p>
                                                                    </div>
                                                                    <div class="modal-footer">
                                                                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Hủy</button>
                                                                        <form method="post" action="${pageContext.request.contextPath}/admin/fields" class="d-inline">
                                                                            <input type="hidden" name="action" value="deleteSlot">
                                                                            <input type="hidden" name="slotID" value="${slot.slotID}">
                                                                            <input type="hidden" name="fieldID" value="${field.fieldID}">
                                                                            <button type="submit" class="btn btn-danger">
                                                                                <i class="fas fa-trash me-1"></i>Xóa
                                                                            </button>
                                                                        </form>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>

                                            <c:if test="${empty slots}">
                                                <tr>
                                                    <td colspan="4" class="text-center py-4 text-muted">
                                                        <i class="fas fa-clock fa-3x mb-3"></i>
                                                        <p>Chưa có khung giờ nào. Nhấn "Thêm khung giờ" để bắt đầu.</p>
                                                    </td>
                                                </tr>
                                            </c:if>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <a href="${pageContext.request.contextPath}/admin/fields" class="btn btn-light border">
                            <i class="fas fa-arrow-left me-1"></i>Quay lại danh sách sân
                        </a>
                    </div>

                    <div class="col-lg-4">
                        <div class="card border-0 shadow-sm rounded-4 mb-3">
                            <div class="card-body p-4">
                                <h5 class="card-title mb-3">
                                    <i class="fas fa-info-circle me-2"></i>Thông tin sân
                                </h5>
                                <div class="mb-2">
                                    <strong>Tên sân:</strong> ${field.fieldName}
                                </div>
                                <div class="mb-2">
                                    <strong>Loại:</strong> Sân ${field.fieldType}
                                </div>
                                <div class="mb-2">
                                    <strong>Giá mặc định:</strong> 
                                    <span class="text-success fw-bold">
                                        <fmt:formatNumber value="${field.pricePerHour}" pattern="#,###"/>đ/giờ
                                    </span>
                                </div>
                            </div>
                        </div>

                        <div class="card border-0 shadow-sm rounded-4 bg-warning-subtle">
                            <div class="card-body p-4">
                                <h5 class="card-title mb-3">
                                    <i class="fas fa-lightbulb me-2"></i>Gợi ý
                                </h5>
                                <ul class="small mb-0">
                                    <li class="mb-2">Khung giờ vàng (17h-21h): Giá cao hơn</li>
                                    <li class="mb-2">Khung giờ sáng (6h-12h): Giá ưu đãi</li>
                                    <li class="mb-2">Mỗi slot nên kéo dài 1-2 giờ</li>
                                    <li>Tránh để slot trùng thời gian</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <!-- Add Slot Modal -->
    <div class="modal fade" id="addSlotModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg">
                <div class="modal-header bg-success-subtle">
                    <h5 class="modal-title">
                        <i class="fas fa-plus me-2"></i>Thêm khung giờ mới
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form method="post" action="${pageContext.request.contextPath}/admin/fields">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="addSlot">
                        <input type="hidden" name="fieldID" value="${field.fieldID}">

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Giờ bắt đầu <span class="text-danger">*</span></label>
                            <input type="time" class="form-control" name="startTime" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Giờ kết thúc <span class="text-danger">*</span></label>
                            <input type="time" class="form-control" name="endTime" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Giá thuê (VNĐ) <span class="text-danger">*</span></label>
                            <input type="number" class="form-control" name="price" value="${field.pricePerHour}" min="0" step="1000" required>
                            <small class="text-muted">Giá mặc định: <fmt:formatNumber value="${field.pricePerHour}" pattern="#,###"/>đ</small>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Trạng thái <span class="text-danger">*</span></label>
                            <select class="form-select" name="status" required>
                                <option value="ACTIVE" selected>Hoạt động</option>
                                <option value="INACTIVE">Không hoạt động</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-plus me-1"></i>Thêm khung giờ
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
