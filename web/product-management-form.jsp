<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${product != null ? "Cập Nhật" : "Thêm Mới"} Sản Phẩm</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5" style="max-width: 800px;">
        <div class="card shadow">
            <div class="card-header bg-primary text-white">
                <h4 class="mb-0">
                    ${product != null ? "Cập Nhật Sản Phẩm" : "Thêm Mới Sản Phẩm"}
                </h4>
            </div>
            <div class="card-body">
                
                <form action="admin-products?action=${product != null ? 'update' : 'insert'}" method="post">
                    
                    <c:if test="${product != null}">
                        <input type="hidden" name="id" value="${product.productId}">
                    </c:if>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">Loại Thẻ (Type Code)</label>
                            <select name="typeCode" class="form-select">
                                <option value="VIETTEL" ${product.typeCode == 'VIETTEL' ? 'selected' : ''}>Viettel</option>
                                <option value="VINA" ${product.typeCode == 'VINA' ? 'selected' : ''}>Vinaphone</option>
                                <option value="MOBI" ${product.typeCode == 'MOBI' ? 'selected' : ''}>Mobifone</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Tên Hiển Thị</label>
                            <input type="text" name="typeName" class="form-control" value="${product.typeName}" required placeholder="Vd: Thẻ Viettel 50k">
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-4">
                            <label class="form-label">Mệnh Giá (VNĐ)</label>
                            <input type="number" name="value" class="form-control" value="${product.value}" required placeholder="50000">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Giá Nhập</label>
                            <input type="number" step="0.01" name="buyPrice" class="form-control" value="${product.buyPrice}" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Giá Bán</label>
                            <input type="number" step="0.01" name="sellPrice" class="form-control" value="${product.sellPrice}" required>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label">Số Lượng Tồn</label>
                            <input type="number" name="quantity" class="form-control" value="${product != null ? product.quantity : 0}">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Cảnh Báo Tồn Kho Thấp</label>
                            <input type="number" name="minStock" class="form-control" value="${product != null ? product.minStockAlert : 10}">
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Link Ảnh (URL)</label>
                        <input type="text" name="imgUrl" class="form-control" value="${product.imgUrl}" placeholder="https://...">
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Mô Tả</label>
                        <textarea name="description" class="form-control" rows="3">${product.description}</textarea>
                    </div>

                    <div class="mb-3 form-check">
                        <input type="checkbox" name="active" class="form-check-input" id="activeCheck" 
                               ${product == null || product.isActive ? 'checked' : ''}>
                        <label class="form-check-label" for="activeCheck">Đang hoạt động (Active)</label>
                    </div>

                    <div class="d-flex justify-content-end">
                        <a href="admin-products" class="btn btn-secondary me-2">Quay Lại</a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i> Lưu Lại
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>