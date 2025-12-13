package service;

import dao.admin.OrderDAO;
import dtos.OrderListDTO;

import java.sql.Date;
import java.sql.SQLException;
import java.util.List;

public class OrderAdminService {

    private final OrderDAO orderDAO = new OrderDAO();

    public List<OrderListDTO> searchOrders(String status, String keyword,
                                           Date fromDate, Date toDate,
                                           int page, int pageSize) throws SQLException {
        int safePage = Math.max(page, 1);
        int safePageSize = Math.max(1, Math.min(pageSize, 50));
        int offset = (safePage - 1) * safePageSize;
        return orderDAO.searchOrders(status, keyword, fromDate, toDate, offset, safePageSize);
    }

    public int countOrders(String status, String keyword, Date fromDate, Date toDate) throws SQLException {
        return orderDAO.countOrders(status, keyword, fromDate, toDate);
    }
}
