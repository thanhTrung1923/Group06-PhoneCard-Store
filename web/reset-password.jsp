<%@ page contentType="text/html;charset=UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html><body>
        <h2>Đặt lại mật khẩu</h2>
        <form method="post" action="reset-password">
            <input type="hidden" name="token" value="${token}" />
            <input type="password" name="password" placeholder="Mật khẩu mới" required />
            <input type="password" name="confirmPassword" placeholder="Xác nhận" required />
            <button type="submit">Cập nhật</button>
        </form>
    <c:if test="${not empty error}"><p style="color:red">${error}</p></c:if>
</body></html>