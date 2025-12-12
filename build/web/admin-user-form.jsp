<%@ page import="model.User" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
model.User u = (model.User) request.getAttribute("user");
%>
<html><body>
        <h2>${u == null ? "T?o user" : "Ch?nh s?a user"}</h2>
        <form method="post" action="/admin/user-form">
            <input type="hidden" name="userId" value="${u.userId}" />
            Email: <input name="email" value="${u.email}" ${u != null?"readonly":""} required/><br/>
            Full name: <input name="fullName" value="${u.fullName}" /><br/>
            Phone: <input name="phone" value="${u.phone}" /><br/>
            Password: <input name="password" type="password"/><br/>
            Role: <select name="role"><option>ADMIN</option><option>STAFF</option><option selected>CUSTOMER</option></select><br/>
            Is Locked: <input type="checkbox" name="isLocked" ${u != null && u.isLocked?"checked":""}/><br/>
            <button type="submit">Save</button>
        </form>
    <c:if test="${not empty message}"><p style="color:green">${message}</p></c:if>
    <c:if test="${not empty error}"><p style="color:red">${error}</p></c:if>
</body></html>