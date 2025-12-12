<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User"%>
<%
    User user = (User) session.getAttribute("account");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Thông tin tài khoản</title>
        <style>
            body {
                font-family: Arial;
                background: #f5f6f8;
                padding: 20px;
            }
            .container {
                width: 500px;
                margin: auto;
                background: white;
                padding: 20px;
                border-radius: 8px;
            }
            .avatar img {
                width: 120px;
                height: 120px;
                border-radius: 50%;
                object-fit: cover;
            }
            .center {
                text-align: center;
            }
            input[type=text], input[type=email], input[type=file] {
                width: 100%;
                padding: 10px;
                margin-top: 10px;
                border: 1px solid #ccc;
                border-radius: 5px;
            }
            button {
                padding: 10px 20px;
                background: #3498db;
                color: white;
                border: none;
                border-radius: 5px;
                margin-top: 15px;
                cursor: pointer;
            }
        </style>
    </head>
    <body>

        <div class="container">
            <h2 class="center">Thông Tin Tài Khoản</h2>

            <div class="center avatar">
                <img src="<%= user.getAvatarUrl() == null ? "default-avatar.png" : user.getAvatarUrl() %>" alt="">
            </div>

            <form action="profile" method="post" enctype="multipart/form-data">
                <label>Họ tên:</label>
                <input type="text" name="fullName" value="<%= user.getFullName() %>" required>

                <label>Email (không thể đổi):</label>
                <input type="email" value="<%= user.getEmail() %>" disabled>

                <label>Số điện thoại:</label>
                <input type="text" name="phone" value="<%= user.getPhone() %>">

                <label>Đổi ảnh đại diện:</label>
                <input type="file" name="avatar">

                <% if (request.getAttribute("message") != null) { %>
                <p style="color: green;"><%= request.getAttribute("message") %></p>
                <% } %>

                <button type="submit">Cập nhật</button>
            </form>
        </div>

    </body>
</html>
