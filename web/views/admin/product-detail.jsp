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

        <div class="card shadow-sm">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h5 class="mb-0 fw-bold"><i class="fa-solid fa-list me-2"></i> Danh sách thẻ (Card List)</h5>
                <span class="badge bg-secondary">Total: ${cards.size()}</span>
            </div>
            <div class="card-body p-0">
                <table class="table table-hover table-striped card-list-table mb-0 align-middle">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Serial Number</th>
                            <th>Code (Mã thẻ)</th>
                            <th>Ngày nhập (Created)</th>
                            <th>Batch ID</th>
                            <th>Trạng thái</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="c" items="${cards}" varStatus="status">
                            <tr>
                                <td>${status.index + 1}</td>
                                <td class="fw-bold font-monospace text-primary">${c.serial}</td>
                                
                                <td class="font-monospace text-muted">
                                    <c:choose>
                                        <c:when test="${c.status == 'SOLD'}">
                                            <span class="text-decoration-line-through">******</span> (Đã bán)
                                        </c:when>
                                        <c:otherwise>
                                            ${c.code}
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                
                                <td>${c.createdAt}</td>
                                <td><span class="badge bg-light text-dark border">Batch #${c.batchId}</span></td>
                                
                                <td>
                                    <c:choose>
                                        <c:when test="${c.status == 'IN_STOCK'}"><span class="badge bg-success">Sẵn sàng</span></c:when>
                                        <c:when test="${c.status == 'SOLD'}"><span class="badge bg-secondary">Đã bán</span></c:when>
                                        <c:when test="${c.status == 'RESERVED'}"><span class="badge bg-warning text-dark">Đang giữ</span></c:when>
                                        <c:otherwise><span class="badge bg-danger">${c.status}</span></c:otherwise>
                                    </c:choose>
                                </td>
                                
                                <td>
                                    <button class="btn btn-sm btn-outline-secondary" title="Sửa thẻ"><i class="fa-solid fa-pen"></i></button>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty cards}">
                            <tr><td colspan="7" class="text-center py-4 text-muted">Chưa có thẻ nào trong kho.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>