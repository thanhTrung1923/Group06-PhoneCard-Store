<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký tài khoản | Card Store</title>
    
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
            padding: 30px 0;
        }

        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 10px 20px rgba(0,0,0,0.2);
            width: 100%;
            max-width: 500px; /* Form đăng ký rộng hơn form login một chút */
            overflow: hidden;
        }

        .card-header {
            background: #fff;
            border-bottom: 1px solid #f0f0f0;
            padding: 1.5rem 1rem;
            text-align: center;
        }
        
        .icon-box {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 10px;
            font-size: 1.8rem;
            box-shadow: 0 4px 10px rgba(118, 75, 162, 0.3);
        }

        .form-label {
            font-weight: 500;
            font-size: 0.9rem;
            color: #555;
            margin-bottom: 0.3rem;
        }

        .input-group-text {
            background-color: #f8f9fa;
            border-right: none;
            color: #764ba2;
            border-radius: 10px 0 0 10px;
        }

        .form-control {
            border-left: none;
            border-right: none; /* Nếu có nút toggle */
            background-color: #f8f9fa;
            padding: 10px 15px;
            border: 1px solid #ced4da;
        }
        
        /* Input thường (không có toggle) thì bo góc phải */
        .input-group > .form-control:not(:last-child) {
             border-top-right-radius: 10px;
             border-bottom-right-radius: 10px;
             border-right: 1px solid #ced4da;
        }

        .form-control:focus {
            box-shadow: none;
            background-color: #fff;
            border-color: #ced4da;
        }

        .input-group:focus-within .input-group-text,
        .input-group:focus-within .form-control,
        .input-group:focus-within .btn-toggle {
            border-color: #764ba2;
            background-color: #fff;
        }

        /* Nút ẩn hiện mật khẩu */
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

        .btn-register {
            background: linear-gradient(to right, #667eea, #764ba2);
            border: none;
            border-radius: 10px;
            padding: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.3s ease;
        }

        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(118, 75, 162, 0.4);
        }
        
        .login-link a {
            color: #764ba2;
            text-decoration: none;
            font-weight: 600;
        }
        
        .login-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="card">
                    <div class="card-header">
                        <div class="icon-box">
                            <i class="bi bi-person-plus-fill"></i>
                        </div>
                        <h3 class="fw-bold mb-0 text-dark">Đăng Ký Thành Viên</h3>
                        <p class="text-muted small mt-1 mb-0">Tạo tài khoản để mua sắm thẻ nhanh chóng</p>
                    </div>
                    
                    <div class="card-body p-4">
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger d-flex align-items-center mb-4" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                <div>${error}</div>
                            </div>
                        </c:if>

                        <form action="register" method="post">
                            
                            <div class="mb-3">
                                <label class="form-label">Họ và tên</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-person"></i></span>
                                    <input type="text" name="fullName" class="form-control" value="${fullName}" placeholder="Nguyễn Văn A" >
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Số điện thoại</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                                        <input type="tel" name="phone" class="form-control" value="${phone}" placeholder="0xxxxxxxx" >
                                    </div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Email</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                                        <input type="email" name="email" class="form-control" value="${email}" placeholder="name@example.com" >
                                    </div>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Mật khẩu</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-lock"></i></span>
                                    <input type="password" name="password" id="regPass" class="form-control" value="${password}" placeholder="Nhập mật khẩu" >
                                    <button class="btn btn-toggle" type="button" onclick="togglePassword('regPass', 'icon1')">
                                        <i class="bi bi-eye-slash" id="icon1"></i>
                                    </button>
                                </div>
                                <div class="form-text text-muted small ms-1">Tối thiểu 6 ký tự</div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label">Xác nhận mật khẩu</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-shield-check"></i></span>
                                    <input type="password" name="confirmPassword" id="confirmPass" class="form-control" value="${confirmPass}" placeholder="Nhập lại mật khẩu" >
                                    <button class="btn btn-toggle" type="button" onclick="togglePassword('confirmPass', 'icon2')">
                                        <i class="bi bi-eye-slash" id="icon2"></i>
                                    </button>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-primary btn-register w-100 mb-3">TẠO TÀI KHOẢN</button>
                            
                        </form>
                    </div>

                    <div class="card-footer text-center bg-white py-3 border-top-0 login-link">
                        <span class="text-muted">Đã có tài khoản?</span> 
                        <a href="login" class="ms-1">Đăng nhập ngay</a>
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