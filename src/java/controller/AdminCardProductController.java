/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import model.CardProduct;
import service.CardProductService; // Import Service thay vì DAO
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "AdminCardProductController", urlPatterns = {"/admin-products"})
public class AdminCardProductController extends HttpServlet {

    // Khai báo Service thay vì DAO
    private final CardProductService service = new CardProductService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "create":
                request.getRequestDispatcher("product-management-form.jsp").forward(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteProduct(request, response);
                break;
            default:
                listProducts(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        // Nhớ set encoding để nhận tiếng Việt không bị lỗi font
        request.setCharacterEncoding("UTF-8");

        switch (action) {
            case "insert":
                insertProduct(request, response);
                break;
            case "update":
                updateProduct(request, response);
                break;
            default:
                listProducts(request, response);
                break;
        }
    }

    private void listProducts(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String typeCode = request.getParameter("typeCode");
    String order = request.getParameter("typeOrder");

    Long value = null;
    if (request.getParameter("value") != null && !request.getParameter("value").isBlank()) {
        value = Long.parseLong(request.getParameter("value"));
    }

    List<CardProduct> list;

    // Lần đầu vào
    if ((typeCode == null || typeCode.isBlank()) && value == null) {
        list = service.getAllProducts();
    } 
    // Search
    else {
        list = service.searchProducts(typeCode, value, order);
    }

    request.setAttribute("products", list);
    request.setAttribute("valueList", service.getAvailableValues());

    request.getRequestDispatcher("product-management-list.jsp")
           .forward(request, response);
}


    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));

        // Gọi Service lấy chi tiết 1 sản phẩm
        CardProduct existingProduct = service.getProductById(id);

        request.setAttribute("product", existingProduct);
        request.getRequestDispatcher("product-management-form.jsp").forward(request, response);
    }

    private void insertProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        // Controller lo việc lấy dữ liệu từ request
        CardProduct p = extractProductFromRequest(request);

        // Gọi Service để lưu
        service.createProduct(p);

        response.sendRedirect("admin-products");
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        CardProduct p = extractProductFromRequest(request);
        p.setProductId(id); // Set ID để update đúng dòng

        // Gọi Service để update
        service.updateProduct(p);

        response.sendRedirect("admin-products");
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));

        // Gọi Service để xóa
        service.deleteProduct(id);

        response.sendRedirect("admin-products");
    }

    // Hàm phụ trợ: Giúp code gọn hơn, tránh lặp lại việc getParameter
    private CardProduct extractProductFromRequest(HttpServletRequest request) {
        String typeCode = request.getParameter("typeCode");
        String typeName = request.getParameter("typeName");
        long value = Long.parseLong(request.getParameter("value"));
        BigDecimal buyPrice = new BigDecimal(request.getParameter("buyPrice"));
        BigDecimal sellPrice = new BigDecimal(request.getParameter("sellPrice"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        int minStock = Integer.parseInt(request.getParameter("minStock"));
        String imgUrl = request.getParameter("imgUrl");
        String description = request.getParameter("description");
        boolean isActive = request.getParameter("active") != null;

        CardProduct p = new CardProduct();
        p.setTypeCode(typeCode);
        p.setTypeName(typeName);
        p.setValue(value);
        p.setBuyPrice(buyPrice);
        p.setSellPrice(sellPrice);
        p.setQuantity(quantity);
        p.setMinStockAlert(minStock);
        p.setImgUrl(imgUrl);
        p.setThumbnailUrl(imgUrl);
        p.setDescription(description);
        p.setIsActive(isActive);
        p.setAllowDiscount(true);

        return p;
    }
}
