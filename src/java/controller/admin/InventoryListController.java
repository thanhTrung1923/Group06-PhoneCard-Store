package controller.admin;

import dao.admin.InventoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import model.CardProductDTO;
import model.Supplier; 

public class InventoryListController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        InventoryDAO dao = new InventoryDAO();

        String keyword = req.getParameter("keyword");
        String type = req.getParameter("type");
        String status = req.getParameter("status");
        
        Map<String, Integer> stats = dao.getInventoryStats();
        List<CardProductDTO> list = dao.getProductList(keyword, type, status);
        
        List<Supplier> suppliers = dao.getAllSuppliers(); 
        req.setAttribute("listSuppliers", suppliers);

        String message = req.getParameter("message");
        String error = req.getParameter("error");
        
        req.setAttribute("stats", stats);
        req.setAttribute("inventoryList", list);
        req.setAttribute("message", message);
        req.setAttribute("error", error);

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