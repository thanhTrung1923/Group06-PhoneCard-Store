<%@ page import="java.util.List" %>
<%@ page import="model.Order" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
model.User u = (model.User) session.getAttribute("account");
if (u == null) { response.sendRedirect("login.jsp"); return; }
List<Order> orders = (List<Order>) request.getAttribute("orders");
%>
<html>
    <body>
        <h2>L?ch s? ??n hàng</h2>
        <table border="1">
            <tr><th>Order ID</th><th>T?ng</th><th>Tr?ng thái</th><th>Ngày</th><th>Chi ti?t</th></tr>
                    <c:forEach items="${orders}" var="o">
                <tr>
                    <td>${o.orderId}</td>
                    <td>${o.totalAmount}</td>
                    <td>${o.status}</td>
                    <td>${o.createdAt}</td>
                    <td><a href="order-detail?id=${o.orderId}">Xem</a></td>
                </tr>
            </c:forEach>
        </table>
    </body>
</html>