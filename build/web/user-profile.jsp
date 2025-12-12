<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${empty sessionScope.account}">
    <c:redirect url="login.jsp"/>
</c:if>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Thông tin tài khoản</title>
        <style>
            /* Reset cơ bản */
            * { box-sizing: border-box; }
            
            body {
                font-family: 'Segoe UI', Arial, sans-serif;
                background: #f5f6f8;
                margin: 0;
                padding: 20px;
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                position: relative; /* Để nút Home định vị theo body */
            }

            /* --- Nút Home --- */
            .btn-home {
                position: absolute;
                top: 20px;
                left: 20px;
                background-color: #3498db;
                color: white;
                padding: 10px 20px;
                text-decoration: none;
                border-radius: 5px;
                font-weight: bold;
                box-shadow: 0 2px 5px rgba(0,0,0,0.2);
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 5px;
            }
            .btn-home:hover {
                background-color: #2980b9;
                transform: translateY(-2px);
            }

            /* --- Container chính --- */
            .container {
                width: 100%;
                max-width: 500px; /* Dùng max-width để responsive tốt hơn */
                background: white;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            }

            h2.title {
                text-align: center;
                color: #333;
                margin-bottom: 20px;
            }

            /* --- Avatar --- */
            .avatar-wrapper {
                text-align: center;
                margin-bottom: 25px;
            }
            .avatar-wrapper img {
                width: 120px;
                height: 120px;
                border-radius: 50%;
                object-fit: cover;
                border: 4px solid #f0f2f5;
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            }

            /* --- Form Elements --- */
            form label {
                display: block;
                margin-bottom: 8px;
                font-weight: 600;
                color: #555;
            }

            form input[type=text], 
            form input[type=email], 
            form input[type=file] {
                width: 100%;
                padding: 12px;
                margin-bottom: 20px;
                border: 1px solid #ddd;
                border-radius: 6px;
                font-size: 14px;
                transition: border-color 0.3s;
            }

            form input:focus {
                border-color: #3498db;
                outline: none;
            }

            form input[disabled] {
                background-color: #eee;
                color: #777;
                cursor: not-allowed;
            }

            /* --- Nút Submit --- */
            .btn-submit {
                width: 100%;
                padding: 12px;
                background: #27ae60;
                color: white;
                border: none;
                border-radius: 6px;
                font-size: 16px;
                font-weight: bold;
                cursor: pointer;
                transition: background 0.3s;
            }
            .btn-submit:hover {
                background: #219150;
            }

            /* --- Thông báo --- */
            .alert {
                padding: 10px;
                border-radius: 5px;
                margin-bottom: 15px;
                text-align: center;
                font-size: 14px;
            }
            .alert-success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
            .alert-danger { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }

        </style>
    </head>
    <body>

        <a href="home" class="btn-home">
            <span>&#8592;</span> Trang chủ
        </a>

        <div class="container">
            <h2 class="title">Thông Tin Cá Nhân</h2>

            <c:if test="${not empty requestScope.message}">
                <div class="alert alert-success">${requestScope.message}</div>
            </c:if>
            <c:if test="${not empty requestScope.error}">
                <div class="alert alert-danger">${requestScope.error}</div>
            </c:if>

            <div class="avatar-wrapper">
                <c:set var="avatarPath" value="${sessionScope.account.avatarUrl}" />
                <c:if test="${empty avatarPath}">
                    <c:set var="avatarPath" value="images/default-avatar.png" /> 
                    </c:if>
                
                <img src="${avatarPath}" alt="Avatar">
            </div>

            <form action="profile" method="post" enctype="multipart/form-data">
                
                <label for="fullName">Họ và tên:</label>
                <input type="text" id="fullName" name="fullName" value="${sessionScope.account.fullName}" required>

                <label>Email (Không thể thay đổi):</label>
                <input type="email" value="${sessionScope.account.email}" disabled>

                <label for="phone">Số điện thoại:</label>
                <input type="text" id="phone" name="phone" value="${sessionScope.account.phone}">

                <label for="avatar">Cập nhật ảnh đại diện:</label>
                <input type="file" id="avatar" name="avatar" accept="image/*">

                <button type="submit" class="btn-submit">Lưu thay đổi</button>
            </form>
        </div>

    </body>
</html>