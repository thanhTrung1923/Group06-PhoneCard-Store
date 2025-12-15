<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết sản phẩm: ${p.typeName}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .detail-header { background: #fff; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
        .card-list-table th { background-color: #e9ecef; }
    </style>
</head>
<body>

    <nav class="navbar navbar-dark bg-primary mb-4">
        <div class="container-fluid">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/inventory">
                <i class="fa-solid fa-arrow-left me-2"></i> Quay lại Danh sách
            </a>
            <span class="navbar-text text-white fw-bold">PRODUCT DETAILS</span>
        </div>
    </nav>

    <div class="container">
        
        <div class="row g-4 mb-4">
            <div class="col-md-6">
                <div class="p-4 detail-header h-100">
                    <h4 class="text-primary fw-bold mb-3">${p.typeName} - <fmt:formatNumber value="${p.value}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></h4>
                    <table class="table table-borderless">
                        <tr>
                            <td class="text-muted" width="150">Product ID:</td>
                            <td class="fw-bold">#${p.productId}</td>
                        </tr>
                        <tr>
                            <td class="text-muted">Min Stock Alert:</td>
                            <td class="fw-bold text-danger">${p.minStockAlert} cards</td>
                        </tr>
                        <tr>
                            <td class="text-muted">Last Import:</td>
                            <td>${p.lastImportDate}</td>
                        </tr>
                        <tr>
                            <td class="text-muted">Last Sold:</td>
                            <td>${p.lastSoldDate != null ? p.lastSoldDate : 'Chưa có giao dịch'}</td>
                        </tr>
                    </table>
                </div>
            </div>

            <div class="col-md-6">
                <div class="p-4 detail-header h-100 border-start border-5 border-primary">
                    <h5 class="fw-bold mb-3"><i class="fa-solid fa-boxes-stacked me-2"></i> Stock Status</h5>
                    <div class="row text-center g-3">
                        <div class="col-4">
                            <div class="p-3 bg-success bg-opacity-10 rounded">
                                <div class="text-success small fw-bold">IN STOCK</div>
                                <div class="h3 mb-0 fw-bold">${p.quantity}</div>
                            </div>
                        </div>
                        <div class="col-4">
                            <div class="p-3 bg-warning bg-opacity-10 rounded">
                                <div class="text-warning small fw-bold">RESERVED</div>
                                <div class="h3 mb-0 fw-bold">${p.reservedCount}</div>
                            </div>
                        </div>
                        <div class="col-4">
                            <div class="p-3 bg-secondary bg-opacity-10 rounded">
                                <div class="text-secondary small fw-bold">SOLD</div>
                                <div class="h3 mb-0 fw-bold">${p.soldCount}</div>
                            </div>
                        </div>
                    </div>
                    
                    <c:if test="${p.quantity <= p.minStockAlert}">
                        <div class="alert alert-danger mt-3 mb-0">
                            <i class="fa-solid fa-triangle-exclamation me-2"></i>
                            <strong>Cảnh báo:</strong> Tồn kho dưới mức tối thiểu (${p.minStockAlert} thẻ).
                            <a href="#" class="alert-link">Nhập thêm ngay!</a>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <div class="card shadow-sm mt-4">
            
            <form id="bulkForm" action="${pageContext.request.contextPath}/admin/inventory/detail" method="POST">
                <input type="hidden" name="currentProductId" value="${p.productId}">
                <input type="hidden" name="bulkAction" id="bulkActionInput">
                
                <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                    <h5 class="mb-0 fw-bold"><i class="fa-solid fa-list me-2"></i> Danh sách thẻ</h5>
                    
                    <div class="d-flex align-items-center">
                        <div class="input-group">
                            <span class="input-group-text bg-light fw-bold">Đã chọn: <span id="selectedCount" class="ms-1 text-primary">0</span></span>
                            
                            <button type="button" class="btn btn-outline-secondary dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="fa-solid me-1"></i> Hành động
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li><h6 class="dropdown-header">Thay đổi trạng thái</h6></li>
                                <li><a class="dropdown-item" href="#" onclick="submitBulk('change_status', 'IN_STOCK')">Set IN_STOCK</a></li>
                                <li><a class="dropdown-item" href="#" onclick="submitBulk('change_status', 'SOLD')">Set SOLD</a></li>
                                <li><a class="dropdown-item" href="#" onclick="submitBulk('change_status', 'RESERVED')">Set RESERVED</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-warning" href="#" onclick="submitBulk('mark_defective')">Mark as Defective</a></li>
                                <li><a class="dropdown-item text-info" href="#" data-bs-toggle="modal" data-bs-target="#moveModal">Move to Product...</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger" href="#" onclick="confirmDelete()">Delete Selected</a></li>
                            </ul>
                        </div>
                    </div>
                </div>

                <div class="card-body p-0">
                    <table class="table table-hover table-striped mb-0 align-middle">
                        <thead class="table-light">
                            <tr>
                                <th width="40" class="text-center">
                                    <input type="checkbox" class="form-check-input" id="selectAll">
                                </th>
                                <th>#</th>
                                <th>Serial Number</th>
                                <th>Code</th>
                                <th>Ngày nhập</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="c" items="${cards}" varStatus="status">
                                <tr>
                                    <td class="text-center">
                                        <input type="checkbox" class="form-check-input item-check" name="selectedCards" value="${c.cardId}">
                                    </td>
                                    <td>${status.index + 1}</td>
                                    <td class="fw-bold font-monospace text-primary">${c.serial}</td>
                                    <td class="font-monospace text-muted">
                                        <c:choose>
                                            <c:when test="${c.status == 'SOLD'}">*** (Sold)</c:when>
                                            <c:otherwise>${c.code}</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${c.createdAt}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${c.status == 'IN_STOCK'}"><span class="badge bg-success">Sẵn sàng</span></c:when>
                                            <c:when test="${c.status == 'SOLD'}"><span class="badge bg-secondary">Đã bán</span></c:when>
                                            <c:when test="${c.status == 'RESERVED'}"><span class="badge bg-warning text-dark">Đang giữ</span></c:when>
                                            <c:when test="${c.status == 'DEFECTIVE'}"><span class="badge bg-danger">Lỗi</span></c:when>
                                            <c:otherwise><span class="badge bg-dark">${c.status}</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty cards}">
                                <tr><td colspan="6" class="text-center py-4 text-muted">Chưa có thẻ nào.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
                
                <input type="hidden" name="targetStatus" id="targetStatusInput">
                
                <div class="modal fade" id="moveModal" tabindex="-1">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Di chuyển sang sản phẩm khác</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <label class="form-label">Chọn sản phẩm đích:</label>
                                <select class="form-select" name="targetProductId">
                                    <c:forEach var="prod" items="${allProducts}">
                                        <c:if test="${prod.productId != p.productId}">
                                            <option value="${prod.productId}">${prod.typeName} - ${prod.value}</option>
                                        </c:if>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                <button type="button" class="btn btn-primary" onclick="submitBulk('move_product')">Di chuyển</button>
                            </div>
                        </div>
                    </div>
                </div>

            </form>
        </div>

    <script>
        // 1. Xử lý Select All
        document.getElementById('selectAll').addEventListener('change', function() {
            var checkboxes = document.querySelectorAll('.item-check');
            for (var checkbox of checkboxes) {
                checkbox.checked = this.checked;
            }
            updateCount();
        });

        // 2. Cập nhật số lượng đã chọn
        var checkboxes = document.querySelectorAll('.item-check');
        for (var checkbox of checkboxes) {
            checkbox.addEventListener('change', updateCount);
        }

        function updateCount() {
            var checkedCount = document.querySelectorAll('.item-check:checked').length;
            document.getElementById('selectedCount').innerText = checkedCount;
        }

        // 3. Xử lý Submit Form
        function submitBulk(action, status = null) {
            var checkedCount = document.querySelectorAll('.item-check:checked').length;
            if (checkedCount === 0) {
                alert("Vui lòng chọn ít nhất một thẻ!");
                return;
            }

            document.getElementById('bulkActionInput').value = action;
            if (status) {
                document.getElementById('targetStatusInput').value = status;
            }
            
            document.getElementById('bulkForm').submit();
        }

        function confirmDelete() {
            var checkedCount = document.querySelectorAll('.item-check:checked').length;
            if (checkedCount === 0) {
                alert("Vui lòng chọn ít nhất một thẻ!");
                return;
            }
            if (confirm("Bạn có chắc chắn muốn xóa vĩnh viễn " + checkedCount + " thẻ đã chọn?")) {
                submitBulk('delete');
            }
        }
    </script>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>