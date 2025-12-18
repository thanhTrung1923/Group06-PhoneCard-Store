<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi mật khẩu | Card Store</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px 0;
        }

        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 10px 20px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 500px;
        }

        .card-header {
            background: transparent;
            border-bottom: 1px solid #f0f0f0;
            padding: 1.5rem;
            text-align: center;
        }

        .form-label {
            font-weight: 500;
            font-size: 0.9rem;
            color: #555;
        }

        .input-group-text {
            background-color: #f8f9fa;
            border-right: none;
            border-radius: 10px 0 0 10px;
            color: #764ba2;
        }

        .form-control {
            border-left: none;
            border-right: none;
            background-color: #f8f9fa;
            padding: 12px;
        }
        
        .form-control:focus {
            box-shadow: none;
            background-color: #fff;
            border-color: #ced4da;
        }
        
        /* Viền khi focus cho cả group */
        .input-group:focus-within .input-group-text,
        .input-group:focus-within .form-control,
        .input-group:focus-within .btn-toggle {
            border-color: #764ba2;
            background-color: #fff;
        }

        .btn-toggle {
            border-radius: 0 10px 10px 0;
            border: 1px solid #ced4da;
            border-left: none;
            background-color: #f8f9fa;
            color: #6c757d;
            z-index: 0;
        }
        
        .btn-toggle:hover {
            color: #764ba2;
            background-color: #f8f9fa;
        }

        .btn-primary {
            background: linear-gradient(to right, #667eea, #764ba2);
            border: none;
            border-radius: 10px;
            padding: 12px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(118, 75, 162, 0.4);
        }

        .btn-outline-secondary {
            border-radius: 10px;
            padding: 12px;
        }
    </style>
</head>
<body>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="card">
                    <div class="card-header">
                        <h4 class="mb-0 fw-bold text-dark">Đổi Mật Khẩu</h4>
                        <p class="text-muted small mb-0 mt-1">Bảo vệ tài khoản của bạn bằng mật khẩu mạnh</p>
                    </div>

                    <div class="card-body p-4">
                        
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger d-flex align-items-center" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                <div>${error}</div>
                            </div>
                        </c:if>

                        <c:if test="${not empty message}">
                            <div class="alert alert-success d-flex align-items-center" role="alert">
                                <i class="bi bi-check-circle-fill me-2"></i>
                                <div>${message}</div>
                            </div>
                        </c:if>

                        <form action="change-password" method="post" id="changePassForm">
                            
                            <div class="mb-3">
                                <label class="form-label">Mật khẩu hiện tại</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-key"></i></span>
                                    <input type="password" name="currentPassword" id="currentPass" class="form-control" placeholder="Nhập mật khẩu cũ" required>
                                    <button class="btn btn-toggle" type="button" onclick="togglePassword('currentPass', 'icon1')">
                                        <i class="bi bi-eye-slash" id="icon1"></i>
                                    </button>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Mật khẩu mới</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-shield-lock"></i></span>
                                    <input type="password" name="newPassword" id="newPass" class="form-control" placeholder="Nhập mật khẩu mới">
                                    <button class="btn btn-toggle" type="button" onclick="togglePassword('newPass', 'icon2')">
                                        <i class="bi bi-eye-slash" id="icon2"></i>
                                    </button>
                                </div>
                                <div class="form-text small text-muted ms-1">Tối thiểu 6 ký tự.</div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label">Xác nhận mật khẩu mới</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-shield-check"></i></span>
                                    <input type="password" name="confirmPassword" id="confirmPass" class="form-control" placeholder="Nhập lại mật khẩu mới" required>
                                    <button class="btn btn-toggle" type="button" onclick="togglePassword('confirmPass', 'icon3')">
                                        <i class="bi bi-eye-slash" id="icon3"></i>
                                    </button>
                                </div>
                            </div>

                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                                <a href="index.jsp" class="btn btn-outline-secondary border-0">Hủy bỏ / Quay về trang chủ</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function togglePassword(inputId, iconId) {
            const input = document.getElementById(inputId);
            const icon = document.getElementById(iconId);
            
            if (input.type === "password") {
                input.type = "text";
                icon.classList.remove("bi-eye-slash");
                icon.classList.add("bi-eye");
            } else {
                input.type = "password";
                icon.classList.remove("bi-eye");
                icon.classList.add("bi-eye-slash");
            }
        }
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>