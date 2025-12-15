<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:setLocale value="vi_VN"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử đơn hàng</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
    <style>
        body {
            background-color: #f8f9fa;
        }
        .card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .table thead th {
            background-color: #e9ecef;
            border-top: none;
        }
        .status-badge {
            font-size: 0.9em;
            padding: 6px 12px;
            border-radius: 20px;
        }
    </style>
</head>
<body>

    <c:if test="${empty sessionScope.account}">
        <c:redirect url="login"/>
    </c:if>

    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 class="fw-bold text-primary"><i class="fas fa-history me-2"></i>Lịch sử đơn hàng</h2>
                    <a href="home" class="btn btn-outline-secondary">
                        <i class="fas fa-arrow-left me-1"></i> Trang chủ
                    </a>
                </div>

                <div class="card p-4">
                    <c:choose>
                        <%-- Trường hợp chưa có đơn hàng --%>
                        <c:when test="${empty orders}">
                            <div class="text-center py-5">
                                <i class="fas fa-shopping-cart fa-4x text-muted mb-3"></i>
                                <p class="lead text-muted">Bạn chưa có đơn hàng nào.</p>
                                <a href="shop" class="btn btn-primary mt-2">Mua sắm ngay</a>
                            </div>
                        </c:when>

                        <%-- Trường hợp có đơn hàng --%>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-hover align-middle">
                                    <thead>
                                        <tr>
                                            <th>Mã đơn</th>
                                            <th>Ngày đặt</th>
                                            <th>Tổng tiền</th>
                                            <th>Trạng thái</th>
                                            <th class="text-center">Hành động</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${orders}" var="o">
                                            <tr>
                                                <td class="fw-bold text-secondary">#${o.orderId}</td>
                                                
                                                <td>
                                                    <i class="far fa-calendar-alt text-muted me-1"></i>
                                                    <%-- Định dạng ngày giờ: 15-12-2025 14:30 --%>
                                                    <fmt:formatDate value="${o.createdAtDate}" pattern="dd-MM-yyyy HH:mm"/>
                                                </td>

                                                <td class="fw-bold text-danger">
                                                    <fmt:formatNumber value="${o.totalAmount}" type="currency"/>
                                                </td>

                                                <td>
                                                    <%-- Logic hiển thị màu sắc trạng thái --%>
                                                    <c:choose>
                                                        <c:when test="${o.status == 'Pending' || o.status == 'Processing'}">
                                                            <span class="badge bg-warning text-dark status-badge">Đang xử lý</span>
                                                        </c:when>
                                                        <c:when test="${o.status == 'Completed' || o.status == 'Success'}">
                                                            <span class="badge bg-success status-badge">Thành công</span>
                                                        </c:when>
                                                        <c:when test="${o.status == 'Cancelled'}">
                                                            <span class="badge bg-danger status-badge">Đã hủy</span>
                                                        </c:when>
                                                        <c:when test="${o.status == 'Shipping'}">
                                                            <span class="badge bg-info text-dark status-badge">Đang giao</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary status-badge">${o.status}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>

                                                <td class="text-center">
                                                    <a href="order-detail?id=${o.orderId}" class="btn btn-sm btn-outline-primary">
                                                        <i class="fas fa-eye"></i> Chi tiết
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>