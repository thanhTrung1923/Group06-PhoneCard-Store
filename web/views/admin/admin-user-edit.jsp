<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa User</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        body { background-color: #f0f2f5; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .edit-card { 
            max-width: 500px; 
            margin: 50px auto; 
            border: none; 
            box-shadow: 0 4px 12px rgba(0,0,0,0.1); 
            border-radius: 10px;
        }
        .card-header {
            background: linear-gradient(45deg, #0d6efd, #0dcaf0);
            color: white;
            border-radius: 10px 10px 0 0 !important;
            font-weight: bold;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="card edit-card">
        <div class="card-header text-center py-3">
            <h4 class="mb-0"><i class="fas fa-user-edit me-2"></i>Chỉnh sửa User</h4>
        </div>
        
        <div class="card-body p-4">
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger d-flex align-items-center" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    <div>${error}</div>
                </div>
            </c:if>

            <c:if test="${param.success == 1}">
                <div class="alert alert-success d-flex align-items-center" role="alert">
                    <i class="fas fa-check-circle me-2"></i>
                    <div>Cập nhật thành công!</div>
                </div>
            </c:if>

            <c:if test="${not empty user}">
                <form method="post" action="/admin/user-edit">
                    <input type="hidden" name="userId" value="${user.userId}" />

                    <div class="mb-3">
                        <label class="form-label fw-bold text-secondary">Email (Không thể sửa)</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="fas fa-envelope"></i></span>
                            <input type="text" class="form-control bg-light" value="${user.email}" readonly />
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Họ và tên</label>
                        <input type="text" name="fullName" class="form-control" value="${user.fullName}" required placeholder="Nhập họ tên"/>
                    </div>

                    <div class="mb-3">
<label class="form-label fw-bold">Số điện thoại</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-phone"></i></span>
                            <input type="text" name="phone" class="form-control" value="${user.phone}" placeholder="09xxxxxxx"/>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Vai trò (Role)</label>
                        <select name="role" class="form-select">
                            <option value="ADMIN" ${user.roles.contains("ADMIN") ? "selected" : ""}>ADMIN</option>
                            <option value="STAFF" ${user.roles.contains("STAFF") ? "selected" : ""}>STAFF</option>
                            <option value="CUSTOMER" ${user.roles.contains("CUSTOMER") ? "selected" : ""}>CUSTOMER</option>
                        </select>
                    </div>

                    <div class="mb-3 p-2 border rounded bg-light">
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" name="isLocked" id="lockedSwitch" ${user.isLocked ? "checked" : ""} />
                            <label class="form-check-label fw-bold text-danger" for="lockedSwitch">
                                <i class="fas fa-lock me-1"></i> Khóa tài khoản này
                            </label>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label fw-bold">Mật khẩu mới</label>
                        <input type="password" name="password" class="form-control" placeholder="Để trống nếu không muốn đổi" />
                        <small class="text-muted" style="font-size: 0.8rem;">* Chỉ nhập nếu bạn muốn reset mật khẩu user này.</small>
                    </div>

                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                        <a href="admin/users" class="btn btn-secondary me-md-2">
                            <i class="fas fa-arrow-left"></i> Quay lại
                        </a>
                        <button class="btn btn-primary px-4" type="submit">
                            <i class="fas fa-save"></i> Lưu thay đổi
                        </button>
                    </div>
                </form>
            </c:if>

            <c:if test="${empty user}">
                <div class="alert alert-warning text-center">
                    Không tìm thấy thông tin người dùng. <br>
                    <a href="/admin/users" class="alert-link">Quay lại danh sách</a>
                </div>
            </c:if>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>