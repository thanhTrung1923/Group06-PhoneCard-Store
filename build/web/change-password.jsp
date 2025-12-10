<%@ page contentType="text/html;charset=UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html><body>
        <h2>Đổi mật khẩu</h2>
        <form method="post" action="change-password">
            <input type="password" name="currentPassword" placeholder="Mật khẩu cũ" required />
            <input type="password" name="newPassword" placeholder="Mật khẩu mới" required />
            <input type="password" name="confirmPassword" placeholder="Xác nhận" required />
            <button type="submit">Đổi</button>
        </form>
    <c:if test="${not empty error}"><p style="color:red">${error}</p></c:if>
    <c:if test="${not empty message}"><p style="color:green">${message}</p></c:if>
</body></html>