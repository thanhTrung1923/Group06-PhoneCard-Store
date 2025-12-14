package service;

import dao.admin.OrderDAO;
import dtos.OrderListDTO;

import java.sql.Date;
import java.sql.SQLException;
import java.util.List;
import dtos.OrderDetailDTO;


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
    public OrderDetailDTO getOrderDetail(long orderId) throws SQLException {
    OrderDetailDTO detail = orderDAO.getOrderDetail(orderId);
    if (detail == null) return null;
    detail.setItems(orderDAO.getOrderItems(orderId));
    return detail;
}

public boolean updateOrderStatus(long orderId, String newStatus) throws SQLException {
    if (newStatus == null) return false;
    newStatus = newStatus.trim().toUpperCase();
    if (!newStatus.equals("PAID") && !newStatus.equals("CANCELLED") && !newStatus.equals("REFUNDED")) {
        throw new IllegalArgumentException("Invalid status: " + newStatus);
    }
    return orderDAO.updateOrderStatus(orderId, newStatus);
}

}
