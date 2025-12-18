package dao.admin;

import dao.DBConnect;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

public class DashboardDAO {

    public Map<String, Object> getDashboardMetrics() {
        Map<String, Object> metrics = new HashMap<>();
        
        // Giá trị mặc định (Mock data cho các module của thành viên khác)
        metrics.put("revenueToday", 1500000.0);
        metrics.put("pendingOrders", 5);
        metrics.put("totalUsers", 120);
        metrics.put("lowStock", 0); // Sẽ lấy thật ở dưới

        Connection conn = DBConnect.getConnection();
        try {
            // 1. LẤY SỐ LIỆU TỒN KHO THỰC TẾ (Module của bạn)
            // Đếm số sản phẩm có lượng tồn kho thực tế <= min_stock_alert
            String sqlLowStock = "SELECT COUNT(*) FROM card_products p " +
                                 "WHERE (SELECT COUNT(*) FROM cards c WHERE c.product_id = p.product_id AND c.status = 'IN_STOCK') <= p.min_stock_alert " +
                                 "AND p.is_active = 1";
            
            try (PreparedStatement ps = conn.prepareStatement(sqlLowStock);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    metrics.put("lowStock", rs.getInt(1));
                }
            }

            // 2. LẤY DOANH THU (Giả lập truy vấn bảng orders - Bạn có thể mở comment khi ghép code nhóm)
            /*
            String sqlRevenue = "SELECT SUM(total_money) FROM orders WHERE CAST(order_date AS DATE) = CAST(GETDATE() AS DATE)";
            try (PreparedStatement ps = conn.prepareStatement(sqlRevenue); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) metrics.put("revenueToday", rs.getDouble(1));
            }
            */
            
            // 3. LẤY ĐƠN HÀNG CHỜ (Giả lập)
            /*
            String sqlOrders = "SELECT COUNT(*) FROM orders WHERE status = 0"; // 0: Pending
            try (PreparedStatement ps = conn.prepareStatement(sqlOrders); ResultSet rs = ps.executeQuery()) {
                if (rs.next()) metrics.put("pendingOrders", rs.getInt(1));
            }
            */

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(conn != null) conn.close(); } catch(Exception e) {}
        }
        
        return metrics;
    }
}