package controller;

import controller.ForgotPasswordController;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.User;
import ulti.PasswordUtil;

@WebServlet(name = "ResetPasswordController", urlPatterns = "/reset-password")
public class ResetPasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");
        if (token == null || ForgotPasswordController.getEmailByToken(token) == null) {
            req.setAttribute("error", "Token không hợp lệ hoặc hết hạn.");
            req.getRequestDispatcher("forgot-password.jsp").forward(req, resp);
            return;
        }
        req.setAttribute("token", token);
        req.getRequestDispatcher("reset-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String token = req.getParameter("token");
        String newPass = req.getParameter("password");
        String confirm = req.getParameter("confirmPassword");
        if (!newPass.equals(confirm)) {
            req.setAttribute("error", "Mật khẩu xác nhận không khớp");
            req.setAttribute("token", token);
            req.getRequestDispatcher("reset-password.jsp").forward(req, resp);
            return;
        }
        String email = ForgotPasswordController.getEmailByToken(token);
        if (email == null) {
            req.setAttribute("error", "Token không hợp lệ");
            req.getRequestDispatcher("forgot-password.jsp").forward(req, resp);
            return;
        }

        UserDAO dao = new UserDAO();
        String hashed = PasswordUtil.hash(newPass);
        User u = dao.getUserByEmail(email);
        boolean ok = dao.updatePassword(u.getUserId(), hashed);
        if (ok) {
            ForgotPasswordController.removeToken(token);
            req.setAttribute("message", "Đổi mật khẩu thành công. Vui lòng đăng nhập.");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        } else {
            req.setAttribute("error", "Có lỗi khi cập nhật mật khẩu");
            req.setAttribute("token", token);
            req.getRequestDispatcher("reset-password.jsp").forward(req, resp);
        }
    }
}
