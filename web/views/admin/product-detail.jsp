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

    <nav class="navbar navbar-dark bg-primary mb-3 shadow-sm">
        <div class="container-fluid">
            <span class="navbar-brand mb-0 h1"><i class="fa-solid fa-boxes-stacked me-2"></i> INVENTORY SYSTEM</span>
        </div>
    </nav>

    <div class="container pb-5">
        
        <div class="mb-3">
            <a href="${pageContext.request.contextPath}/admin/inventory" class="btn btn-primary btn-sm">
                <i class="fa-solid fa-arrow-left me-1"></i> Quay lại Danh sách
            </a>
        </div>

        <div class="row g-4 mb-4">
            <div class="col-md-6">
                <div class="p-4 detail-header h-100">
                    <h4 class="text-primary fw-bold mb-3">${p.typeName} - <fmt:formatNumber value="${p.value}" type="currency" currencySymbol="đ" maxFractionDigits="0"/></h4>
                    <table class="table table-borderless">
                        <tr><td class="text-muted" width="150">Product ID:</td><td class="fw-bold">#${p.productId}</td></tr>
                        <tr><td class="text-muted">Min Stock Alert:</td><td class="fw-bold text-danger">${p.minStockAlert} cards</td></tr>
                        <tr><td class="text-muted">Last Import:</td><td>${p.lastImportDate}</td></tr>
                        <tr><td class="text-muted">Last Sold:</td><td>${p.lastSoldDate != null ? p.lastSoldDate : 'Chưa có giao dịch'}</td></tr>
                    </table>
                </div>
            </div>
            <div class="col-md-6">
                <div class="p-4 detail-header h-100 border-start border-5 border-primary">
                    <h5 class="fw-bold mb-3"><i class="fa-solid fa-chart-pie me-2"></i> Stock Status</h5>
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
                </div>
            </div>
        </div>

        <div class="card shadow-sm">
            
            <div class="card-header bg-white py-3">
                <div class="row align-items-center">
                    <div class="col-md-4">
                        <h5 class="mb-0 fw-bold"><i class="fa-solid fa-list me-2"></i> Danh sách thẻ</h5>
                    </div>
                    
                    <div class="col-md-8">
                        <form action="" method="GET" class="row g-2 justify-content-end">
                            <input type="hidden" name="id" value="${p.productId}">
                            
                            <div class="col-auto">
                                <select class="form-select form-select-sm" name="status">
                                    <option value="">-- Tất cả trạng thái --</option>
                                    <option value="IN_STOCK" ${filterStatus == 'IN_STOCK' ? 'selected' : ''}>Sẵn sàng (IN_STOCK)</option>
                                    <option value="SOLD" ${filterStatus == 'SOLD' ? 'selected' : ''}>Đã bán (SOLD)</option>
                                    <option value="RESERVED" ${filterStatus == 'RESERVED' ? 'selected' : ''}>Đang giữ (RESERVED)</option>
                                </select>
                            </div>
                            
                            <div class="col-auto">
                                <select class="form-select form-select-sm" name="sort">
                                    <option value="desc" ${filterSort == 'desc' ? 'selected' : ''}>Mới nhất trước</option>
                                    <option value="asc" ${filterSort == 'asc' ? 'selected' : ''}>Cũ nhất trước</option>
                                </select>
                            </div>

                            <div class="col-auto">
                                <button type="submit" class="btn btn-sm btn-primary"><i class="fa-solid fa-filter"></i> Lọc</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <div class="card-body p-0">
                <table class="table table-hover table-striped mb-0 align-middle">
                    <thead class="table-light">
                        <tr>
                            <th>#</th>
                            <th>Serial Number</th>
                            <th>Code</th>
                            <th>Ngày nhập (Created)</th>
                            <th>Batch ID</th>
                            <th>Trạng thái</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="c" items="${cards}" varStatus="status">
                            <tr>
                                <td>${status.index + 1}</td>
                                <td class="fw-bold font-monospace text-primary">${c.serial}</td>
                                
                                <td class="font-monospace text-muted">
                                    <c:choose>
                                        <c:when test="${c.status == 'SOLD'}">*** (Sold)</c:when>
                                        <c:otherwise>${c.code}</c:otherwise>
                                    </c:choose>
                                </td>
                                
                                <td>${c.createdAt}</td>
                                <td><span class="badge bg-light text-dark border">Batch #${c.batchId}</span></td>
                                
                                <td>
                                    <c:choose>
                                        <c:when test="${c.status == 'IN_STOCK'}"><span class="badge bg-success">Sẵn sàng</span></c:when>
                                        <c:when test="${c.status == 'SOLD'}"><span class="badge bg-secondary">Đã bán</span></c:when>
                                        <c:when test="${c.status == 'RESERVED'}"><span class="badge bg-warning text-dark">Đang giữ</span></c:when>
                                        <c:otherwise><span class="badge bg-dark">${c.status}</span></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty cards}">
                            <tr><td colspan="6" class="text-center py-5 text-muted">Không có thẻ nào phù hợp.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
            
            <c:if test="${totalPages > 0}">
                <div class="card-footer bg-white border-top-0">
                    <nav aria-label="Page navigation">
                        <ul class="pagination justify-content-end mb-0">
                            
                            <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                <a class="page-link" href="?id=${p.productId}&page=${currentPage - 1}&status=${filterStatus}&sort=${filterSort}">Trước</a>
                            </li>
                            
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="?id=${p.productId}&page=${i}&status=${filterStatus}&sort=${filterSort}">${i}</a>
                                </li>
                            </c:forEach>
                            
                            <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="?id=${p.productId}&page=${currentPage + 1}&status=${filterStatus}&sort=${filterSort}">Sau</a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </c:if>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
