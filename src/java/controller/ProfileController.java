package controller;

import dao.UserDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;

@WebServlet(name = "ProfileController", urlPatterns = "/profile")
@MultipartConfig
public class ProfileController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("user-profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("account");
        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String fullName = req.getParameter("fullName");
        String phone = req.getParameter("phone");

        Part avatarPart = req.getPart("avatar");
        String avatarPath = user.getAvatarUrl();
        if (avatarPart != null && avatarPart.getSize() > 0) {
            String uploadDir = req.getServletContext().getRealPath("");
            File dir = new File(uploadDir);
            if (!dir.exists()) {
                dir.mkdirs();
            }
            String fileName = "avatar_user_" + user.getUserId() + "_" + System.currentTimeMillis() + ".jpg";
            avatarPart.write(uploadDir + File.separator + fileName);
            avatarPath = "" + fileName;
        }

        UserDAO dao = new UserDAO();
        boolean success = dao.updateProfile(user.getUserId(), fullName, phone, avatarPath);
        if (success) {
            user.setFullName(fullName);
            user.setPhone(phone);
            user.setAvatarUrl(avatarPath);
            session.setAttribute("account", user);
            req.setAttribute("message", "Cập nhật thành công");
        } else {
            req.setAttribute("error", "Cập nhật thất bại");
        }

        req.getRequestDispatcher("user-profile.jsp").forward(req, resp);
    }
}
