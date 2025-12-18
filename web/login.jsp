<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập hệ thống</title>
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
            overflow: hidden;
        }

        .card-header {
            background: transparent;
            border-bottom: none;
            padding-top: 2rem;
            padding-bottom: 1rem;
        }

        .card-header h3 {
            color: #333;
            font-weight: 600;
        }

        .form-control {
            border-radius: 10px;
            padding: 12px 15px;
            background-color: #f8f9fa;
            border: 1px solid #eee;
        }

        .form-control:focus {
            box-shadow: none;
            border-color: #764ba2;
            background-color: #fff;
        }

        .input-group-text {
            border: none;
            background: transparent;
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            z-index: 10;
            cursor: pointer;
            color: #6c757d;
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

        .auth-links a {
            color: #764ba2;
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 500;
        }

        .auth-links a:hover {
            text-decoration: underline;
        }

        .input-icon-wrapper {
            position: relative;
        }
        
        .alert {
            border-radius: 10px;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-5 col-lg-4">
                <div class="card p-4">
                    <div class="card-header text-center">
                        <div class="mb-3">
                            <i class="bi bi-person-circle display-4 text-primary" style="color: #764ba2 !important;"></i>
                        </div>
                        <h3>WELCOME BACK</h3>
                        <p class="text-muted small">Vui lòng đăng nhập để tiếp tục</p>
                    </div>
                    
                    <div class="card-body">
                        <% if(request.getAttribute("message") != null) { %>
                            <div class="alert alert-success d-flex align-items-center" role="alert">
 
                                <div class="btn-btn success"><%= request.getAttribute("message") %></div>
                            </div>
                        <% } %>
                        <% if(request.getAttribute("error") != null) { %>
                            <div class="alert alert-danger d-flex align-items-center" role="alert">
 
                                <div><%= request.getAttribute("error") %></div>
                            </div>
                        <% } %>

                        <form action="login" method="post">
                            <div class="mb-4">
                                <label class="form-label text-muted small fw-bold">EMAIL</label>
                                <div class="input-icon-wrapper">
                                    <input type="email" name="email" class="form-control" placeholder="example@email.com" required>
                                </div>
                            </div>

                            <div class="mb-2">
                                <label class="form-label text-muted small fw-bold">MẬT KHẨU</label>
                                <div class="input-icon-wrapper position-relative">
                                    <input type="password" name="password" id="passwordInput" class="form-control" placeholder="••••••••" required>
                                    <span class="input-group-text" onclick="togglePassword()">
                                        <i class="bi bi-eye-slash" id="toggleIcon"></i>
                                    </span>
                                </div>
                            </div>

                            <div class="d-flex justify-content-end mb-4 auth-links">
                                <a href="forgot-password">Quên mật khẩu?</a>
                            </div>

                            <button type="submit" class="btn btn-primary w-100 mb-3">ĐĂNG NHẬP</button>
                            
                            <div class="text-center auth-links">
                                <span class="text-muted small">Chưa có tài khoản?</span> 
                                <a href="register" class="ms-1">Đăng ký ngay</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function togglePassword() {
            var passwordInput = document.getElementById("passwordInput");
            var icon = document.getElementById("toggleIcon");
            
            if (passwordInput.type === "password") {
                passwordInput.type = "text";
                icon.classList.remove("bi-eye-slash");
                icon.classList.add("bi-eye");
            } else {
                passwordInput.type = "password";
                icon.classList.remove("bi-eye");
                icon.classList.add("bi-eye-slash");
            }
        }
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>