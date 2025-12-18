<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    model.User u = (model.User) request.getAttribute("user");
    // Biến kiểm tra xem đang ở chế độ Edit hay Create
    boolean isEdit = (u != null);
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${isEdit ? "Chỉnh sửa User" : "Tạo User mới"}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        body { background-color: #f8f9fa; }
        .form-card { max-width: 700px; margin: auto; box-shadow: 0 4px 10px rgba(0,0,0,0.1); border: none; }
        .form-label { font-weight: 600; font-size: 0.9rem; }
    </style>
</head>
<body>

<div class="container mt-5">
    <div class="card form-card">
        <div class="card-header ${isEdit ? 'bg-warning' : 'bg-success'} text-white">
            <h4 class="mb-0">
                <i class="fas ${isEdit ? 'fa-user-edit' : 'fa-user-plus'} me-2"></i>
                ${isEdit ? "Cập nhật thông tin User" : "Tạo User mới"}
            </h4>
        </div>
        
        <div class="card-body p-4">
            
            <c:if test="${not empty message}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-1"></i> ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-1"></i> ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <form method="post" action="user-form">
                <input type="hidden" name="userId" value="${u.userId}" />

                <div class="row">
                    <div class="col-md-12 mb-3">
                        <label class="form-label">Email <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                            <input type="email" name="email" class="form-control" 
                                   value="${u.email}" 
                                   ${isEdit ? "readonly style='background-color: #e9ecef;'" : ""} 
                                   required placeholder="name@example.com"/>
                        </div>
                        <c:if test="${isEdit}">
                            <small class="text-muted fst-italic">Không thể thay đổi Email.</small>
                        </c:if>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label class="form-label">Họ và tên</label>
                        <input type="text" name="fullName" class="form-control" value="${u.fullName}" placeholder="Nhập họ tên đầy đủ"/>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label class="form-label">Số điện thoại</label>
                        <input type="text" name="phone" class="form-control" value="${u.phone}" placeholder="09xxxxxxxx"/>
                    </div>
                    
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Mật khẩu</label>
                        <input type="password" name="password" class="form-control" placeholder="******"/>
                        <c:if test="${isEdit}">
                            <small class="text-muted" style="font-size: 0.8em;">*Để trống nếu không muốn đổi mật khẩu</small>
                        </c:if>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label class="form-label">Vai trò (Role)</label>
                        <select name="role" class="form-select">
                            <option value="ADMIN" ${u != null && u.roles.contains('ADMIN') ? 'selected' : ''}>ADMIN</option>
                            <option value="STAFF" ${u != null && u.roles.contains('STAFF') ? 'selected' : ''}>STAFF</option>
                            <option value="CUSTOMER" ${u == null || u.roles.contains('CUSTOMER') ? 'selected' : ''}>CUSTOMER</option>
                        </select>
                    </div>
                </div>

                <div class="mb-4">
                    <div class="form-check form-switch">
                        <input class="form-check-input" type="checkbox" name="isLocked" id="lockedSwitch" 
                               ${u != null && u.isLocked ? "checked" : ""}>
                        <label class="form-check-label" for="lockedSwitch">Khóa tài khoản (Is Locked)</label>
                    </div>
                </div>

                <div class="d-flex justify-content-end gap-2">
                    <a href="users" class="btn btn-secondary">
                        <i class="fas fa-arrow-left me-1"></i> Quay lại
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-1"></i> Lưu lại
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>