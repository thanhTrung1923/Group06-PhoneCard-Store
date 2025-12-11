package controller.admin;

import dao.admin.InventoryDAO;
import model.CardProductDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

// KHÔNG DÙNG @WebServlet VÌ ĐÃ CẤU HÌNH TRONG WEB.XML
public class InventoryListController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        // 1. Lấy tham số tìm kiếm từ URL (nếu có)
        String keyword = req.getParameter("keyword");
        String type = req.getParameter("type");
        String status = req.getParameter("status"); // Low/Out/OK

        // 2. Gọi DAO lấy dữ liệu
        InventoryDAO dao = new InventoryDAO();
        
        // Lấy thống kê (4 ô trên cùng)
        Map<String, Integer> stats = dao.getInventoryStats();
        
        // Lấy danh sách sản phẩm theo bộ lọc
        List<CardProductDTO> list = dao.getProductList(keyword, type, status);

        // 3. Đẩy dữ liệu sang JSP
        req.setAttribute("stats", stats);
        req.setAttribute("inventoryList", list);
        
        // Giữ lại giá trị filter để hiển thị lại trên thanh tìm kiếm
        req.setAttribute("filterKeyword", keyword);
        req.setAttribute("filterType", type);
        req.setAttribute("filterStatus", status);

        // 4. Forward về trang giao diện
        req.getRequestDispatcher("/views/admin/inventory-list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Nếu trang này chỉ xem thì doPost cũng gọi doGet
        doGet(req, resp);
    }
}