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
        body { background-color: #f8f9fa; }
        .stats-card { transition: all 0.3s; border: none; border-radius: 10px; }
        .stats-card:hover { transform: translateY(-5px); box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
        .table-hover tbody tr:hover { background-color: #f1f1f1; }
        .status-badge { font-size: 0.85em; padding: 5px 10px; border-radius: 20px; }
        .filter-bar { background: white; padding: 15px; border-radius: 10px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
    </style>
</head>
<body>

    <nav class="navbar navbar-dark bg-primary mb-4">
        <div class="container-fluid">
            <span class="navbar-brand mb-0 h1"><i class="fa-solid fa-boxes-stacked me-2"></i> INVENTORY MANAGEMENT</span>
            <div class="d-flex text-white">
                Hello, Admin
            </div>
        </div>
    </nav>

    <div class="container-fluid px-4">
        
        <div class="row g-3 mb-4">
            <div class="col-md-3">
                <div class="card stats-card bg-primary text-white h-100">
                    <div class="card-body">
                        <h6 class="card-title text-white-50">IN STOCK (Tồn kho)</h6>
                        <h2 class="fw-bold"><i class="fa-solid fa-layer-group"></i> ${stats.totalInStock}</h2>
                        <small>Cards available</small>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card bg-success text-white h-100">
                    <div class="card-body">
                        <h6 class="card-title text-white-50">SOLD (Đã bán)</h6>
                        <h2 class="fw-bold"><i class="fa-solid fa-cart-shopping"></i> ${stats.totalSold}</h2>
                        <small>Total sales</small>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card bg-warning text-dark h-100">
                    <div class="card-body">
                        <h6 class="card-title text-black-50">LOW STOCK (Sắp hết)</h6>
                        <h2 class="fw-bold"><i class="fa-solid fa-triangle-exclamation"></i> ${stats.totalLowStock}</h2>
                        <small>Needs restock</small>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card stats-card bg-danger text-white h-100">
                    <div class="card-body">
                        <h6 class="card-title text-white-50">OUT OF STOCK (Hết hàng)</h6>
                        <h2 class="fw-bold"><i class="fa-solid fa-circle-xmark"></i> ${stats.totalOutStock}</h2>
                        <small>Critical alerts</small>
                    </div>
                </div>
            </div>
        </div>

        <div class="filter-bar mb-4">
            <form action="${pageContext.request.contextPath}/admin/inventory" method="GET" class="row g-3 align-items-center">
                <div class="col-md-2">
                    <select class="form-select" name="type">
                        <option value="">-- Nhà mạng --</option>
                        <option value="Viettel">Viettel</option>
                        <option value="Vinaphone">Vinaphone</option>
                        <option value="Mobifone">Mobifone</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <select class="form-select" name="value">
                        <option value="">-- Mệnh giá --</option>
                        <option value="10000">10,000 đ</option>
                        <option value="20000">20,000 đ</option>
                        <option value="50000">50,000 đ</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <select class="form-select" name="status">
                        <option value="">-- Trạng thái --</option>
                        <option value="LOW">Low Stock</option>
                        <option value="OUT">Out of Stock</option>
                        <option value="OK">OK</option>
                    </select>
                </div>
                
                <div class="col-md-3">
                    <div class="input-group">
                        <input type="text" class="form-control" name="keyword" placeholder="Tìm tên sản phẩm...">
                        <button class="btn btn-outline-secondary" type="submit"><i class="fa-solid fa-magnifying-glass"></i></button>
                    </div>
                </div>

                <div class="col-md-3 text-end">
                    <div class="btn-group" role="group">
                        <a href="${pageContext.request.contextPath}/admin/import" class="btn btn-primary">
                            <i class="fa-solid fa-file-import"></i> Import
                        </a>
                        <button type="button" class="btn btn-outline-success">
                            <i class="fa-solid fa-file-excel"></i> Export
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <div class="card shadow-sm">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h5 class="mb-0 text-primary fw-bold"><i class="fa-solid fa-list"></i> Danh sách Tồn kho (By Product)</h5>
                
                <div class="btn-group btn-group-sm">
                    <a href="#" class="btn btn-primary active"><i class="fa-solid fa-clipboard-list"></i> By Product</a>
                    <a href="#" class="btn btn-outline-primary"><i class="fa-solid fa-ticket"></i> By Card</a>
                </div>
            </div>
            
            <div class="card-body p-0">
                <table class="table table-hover table-bordered mb-0 align-middle">
                    <thead class="table-light">
                        <tr>
                            <th class="text-center" width="5%"><input type="checkbox"></th>
                            <th width="25%">Sản phẩm (Product)</th>
                            <th width="15%">Mệnh giá (Value)</th>
                            <th width="10%" class="text-center">Tồn (Stock)</th>
                            <th width="10%" class="text-center">Đã bán (Sold)</th>
                            <th width="10%" class="text-center">Min Alert</th>
                            <th width="10%" class="text-center">Trạng thái</th>
                            <th width="15%" class="text-center">Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="p" items="${inventoryList}">
                            <tr>
                                <td class="text-center"><input type="checkbox" value="${p.productId}"></td>
                                
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="bg-light rounded p-2 me-2 text-center" style="width: 40px; height: 40px;">
                                            <i class="fa-solid fa-sim-card text-secondary"></i>
                                        </div>
                                        <div>
                                            <div class="fw-bold">${p.typeName}</div>
                                            <small class="text-muted">ID: #${p.productId}</small>
                                        </div>
                                    </div>
                                </td>
                                
                                <td>
                                    <fmt:formatNumber value="${p.value}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                </td>
                                
                                <td class="text-center fw-bold fs-5">${p.quantity}</td>
                                
                                <td class="text-center text-muted">
                                    ${p.soldCount != null ? p.soldCount : 0}
                                </td>
                                
                                <td class="text-center text-muted"><small>${p.minStockAlert}</small></td>
                                
                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${p.quantity == 0}">
                                            <span class="badge bg-danger status-badge"><i class="fa-solid fa-circle-xmark"></i> OUT</span>
                                        </c:when>
                                        <c:when test="${p.quantity <= p.minStockAlert}">
                                            <span class="badge bg-warning text-dark status-badge"><i class="fa-solid fa-triangle-exclamation"></i> LOW</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-success status-badge"><i class="fa-solid fa-check"></i> OK</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                
                                <td class="text-center">
                                    <a href="#" class="btn btn-sm btn-outline-primary" title="Xem chi tiết thẻ">
                                        <i class="fa-solid fa-eye"></i>
                                    </a>
                                    <a href="#" class="btn btn-sm btn-outline-secondary" title="Chỉnh sửa">
                                        <i class="fa-solid fa-pen"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/admin/import?product_id=${p.productId}" class="btn btn-sm btn-outline-success" title="Nhập thêm hàng">
                                        <i class="fa-solid fa-plus"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${empty inventoryList}">
                            <tr>
                                <td colspan="8" class="text-center py-4 text-muted">
                                    <i class="fa-solid fa-box-open fa-3x mb-3"></i><br>
                                    Không tìm thấy sản phẩm nào trong kho.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
            
            <div class="card-footer bg-white d-flex justify-content-between align-items-center">
                <small class="text-muted">Hiển thị 10 / trang</small>
                <nav>
                    <ul class="pagination pagination-sm mb-0">
                        <li class="page-item disabled"><a class="page-link" href="#">Trước</a></li>
                        <li class="page-item active"><a class="page-link" href="#">1</a></li>
                        <li class="page-item"><a class="page-link" href="#">2</a></li>
                        <li class="page-item"><a class="page-link" href="#">3</a></li>
                        <li class="page-item"><a class="page-link" href="#">Sau</a></li>
                    </ul>
                </nav>
            </div>
        </div>
        
        <c:if test="${stats.totalLowStock > 0 || stats.totalOutStock > 0}">
            <div class="alert alert-danger mt-4 d-flex align-items-center" role="alert">
                <i class="fa-solid fa-bell fa-xl me-3"></i>
                <div>
                    <strong>Cảnh báo Tồn kho:</strong> 
                    Hiện có <strong>${stats.totalOutStock}</strong> sản phẩm hết hàng và <strong>${stats.totalLowStock}</strong> sản phẩm sắp hết.
                    <a href="#" class="alert-link">Xem chi tiết ngay</a>.
                </div>
            </div>
        </c:if>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>