<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    // Kiểm tra quyền Admin (Giữ nguyên logic của bạn)
    model.User admin = (model.User) session.getAttribute("account");
    if (admin == null || !admin.getRoles().contains("ADMIN")) { 
        response.sendRedirect("login.jsp"); 
        return; 
    }
    List<User> users = (List<User>) request.getAttribute("users");
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý User</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <style>
            body {
                background-color: #f8f9fa;
            }
            .card {
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
                border: none;
            }
            .table th {
                background-color: #343a40;
                color: white;
            }
            .btn-home {
                position: absolute;
                top: 10px;
                left: 10px;
                background-color: #3498db;
                color: white;
                padding: 5px 10px;
                text-decoration: none;
                border-radius: 5px;
                font-weight: bold;
                box-shadow: 0 2px 4px rgba(0,0,0,0.2);
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 2px;
            }
            .btn-home:hover {
                background-color: #2980b9;
                transform: translateY(-1px);
            }
        </style>
    </head>
    <body>
        <a href="admin/dashboard" class="btn-home">
            <span>&#8592;</span> DashBoard
        </a>
        <div class="container mt-5">
            <div class="row mb-4 text-center">
                <div class="col-md-4">
                    <div class="card bg-info text-white">
                        <div class="card-body">
                            <h5>Tổng User</h5>
                            <h2>${totalUsers}</h2>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card bg-success text-white">
                        <div class="card-body">
                            <h5>Đang hoạt động</h5>
                            <h2>${activeUsers}</h2>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="card bg-danger text-white">
                        <div class="card-body">
                            <h5>Bị khóa</h5>
                            <h2>${lockedUsers}</h2>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                    <h3 class="mb-0"><i class="fas fa-users-cog me-2"></i>Quản lý User</h3>
                    <a href="user-form" class="btn btn-light btn-sm fw-bold">
                        <i class="fas fa-plus me-1"></i> Tạo User mới
                    </a>
                </div>

                <div class="card-body">
                    <c:if test="${empty users}">
                        <div class="alert alert-warning text-center">
                            Chưa có dữ liệu user nào.
                        </div>
                    </c:if>

                    <c:if test="${not empty users}">
                        <div class="table-responsive">
                            <table class="table table-hover table-bordered text-center align-middle">
                                <thead class="table-dark">
                                    <tr>
                                        <th>ID</th>
                                        <th>Email</th>
                                        <th>Họ và Tên</th>
                                        <th>SĐT</th>
                                        <th>Vai trò (Roles)</th>
                                        <th>Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${users}" var="u">
                                        <tr>
                                            <td>${u.userId}</td>
                                            <td>${u.email}</td>
                                            <td class="fw-bold">${u.fullName}</td>
                                            <td>${u.phone}</td>
                                            <td>
                                                <span class="badge bg-secondary">${u.roles}</span>
                                            </td>
                                            <td>
                                                <a href="user-edit?id=${u.userId}" class="btn btn-warning btn-sm" title="Sửa">
                                                    <i class="fas fa-edit"></i> Edit
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                            <c:if test="${totalPages > 0}">
                                <nav class="mt-4">
                                    <ul class="pagination justify-content-center">

                                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                            <a class="page-link" href="?page=${currentPage - 1}&q=${q}">«</a>
                                        </li>

                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                                <a class="page-link" href="?page=${i}&q=${q}">${i}</a>
                                            </li>
                                        </c:forEach>

                                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                            <a class="page-link" href="?page=${currentPage + 1}&q=${q}">»</a>
                                        </li>

                                    </ul>
                                </nav>
                            </c:if>

                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>