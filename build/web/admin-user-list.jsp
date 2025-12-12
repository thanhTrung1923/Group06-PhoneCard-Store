<%@ page import="java.util.List" %>
<%@ page import="model.User" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
model.User admin = (model.User) session.getAttribute("account");
if (admin == null || !admin.getRoles().contains("ADMIN")) { response.sendRedirect("login.jsp"); return; }
List<User> users = (List<User>) request.getAttribute("users");
%>
<html><body>
        <h2>Qu?n lý user</h2>
        <a href="/admin/user-form">T?o user m?i</a>
        <table border="1">
            <tr><th>ID</th><th>Email</th><th>Full Name</th><th>Phone</th><th>Roles</th><th>Action</th></tr>
                    <c:forEach items="${users}" var="u">
                <tr>
                    <td>${u.userId}</td>
                    <td>${u.email}</td>
                    <td>${u.fullName}</td>
                    <td>${u.phone}</td>
                    <td>${u.roles}</td>
                    <td><a href="/admin/user-form?id=${u.userId}">Edit</a></td>
                </tr>
            </c:forEach>
        </table>
    </body></html>