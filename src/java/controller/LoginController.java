/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CartDAO;
import dao.UserDAO;
import dao.WalletDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import model.Cart;
import model.CartItem;
import model.User;

/**
 *
 * @author ADMIN
 */
public class LoginController extends HttpServlet {

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
            out.println("<title>Servlet LoginController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoginController at " + request.getContextPath() + "</h1>");
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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //processRequest(request, response);
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // processRequest(request, response);
        // 1. Lấy dữ liệu từ form
        String email = request.getParameter("email");
        String pass = request.getParameter("password");

        // 2. Gọi DAO kiểm tra
        UserDAO dao = new UserDAO();
        User user = dao.login(email, pass);

        if (user == null) {
            // Đăng nhập thất bại
            request.setAttribute("message", "Sai tài khoản hoặc mật khẩu!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            // Đăng nhập thành công -> Lưu vào Session
            HttpSession session = request.getSession();
            session.setAttribute("account", user); // "account" là chìa khóa để lấy user sau này

            // 3. Phân quyền chuyển hướng
            List<String> roles = user.getRoles();

            CartDAO cdao = new CartDAO();
            Cart cart = cdao.getCartByUserId(user.getUserId());

            if (cart == null) {
                cdao.createCartForUserId(user.getUserId());
                cart = cdao.getCartByUserId(user.getUserId());
            }

            List<CartItem> cartItems = cdao.getCartItemsByCartId(cart.getCartId());
            Map<Integer, Map<String, Object>> productInfoMap = cdao.getProductInfoForCart(cartItems);

            BigDecimal subTotal = BigDecimal.ZERO;
            int totalQty = 0;

            for (CartItem i : cartItems) {
                subTotal = subTotal.add(
                        i.getUnitPrice().multiply(BigDecimal.valueOf(i.getQuantity()))
                );
                totalQty += i.getQuantity();
            }

            WalletDAO wDao = new WalletDAO();
            BigDecimal balance = wDao.getUserBallance(user.getUserId());

            session.setAttribute("balance", balance);
            session.setAttribute("cartTotalQuantity", totalQty);

            if (roles.contains("ADMIN")) {
                response.sendRedirect("admin/dashboard"); // Trang quản trị

            } else if (roles.contains("STAFF")) {
                response.sendRedirect("staff"); // Trang nhân viên
            } else {
                response.sendRedirect(request.getContextPath() + "/home"); // Trang khách hàng

            }
        }
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
