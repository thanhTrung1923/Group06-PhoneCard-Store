<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Hỗ Trợ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .priority-URGENT { background-color: #dc3545; color: white; } /* Đỏ */
        .priority-HIGH { background-color: #fd7e14; color: white; }   /* Cam */
        .priority-MEDIUM { background-color: #ffc107; color: black; }  /* Vàng */
        .priority-LOW { background-color: #6c757d; color: white; }     /* Xám */
    </style>
</head>
<body class="bg-light">

    <div class="container mt-5">
        <h2 class="mb-4 text-primary"><i class="fas fa-headset"></i> Danh Sách Yêu Cầu Hỗ Trợ</h2>
        
        <div class="card shadow">
            <div class="card-body">
                <table class="table table-hover align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th>#ID</th>
                            <th>Người Gửi</th>
                            <th>Tiêu Đề</th>
                            <th>Mức Độ</th>
                            <th>Trạng Thái</th>
                            <th>Ngày Gửi</th>
                            <th>Hành Động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${ticketList}" var="t">
                            <tr>
                                <td>#${t.ticketId}</td>
                                
                                <td>
                                    <strong>${t.userName}</strong><br>
                                    <small class="text-muted">ID: ${t.userId}</small>
                                </td>
                                
                                <td>${t.subject}</td>
                                
                                <td>
                                    <span class="badge priority-${t.priority}">${t.priority}</span>
                                </td>
                                
                                <td>
                                    <c:choose>
                                        <c:when test="${t.status == 'NEW'}">
                                            <span class="badge bg-success">Mới</span>
                                        </c:when>
                                        <c:when test="${t.status == 'PROCESSING'}">
                                            <span class="badge bg-primary">Đang xử lý</span>
                                        </c:when>
                                        <c:when test="${t.status == 'RESOLVED'}">
                                            <span class="badge bg-info text-dark">Đã xong</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">Đã đóng</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                
                                <td>
                                    <fmt:formatDate value="${t.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </td>
                                
                                <td>
                                    <a href="admin-ticket-detail?id=${t.ticketId}" class="btn btn-sm btn-outline-primary">
                                        Xem chi tiết <i class="fas fa-arrow-right"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <c:if test="${empty ticketList}">
                    <div class="alert alert-info text-center">
                        Hiện tại không có yêu cầu hỗ trợ nào.
                    </div>
                </c:if>
            </div>
        </div>
    </div>

</body>
</html>