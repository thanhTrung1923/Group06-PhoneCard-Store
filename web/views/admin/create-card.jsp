<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Thẻ Mới - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .form-card { max-width: 800px; margin: 0 auto; border: none; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        .form-header { border-radius: 12px 12px 0 0; }
    </style>
</head>
<body>

    <nav class="navbar navbar-dark bg-primary mb-4">
        <div class="container-fluid">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/inventory">
                <i class="fa-solid fa-arrow-left me-2"></i> Quay lại
            </a>
            <span class="navbar-text text-white fw-bold">CREATE NEW CARD CODE</span>
        </div>
    </nav>

    <div class="container">
        <div class="card form-card">
            <div class="card-header form-header bg-white py-3">
                <h5 class="mb-0 text-primary fw-bold"><i class="fa-solid fa-pen-to-square me-2"></i> Thông tin Thẻ (Card Details)</h5>
            </div>
            
            <div class="card-body p-4">
                
                <c:if test="${not empty error}">
                    <div class="alert alert-danger"><i class="fa-solid fa-triangle-exclamation me-2"></i> ${error}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/admin/inventory/create" method="POST">
                    
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Sản phẩm (Product) <span class="text-danger">*</span></label>
                            <select class="form-select" name="product_id" required>
                                <option value="" disabled selected>-- Chọn loại thẻ --</option>
                                <c:forEach var="p" items="${listProducts}">
                                    <option value="${p.productId}">
                                        ${p.typeName} - <fmt:formatNumber value="${p.value}" type="currency" currencySymbol="đ" maxFractionDigits="0"/>
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-bold">Nhà cung cấp (Supplier) <span class="text-danger">*</span></label>
                            <select class="form-select" name="supplier_id" required>
                                <option value="" disabled selected>-- Chọn Supplier --</option>
                                <c:forEach var="s" items="${listSuppliers}">
                                    <option value="${s.supplierId}">${s.supplierName}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-bold">Số Serial <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" name="serial" placeholder="Nhập số serial..." required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-bold">Mã thẻ (Code) <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fa-solid fa-key"></i></span>
                                <input type="text" class="form-control" name="code" placeholder="Nhập mã thẻ cào..." required>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label fw-bold">Trạng thái (Status)</label>
                            <select class="form-select" name="status">
                                <option value="IN_STOCK" selected>IN_STOCK (Sẵn sàng bán)</option>
                                <option value="RESERVED">RESERVED (Đang giữ)</option>
                                <option value="SOLD">SOLD (Đã bán)</option>
                                </select>
                        </div>

                        <div class="col-12">
                            <label class="form-label fw-bold">Ghi chú nội bộ (Internal Notes)</label>
                            <textarea class="form-control" name="note" rows="3" placeholder="Nhập ghi chú thêm..."></textarea>
                        </div>
                    </div>

                    <div class="mt-4 text-end border-top pt-3">
                        <a href="${pageContext.request.contextPath}/admin/inventory" class="btn btn-secondary me-2">
                            <i class="fa-solid fa-xmark"></i> Hủy (Cancel)
                        </a>
                        <button type="submit" class="btn btn-primary px-4">
                            <i class="fa-solid fa-floppy-disk"></i> Lưu (Save)
                        </button>
                    </div>

                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>