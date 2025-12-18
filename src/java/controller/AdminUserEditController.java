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
import java.util.logging.Level;
import java.util.logging.Logger;
import model.User;
import ulti.PasswordUtil;

/**
 *
 * @author ADMIN
 */
@WebServlet(name="AdminUserEditController", urlPatterns={"/user-edit"})
public class AdminUserEditController extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
            out.println("<title>Servlet AdminUserEditController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminUserEditController at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
     @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User admin = (User) session.getAttribute("account");

        if (admin == null || !admin.getRoles().contains("ADMIN")) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String idRaw = req.getParameter("id");
        if (idRaw == null) {
            resp.sendRedirect("user-list");
            return;
        }

        int id = Integer.parseInt(idRaw);
        UserDAO dao = new UserDAO();
        User user = dao.getUserById(id);

        if (user == null) {
            req.setAttribute("error", "User không tồn tại");
        } else {
            req.setAttribute("user", user);
        }

        req.getRequestDispatcher("admin-user-edit.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User admin = (User) session.getAttribute("account");

        if (admin == null || !admin.getRoles().contains("ADMIN")) {
            resp.sendRedirect("login.jsp");
            return;
        }

        int id = Integer.parseInt(req.getParameter("userId"));
        String fullName = req.getParameter("fullName");
        String phone = req.getParameter("phone");
        String role = req.getParameter("role");
        boolean isLocked = "on".equals(req.getParameter("isLocked"));
        String password = req.getParameter("password");

        UserDAO dao = new UserDAO();
        User u = dao.getUserById(id);

        if (u == null) {
            req.setAttribute("error", "User không tồn tại");
            req.getRequestDispatcher("admin-user-edit.jsp").forward(req, resp);
            return;
        }

        u.setFullName(fullName);
        u.setPhone(phone);
        u.setIsLocked(isLocked);

        if (password != null && !password.isEmpty()) {
            u.setPasswordHash(PasswordUtil.hash(password));
        }

        try {
            dao.updateUserByAdmin(u, role);
        } catch (Exception ex) {
            Logger.getLogger(AdminUserEditController.class.getName()).log(Level.SEVERE, null, ex);
        }

        resp.sendRedirect("user-edit?id=" + id + "&success=1");
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
