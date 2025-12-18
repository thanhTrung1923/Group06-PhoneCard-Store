<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Kho thẻ - Admin</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <style>
        /* 1. CSS CHO LAYOUT (QUAN TRỌNG) */
        .main-content {
            margin-left: 260px; /* Đẩy nội dung sang phải để nhường chỗ cho Sidebar */
            padding: 1.5rem;
            min-height: 100vh;
            background-color: #f8f9fa;
        }

        /* Các CSS cũ của trang Inventory giữ nguyên ở đây */
        .stats-card { transition: all 0.3s; border: none; border-radius: 10px; }
        .stats-card:hover { transform: translateY(-5px); box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
        .table-hover tbody tr:hover { background-color: #f1f1f1; }
        
        body { background-color: #f8f9fa; }
        .stats-card { transition: all 0.3s; border: none; border-radius: 10px; }
        .stats-card:hover { transform: translateY(-5px); box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
        .table-hover tbody tr:hover { background-color: #f1f1f1; }
        .status-badge { font-size: 0.85em; padding: 5px 10px; border-radius: 20px; }
        .filter-bar { background: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
        .action-btn-group .btn { margin-left: 5px; }
    </style>
</head>
<body>
    <jsp:include page="components/admin-sidebar.jsp"></jsp:include>

    <div class="main-content">
        
        <nav class="navbar navbar-light bg-white shadow-sm rounded mb-4 px-3">
            <span class="navbar-brand mb-0 h1"><i class="fa-solid fa-list me-2"></i> DANH SÁCH TỒN KHO</span>
            <div class="d-flex align-items-center">
                <span class="me-2 text-secondary">Hi, Admin</span>
                <i class="fa-solid fa-circle-user fa-2x text-primary"></i>
            </div>
        </nav>

    <div class="container-fluid px-4">
        
        <div class="row g-3 mb-4">
            <div class="col-md-3">
                <div class="card stats-card bg-primary text-white h-100">
                    <div class="card-body">
                        <h6 class="card-title text-white-50">TỒN KHO</h6>
                        <h2 class="fw-bold">${stats.totalInStock}</h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card bg-success text-white h-100">
                    <div class="card-body">
                        <h6 class="card-title text-white-50">ĐÃ BÁN</h6>
                        <h2 class="fw-bold">${stats.totalSold}</h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card bg-warning text-dark h-100">
                    <div class="card-body">
                        <h6 class="card-title text-black-50">SẮP HẾT</h6>
                        <h2 class="fw-bold">${stats.totalLowStock}</h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card bg-danger text-white h-100">
                    <div class="card-body">
                        <h6 class="card-title text-white-50">HẾT HÀNG</h6>
                        <h2 class="fw-bold">${stats.totalOutStock}</h2>
                    </div>
                </div>
            </div>
        </div>

        <div class="filter-bar mb-4">
            <form action="${pageContext.request.contextPath}/admin/inventory" method="GET">
                <div class="row g-3 align-items-end">
                    
                    <div class="col-md-3">
                        <label class="form-label fw-bold">Tìm kiếm (Search)</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="fa-solid fa-magnifying-glass"></i></span>
                            <input type="text" class="form-control" name="keyword" value="${filterKeyword}" 
                                   placeholder="Nhập tên sản phẩm hoặc mã sản phẩm...">
                        </div>
                    </div>

                    <div class="col-md-2">
                        <label class="form-label fw-bold">Loại thẻ</label>
                        <select class="form-select" name="type">
                            <option value="">Tất cả</option>
                            <option value="Viettel" ${filterType == 'Viettel' ? 'selected' : ''}>Viettel</option>
                            <option value="Vinaphone" ${filterType == 'Vinaphone' ? 'selected' : ''}>Vinaphone</option>
                            <option value="Mobifone" ${filterType == 'Mobifone' ? 'selected' : ''}>Mobifone</option>
                        </select>
                    </div>

                    <div class="col-md-2">
                        <label class="form-label fw-bold">Trạng thái</label>
                        <select class="form-select" name="status">
                            <option value="">Tất cả</option>
                            <option value="OK" ${filterStatus == 'OK' ? 'selected' : ''}>Sẵn sàng (Active)</option>
                            <option value="LOW" ${filterStatus == 'LOW' ? 'selected' : ''}>Sắp hết</option>
                            <option value="OUT" ${filterStatus == 'OUT' ? 'selected' : ''}>Hết hàng (Inactive)</option>
                        </select>
                    </div>

                    <div class="col-md-2 d-flex">
                        <button class="btn btn-primary flex-grow-1 me-2" type="submit">
                            <i class="fa-solid fa-filter"></i> Lọc
                        </button>
                        
                        <a href="${pageContext.request.contextPath}/admin/inventory" class="btn btn-outline-secondary" title="Xóa bộ lọc (Reset)">
                            <i class="fa-solid fa-rotate-left"></i>
                        </a>
                    </div>

                    <div class="col-md-2 text-end action-btn-group">
                        <a href="${pageContext.request.contextPath}/admin/inventory/create" class="btn btn-warning">
                            <i class="fa-solid fa-plus me-1"></i> Thêm Mới
                        </a>
                        <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#importModal">
                            <i class="fa-solid fa-file-excel me-1"></i> Import Excel
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <div class="card shadow-sm">
            <div class="card-header bg-white py-3">
                <h5 class="mb-0 text-primary fw-bold"><i class="fa-solid fa-list me-2"></i> Danh sách quản lý</h5>
            </div>
            <div class="card-body p-0">
                <table class="table table-hover table-bordered mb-0 align-middle">
                    <thead class="table-light">
                        <tr>
                            <th class="text-center" width="5%">ID</th>
                            <th width="30%">Sản phẩm (Product)</th>
                            <th width="15%">Mệnh giá</th>
                            <th class="text-center" width="10%">Tồn kho</th>
                            <th class="text-center" width="10%">Đã bán</th>
                            <th class="text-center" width="15%">Trạng thái</th>
                            <th class="text-center" width="15%">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="p" items="${inventoryList}">
                            <tr>
                                <td class="text-center">${p.productId}</td>
                                
                                <td>
                                    <div class="fw-bold text-primary">${p.typeName}</div>
                                    </td>
                                
                                <td><fmt:formatNumber value="${p.value}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></td>
                                
                                <td class="text-center fw-bold">${p.quantity}</td>
                                <td class="text-center text-muted">${p.soldCount}</td>
                                
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${p.quantity == 0}">
                                            <span class="badge bg-danger status-badge">Hết hàng</span>
                                        </c:when>
                                        <c:when test="${p.quantity <= p.minStockAlert}">
                                            <span class="badge bg-warning text-dark status-badge">Sắp hết</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-success status-badge">Sẵn sàng</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                
                                <td class="text-center">
    <a href="${pageContext.request.contextPath}/admin/inventory/detail?id=${p.productId}" 
       class="btn btn-sm btn-outline-info fw-bold">
        <i class="fa-solid fa-circle-info me-1"></i> Chi tiết
    </a>
</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty inventoryList}">
                            <tr><td colspan="7" class="text-center py-4 text-muted">Không tìm thấy dữ liệu phù hợp.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
            <div class="card-footer bg-white">
                <div class="card-footer bg-white">
                <c:if test="${totalPages > 0}">
                    <nav aria-label="Page navigation">
                        <ul class="pagination justify-content-end mb-0">
                            
                            <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage - 1}&keyword=${filterKeyword}&type=${filterType}&status=${filterStatus}">Trước</a>
                            </li>
                            
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="?page=${i}&keyword=${filterKeyword}&type=${filterType}&status=${filterStatus}">${i}</a>
                                </li>
                            </c:forEach>
                            
                            <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage + 1}&keyword=${filterKeyword}&type=${filterType}&status=${filterStatus}">Sau</a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
            </div>
            </div>
        </div>

    </div>

    <div class="modal fade" id="importModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title"><i class="fa-solid fa-upload me-2"></i> Nhập Kho Từ File Excel</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/admin/import" method="post" enctype="multipart/form-data">
                    <div class="modal-body">
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold">Nhập thẻ cho Sản phẩm:</label>
                            <select class="form-select" name="target_product_id" required>
                                <option value="" disabled selected>-- Chọn loại thẻ muốn nhập --</option>
                                <c:forEach var="p" items="${listProductsForImport}">
                                    <option value="${p.productId}">
                                        ${p.typeName} - <fmt:formatNumber value="${p.value}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="alert alert-info border-info bg-light">
                            <h6 class="alert-heading fw-bold"><i class="fa-solid fa-circle-info text-primary"></i> Hướng dẫn file Excel:</h6>
                            <ul class="mb-1 small ps-3">
                                <li>File cần có dòng tiêu đề (Header).</li>
                                <li>Hệ thống tự động tìm cột có tên: <b>Serial</b> (hoặc Seri) và <b>Code</b> (hoặc Mã thẻ).</li>
                                <li>Thứ tự cột không quan trọng, các cột thừa sẽ bị bỏ qua.</li>
                            </ul>
                            
                            <table class="table table-bordered table-sm bg-white mb-2 small text-center">
                                <thead class="table-secondary">
                                    <tr>
                                        <th class="text-muted fst-italic">Ngày nhập...</th>
                                        <th>Serial <span class="text-danger">*</span></th>
                                        <th class="text-muted fst-italic">Ghi chú...</th>
                                        <th>Mã thẻ <span class="text-danger">*</span></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="text-muted">...</td>
                                        <td>SERI-001</td>
                                        <td class="text-muted">...</td>
                                        <td>123456</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">File dữ liệu (.xlsx)</label>
                            <input type="file" class="form-control" name="file_excel" accept=".xlsx, .xls" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-success">Tiến hành Import</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 11">
        <c:if test="${not empty message}">
            <div class="toast show align-items-center text-white bg-success border-0" role="alert">
                <div class="d-flex"><div class="toast-body"><i class="fa-solid fa-circle-check me-2"></i> ${message}</div><button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button></div>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="toast show align-items-center text-white bg-danger border-0" role="alert">
                <div class="d-flex"><div class="toast-body"><i class="fa-solid fa-triangle-exclamation me-2"></i> ${error}</div><button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button></div>
            </div>
        </c:if>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            var toastElList = [].slice.call(document.querySelectorAll('.toast'))
            var toastList = toastElList.map(function(toastEl) { return new bootstrap.Toast(toastEl, { delay: 3000 }); });
            toastList.forEach(toast => toast.show());
        });
    </script>
</body>
</html>