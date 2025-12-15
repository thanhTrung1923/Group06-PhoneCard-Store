package service;

import dao.admin.OrderDAO;
import dtos.OrderDetailDTO;
import dtos.OrderItemDTO;
import dtos.OrderListDTO;

import java.sql.Date;
import java.util.List;

public class OrderAdminService {

    private final OrderDAO dao = new OrderDAO();

    // ✅ Hàm mới có sort/dir
    public List<OrderListDTO> searchOrders(String status, String keyword,
                                           Date fromDate, Date toDate,
                                           String sort, String dir,
                                           int page, int pageSize) throws Exception {
        int safePage = Math.max(page, 1);
        int safeSize = Math.max(pageSize, 1);
        int offset = (safePage - 1) * safeSize;

        return dao.searchOrders(status, keyword, fromDate, toDate, sort, dir, offset, safeSize);
    }

    public int countOrders(String status, String keyword, Date fromDate, Date toDate) throws Exception {
        return dao.countOrders(status, keyword, fromDate, toDate);
    }

    public OrderDetailDTO getOrderDetail(long orderId) throws Exception {
        return dao.getOrderDetail(orderId);
    }

    public List<OrderItemDTO> getOrderItems(long orderId) throws Exception {
        return dao.getOrderItems(orderId);
    }

    public boolean updateOrderStatus(long orderId, String newStatus) throws Exception {
        return dao.updateOrderStatus(orderId, newStatus);
    }
}
