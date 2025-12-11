<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Sản Phẩm Thẻ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        .status-active { color: green; font-weight: bold; }
        .status-inactive { color: red; font-weight: bold; }
        .card-img-small { width: 50px; height: auto; border-radius: 4px; }
    </style>
</head>
<body class="bg-light">

    <div class="container mt-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-primary"><i class="fas fa-boxes"></i> Danh Sách Sản Phẩm</h2>
            
            <a href="admin-products?action=create" class="btn btn-success">
                <i class="fas fa-plus-circle"></i> Thêm Mới
            </a>
        </div>

        <div class="card shadow-sm">
            <div class="card-body">
                <table class="table table-hover table-bordered align-middle">
                    <thead class="table-dark text-center">
                        <tr>
                            <th>ID</th>
                            <th>Hình ảnh</th>
                            <th>Loại Thẻ</th>
                            <th>Mệnh Giá</th>
                            <th>Giá Bán</th>
                            <th>Tồn Kho</th>
                            <th>Trạng Thái</th>
                            <th>Hành Động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${products}" var="p">
                            <tr>
                                <td class="text-center">${p.productId}</td>
                                
                                <td class="text-center">
                                    <img src="${p.thumbnailUrl != null ? p.thumbnailUrl : 'https://placehold.co/50x30'}" 
                                         class="card-img-small" alt="Img">
                                </td>

                                <td>${p.typeName}</td>
                                
                                <td class="text-end text-primary fw-bold">
                                    ${p.value / 1000}k
                                </td>
                                
                                <td class="text-end text-danger fw-bold">
                                    ${p.formattedPrice} 
                                </td>

                                <td class="text-center">
                                    <c:choose>
                                        <c:when test="${p.quantity <= p.minStockAlert}">
                                            <span class="badge bg-warning text-dark">${p.quantity}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-info">${p.quantity}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td class="text-center">
                                    <c:if test="${p.isActive}">
                                        <span class="status-active"><i class="fas fa-check-circle"></i> Đang bán</span>
                                    </c:if>
                                    <c:if test="${!p.isActive}">
                                        <span class="status-inactive"><i class="fas fa-times-circle"></i> Ngừng bán</span>
                                    </c:if>
                                </td>

                                <td class="text-center">
                                    <a href="admin-products?action=edit&id=${p.productId}" class="btn btn-sm btn-primary" title="Sửa">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    
                                    <a href="#" onclick="confirmDelete(${p.productId})" class="btn btn-sm btn-danger" title="Xóa">
                                        <i class="fas fa-trash-alt"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                
                <c:if test="${empty products}">
                    <div class="alert alert-warning text-center">
                        Không có sản phẩm nào trong hệ thống!
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <script>
        function confirmDelete(id) {
            if (confirm("Bạn có chắc chắn muốn xóa sản phẩm có ID = " + id + "?")) {
                // SỬA LINK: action=delete kèm ID
                window.location.href = "admin-products?action=delete&id=" + id;
            }
        }
    </script>
</body>
</html>