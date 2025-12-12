<%@ page contentType="text/html;charset=UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html><body>
        <h2>Quên mật khẩu</h2>
        <form method="post" action="forgot-password">
            <input name="email" placeholder="Email" required />
            <button type="submit">Gửi</button>
        </form>
    <c:if test="${not empty error}"><p style="color:red">${error}</p></c:if>
    <c:if test="${not empty message}"><p style="color:green">${message}</p></c:if>
</body></html>