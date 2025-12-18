<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt lại mật khẩu | Card Store</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 10px 20px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 450px;
            overflow: hidden;
        }

        .card-header {
            background: #fff;
            border-bottom: none;
            padding-top: 2rem;
            text-align: center;
        }

        .icon-wrapper {
            width: 70px;
            height: 70px;
            background: rgba(118, 75, 162, 0.1);
            color: #764ba2;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            font-size: 2rem;
        }

        .form-control {
            border-right: none;
            background-color: #f8f9fa;
            padding: 12px;
            border: 1px solid #ced4da;
        }
        
        .form-control:focus {
            box-shadow: none;
            background-color: #fff;
            border-color: #764ba2;
        }
        
        .input-group-text {
            background-color: #f8f9fa;
            border-right: none;
            color: #6c757d;
        }

        /* Nút con mắt */
        .btn-toggle {
            border: 1px solid #ced4da;
            border-left: none;
            background-color: #f8f9fa;
            color: #6c757d;
            border-radius: 0 0.375rem 0.375rem 0;
            z-index: 0;
        }
        
        .btn-toggle:hover {
            color: #764ba2;
            background-color: #f8f9fa;
        }
        
        /* Khi focus vào input thì viền cả group sáng lên */
        .input-group:focus-within .form-control,
        .input-group:focus-within .input-group-text,
        .input-group:focus-within .btn-toggle {
            border-color: #764ba2;
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
    </style>
</head>
<body>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card p-3">
                    <div class="card-header">
                        <div class="icon-wrapper">
                            <i class="bi bi-arrow-repeat"></i>
                        </div>
                        <h4 class="fw-bold">Đặt Lại Mật Khẩu</h4>
                        <p class="text-muted small">Vui lòng nhập mật khẩu mới cho tài khoản của bạn.</p>
                    </div>

                    <div class="card-body pt-0">
                        
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger d-flex align-items-center fade show" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                <div>${error}</div>
                            </div>
                        </c:if>

                        <form action="reset-password" method="post" id="resetForm">
                            <input type="hidden" name="token" value="${token}" />

                            <div class="mb-3">
                                <label class="form-label text-muted small fw-bold">MẬT KHẨU MỚI</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-key"></i></span>
                                    <input type="password" name="password" id="newPass" class="form-control" placeholder="Nhập mật khẩu mới">
                                    <button class="btn btn-toggle" type="button" onclick="togglePassword('newPass', 'icon1')">
                                        <i class="bi bi-eye-slash" id="icon1"></i>
                                    </button>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label text-muted small fw-bold">XÁC NHẬN MẬT KHẨU</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-shield-check"></i></span>
                                    <input type="password" name="confirmPassword" id="confirmPass" class="form-control" placeholder="Nhập lại mật khẩu" >
                                    <button class="btn btn-toggle" type="button" onclick="togglePassword('confirmPass', 'icon2')">
                                        <i class="bi bi-eye-slash" id="icon2"></i>
                                    </button>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-primary w-100 mb-3">
                                CẬP NHẬT MẬT KHẨU
                            </button>
                            
                            <div class="text-center">
                                <a href="login" class="text-decoration-none text-muted small">
                                    <i class="bi bi-arrow-left"></i> Quay về Đăng nhập
                                </a>
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