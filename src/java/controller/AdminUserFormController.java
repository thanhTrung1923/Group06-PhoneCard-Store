/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import ulti.PasswordUtil;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "AdminUserFormController", urlPatterns = {"/admin/user-form"})
public class AdminUserFormController extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AdminUserFormController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminUserFormController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User admin = (User) session.getAttribute("account");
        if (admin == null || !admin.getRoles().contains("ADMIN")) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String id = req.getParameter("id");
        if (id != null) {
            UserDAO dao = new UserDAO();
            User u = dao.getUserById(Integer.parseInt(id));
            req.setAttribute("user", u);
        }
        req.getRequestDispatcher("admin-user-form.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User admin = (User) session.getAttribute("account");
        if (admin == null || !admin.getRoles().contains("ADMIN")) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String id = req.getParameter("userId");
        String email = req.getParameter("email");
        String fullName = req.getParameter("fullName");
        String phone = req.getParameter("phone");
        String role = req.getParameter("role"); // ADMIN / STAFF / CUSTOMER
        boolean isLocked = "on".equals(req.getParameter("isLocked"));
        String password = req.getParameter("password");

        UserDAO dao = new UserDAO();
        try {
            if (id == null || id.isEmpty()) {
// create
                User u = new User();
                u.setEmail(email);
                u.setFullName(fullName);
                u.setPhone(phone);
                u.setIsLocked(isLocked);
                if (password == null || password.isEmpty()) {
                    password = "123456";
                }
                u.setPasswordHash(PasswordUtil.hash(password));
                int newId = dao.createUserByAdmin(u, role);
                req.setAttribute("message", "Tạo user thành công (id=" + newId + ")");
            } else {
// update
                User u = dao.getUserById(Integer.parseInt(id));
                u.setFullName(fullName);
                u.setPhone(phone);
                u.setIsLocked(isLocked);
// nếu admin đổi password
                if (password != null && !password.isEmpty()) {
                    u.setPasswordHash(PasswordUtil.hash(password));
                }
                dao.updateUserByAdmin(u, role);
                req.setAttribute("message", "Cập nhật user thành công");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi khi lưu user: " + e.getMessage());
        }

        req.getRequestDispatcher("admin-user-form.jsp").forward(req, resp);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
