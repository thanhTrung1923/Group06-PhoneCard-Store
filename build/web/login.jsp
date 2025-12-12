<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Đăng nhập hệ thống</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white text-center">
                        <h3>ĐĂNG NHẬP</h3>
                    </div>
                    <div class="card-body">
                        <% if(request.getAttribute("message") != null) { %>
                            <div class="alert alert-danger"><%= request.getAttribute("message") %></div>
                        <% } %>

                        <form action="login" method="post">
                            <div class="mb-3">
                                <label>Email:</label>
                                <input type="email" name="email" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label>Mật khẩu:</label>
                                <input type="password" name="password" class="form-control" required>
                            </div>
                            <button type="submit" class="btn btn-primary w-100">Đăng Nhập</button>
                        </form>
                    </div>
                    <div class="card-footer text-center">
                        Chưa có tài khoản? <a href="register">Đăng ký ngay</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>