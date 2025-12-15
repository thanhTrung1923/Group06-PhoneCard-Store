/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CartDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
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
 * @author trung
 */
@WebServlet(name = "CartController", urlPatterns = {"/cart"})
public class CartController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/logout");
            return;
        }

        User user = (User) session.getAttribute("account");
        CartDAO dao = new CartDAO();
        Cart cart = dao.getCartByUserId(user.getUserId());

        // ================= ACTION =================
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");

        if (action != null && idStr != null && cart != null) {
            int productId = Integer.parseInt(idStr);
            long cartId = cart.getCartId();

            switch (action) {
                case "increase":
                    dao.increaseCartItemQuatity(cartId, productId, 1);
                    break;
                case "decrease":
                    CartItem ci = dao.getCartItemByCartIdAndProductId(cartId, productId);
                    if (ci != null && ci.getQuantity() <= 1) {
                        dao.deleteCartItem(cartId, productId);
                    } else {
                        dao.decreaseCartItemQuatity(cartId, productId, 1);
                    }
                    break;
                case "remove":
                    dao.deleteCartItem(cartId, productId);
                    break;
            }
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // ================= VIEW =================
        if (cart == null) {
            request.setAttribute("cartItems", null);
            request.setAttribute("cartSubTotal", BigDecimal.ZERO);
            request.getRequestDispatcher("/cart.jsp").forward(request, response);
            return;
        }

        List<CartItem> cartItems = dao.getCartItemsByCartId(cart.getCartId());
        Map<Integer, Map<String, Object>> productInfoMap
                = dao.getProductInfoForCart(cartItems);

        BigDecimal subTotal = BigDecimal.ZERO;
        int totalQty = 0;

        for (CartItem i : cartItems) {
            subTotal = subTotal.add(
                    i.getUnitPrice().multiply(BigDecimal.valueOf(i.getQuantity()))
            );
            totalQty += i.getQuantity();
        }

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("productInfoMap", productInfoMap);
        request.setAttribute("cartSubTotal", subTotal);
        session.setAttribute("cartTotalQuantity", totalQty);

        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            CartDAO cartDao = new CartDAO();
            HttpSession session = request.getSession(false);

            if (session == null) {
                response.sendRedirect(request.getContextPath() + "/logout");
                return;
            }

            User user = (User) session.getAttribute("account");

            String productIdStr = request.getParameter("productId");
            String quantityStr = request.getParameter("quantity");
            String maxQuantityStr = request.getParameter("maxQuantity");
            String stockQuantityStr = request.getParameter("stockQuantity");

            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/logout");
                return;
            }

            int userId = user.getUserId();
            boolean isCartExisted = cartDao.isCartExisted(userId);
            boolean cartCreated = false;
            Cart cart = null;

            if (!isCartExisted) {
                cartCreated = cartDao.createCartForUserId(userId);
            }

            cart = cartDao.getCartByUserId(userId);

            if (productIdStr == null || productIdStr.isBlank()
                    || quantityStr == null || quantityStr.isBlank()
                    || maxQuantityStr == null || maxQuantityStr.isBlank()
                    || stockQuantityStr == null || stockQuantityStr.isBlank()) {
                response.sendError(400, "Thiếu một hoặc nhiều tham số: quantity, productId, stockQuantity hoặc maxQuantity!");
                return;
            }

            long cartId = cart.getCartId();
            int productId = Integer.parseInt(productIdStr);
            int quantity = Integer.parseInt(quantityStr);
            int maxQuantity = Integer.parseInt(maxQuantityStr);
            int stockQuantity = Integer.parseInt(stockQuantityStr);

            if (productId < 0 || quantity < 0 || maxQuantity < 0 || stockQuantity < 0 || quantity > maxQuantity || quantity > stockQuantity) {
                response.sendError(400, "Lỗi có thể xảy ra: productId nhỏ hơn 0, quantity nhỏ hơn 0, stockQuantity nhỏ hơn 0, maxQuantity nhỏ hơn 0 hoặc quantity lớn hơn maxQuantity, quantity lớn hơn stockQuantity!");
                return;
            }

            boolean isItemExistedIncart = cartDao.isItemExistedInCart(cartId, productId);
            boolean ok = false;

            if (isItemExistedIncart) {
                boolean increaseSuccess = cartDao.increaseCartItemQuatity(cartId, productId, quantity);
                if (!increaseSuccess) {
                    response.sendError(500, "Có lỗi trong quá trình tăng số lượng sản phẩm lên!");
                    return;
                }
                ok = true;
            } else {
                BigDecimal unitPrice = cartDao.getProductFinalPrice(productId);
                boolean createItemSuccess
                        = cartDao.createItemForCart(cartId, productId, quantity, unitPrice);

                if (!createItemSuccess) {
                    response.sendError(500, "Có lỗi trong quá trình thêm sản phẩm vào giỏ hàng!");
                    return;
                }
                ok = true;
            }

            session.setAttribute("ok", ok);
            int totalQty = cartDao.getTotalQuantityByUserId(userId);
            session.setAttribute("cartTotalQuantity", totalQty);
            response.sendRedirect(request.getContextPath() + "/products/detail?productId=" + productId);
        } catch (NumberFormatException | IOException e) {
            response.sendError(500, "Có lỗi trong quá trình thêm sản phẩm vào giỏ hàng: " + e.getMessage());
        }
    }

}
