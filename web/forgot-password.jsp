<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên mật khẩu | Card Store</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); /* Giữ màu giống trang Login */
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
            width: 100%;
            max-width: 450px;
        }

        .card-header {
            background: transparent;
            border-bottom: none;
            padding-top: 2rem;
            text-align: center;
        }

        .icon-box {
            width: 80px;
            height: 80px;
            background: rgba(118, 75, 162, 0.1);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
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

        .input-group-text {
            border: none;
            background: transparent;
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            z-index: 10;
            color: #6c757d;
        }
        
        .input-wrapper {
            position: relative;
        }

        .back-link {
            color: #6c757d;
            text-decoration: none;
            font-size: 0.9rem;
            transition: 0.3s;
            display: inline-flex;
            align-items: center;
        }

        .back-link:hover {
            color: #764ba2;
            transform: translateX(-5px);
        }
    </style>
</head>
<body>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="card p-4">
                    <div class="card-header">
                        <div class="icon-box">
                            <i class="bi bi-shield-lock display-4 text-primary" style="color: #764ba2 !important;"></i>
                        </div>
                        <h3 class="fw-bold mb-1">Quên mật khẩu?</h3>
                        <p class="text-muted small">Đừng lo lắng! Hãy nhập email của bạn và chúng tôi sẽ gửi hướng dẫn khôi phục.</p>
                    </div>

                    <div class="card-body pt-0">
                        
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger d-flex align-items-center fade show" role="alert">
                                <i class="bi bi-exclamation-circle-fill me-2"></i>
                                <div>${error}</div>
                            </div>
                        </c:if>

                        <c:if test="${not empty message}">
                            <div class="alert alert-success d-flex align-items-center fade show" role="alert">
                                <i class="bi bi-check-circle-fill me-2"></i>
                                <div>${message}</div>
                            </div>
                        </c:if>

                        <form action="forgot-password" method="post" id="forgotForm">
                            <div class="mb-4">
                                <label class="form-label text-muted small fw-bold">EMAIL ĐĂNG KÝ</label>
                                <div class="input-wrapper">
                                    <input type="email" name="email" class="form-control" placeholder="example@email.com" required>
                                    <span class="input-group-text">
                                        <i class="bi bi-envelope"></i>
                                    </span>
                                </div>
                            </div>

                            <button type="submit" class="btn btn-primary w-100 mb-4" id="submitBtn">
                                GỬI YÊU CẦU
                            </button>
                        </form>

                        <div class="text-center border-top pt-3">
                            <a href="login" class="back-link">
                                <i class="bi bi-arrow-left me-2"></i> Quay lại Đăng nhập
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.getElementById('forgotForm').addEventListener('submit', function() {
            var btn = document.getElementById('submitBtn');
            btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Đang xử lý...';
            btn.disabled = true; // Chặn bấm nhiều lần
        });
    </script>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>