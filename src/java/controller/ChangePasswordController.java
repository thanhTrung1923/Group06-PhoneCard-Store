package controller;

import dao.UserDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import ulti.PasswordUtil;

@WebServlet(name = "ChangePasswordController", urlPatterns = "/change-password")
public class ChangePasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("change-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User u = (User) session.getAttribute("account");
        if (u == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String current = req.getParameter("currentPassword");
        String newPass = req.getParameter("newPassword");
        String confirm = req.getParameter("confirmPassword");

        if (!newPass.equals(confirm)) {
            req.setAttribute("error", "Xác nhận mật khẩu không khớp");
            req.getRequestDispatcher("change-password.jsp").forward(req, resp);
            return;
        }

// verify current
        if (!PasswordUtil.verify(current, u.getPasswordHash())) {
            req.setAttribute("error", "Mật khẩu cũ không đúng");
            req.getRequestDispatcher("change-password.jsp").forward(req, resp);
            return;
        }

        String newHash = PasswordUtil.hash(newPass);
        UserDAO dao = new UserDAO();
        boolean ok = dao.updatePassword(u.getUserId(), newHash);
        if (ok) {
            u.setPasswordHash(newHash);
            session.setAttribute("account", u);
            req.setAttribute("message", "Đổi mật khẩu thành công");
        } else {
            req.setAttribute("error", "Có lỗi khi cập nhật mật khẩu");
        }
        req.getRequestDispatcher("change-password.jsp").forward(req, resp);
    }
}
