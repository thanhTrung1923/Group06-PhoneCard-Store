package controller.admin;

import dao.admin.InventoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet; // Nếu dùng annotation
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import model.CardProductDTO;
import model.Supplier; // Nhớ import model Supplier

// @WebServlet("/admin/inventory") // Bỏ comment nếu dùng annotation
public class InventoryListController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        InventoryDAO dao = new InventoryDAO();

        // 1. Lấy dữ liệu thống kê & danh sách sản phẩm (Code cũ)
        String keyword = req.getParameter("keyword");
        String type = req.getParameter("type");
        String status = req.getParameter("status");
        
        Map<String, Integer> stats = dao.getInventoryStats();
        List<CardProductDTO> list = dao.getProductList(keyword, type, status);

        // 2. [MỚI] Lấy danh sách Supplier để hiển thị trong Modal Import
        // Modal nằm trên trang này nên dữ liệu dropdown phải có sẵn ở đây
        List<Supplier> suppliers = dao.getAllSuppliers(); 
        req.setAttribute("listSuppliers", suppliers);

        // 3. [MỚI] Nhận thông báo từ ImportController chuyển về (nếu có)
        String message = req.getParameter("message");
        String error = req.getParameter("error");
        
        // 4. Đẩy tất cả ra JSP
        req.setAttribute("stats", stats);
        req.setAttribute("inventoryList", list);
        req.setAttribute("message", message);
        req.setAttribute("error", error);
        
        // Giữ lại bộ lọc
        req.setAttribute("filterKeyword", keyword);
        req.setAttribute("filterType", type);
        req.setAttribute("filterStatus", status);

        req.getRequestDispatcher("/views/admin/inventory-list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}