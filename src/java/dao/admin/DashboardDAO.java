package dao.admin;

import dao.DBConnect;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DashboardDAO {

    public Map<String, Object> getDashboardMetrics() {
        Map<String, Object> metrics = new HashMap<>();
        
        // Giá trị mặc định
        metrics.put("revenueToday", 0.0);
        metrics.put("pendingOrders", 0); // Thực tế là Pending Deposit Requests
        metrics.put("totalUsers", 0);
        metrics.put("lowStock", 0);
        
        // Dữ liệu cho biểu đồ
        metrics.put("chartLabels", "[]"); 
        metrics.put("chartData", "[]");

        try (Connection conn = DBConnect.getConnection()) {
            if (conn == null) return metrics;

            // ---------------------------------------------------------
            // 1. DOANH THU HÔM NAY (Bảng orders, status = PAID)
            // ---------------------------------------------------------
            String sqlRevenue = "SELECT COALESCE(SUM(total_amount), 0) FROM orders " +
                                "WHERE status = 'PAID' AND CAST(paid_at AS DATE) = CAST(CURRENT_DATE() AS DATE)";
            try (PreparedStatement ps = conn.prepareStatement(sqlRevenue);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    metrics.put("revenueToday", rs.getDouble(1));
                }
            }

            // ---------------------------------------------------------
            // 2. YÊU CẦU CẦN XỬ LÝ (Bảng deposit_requests, status = PENDING)
            // Note: Bảng orders không có PENDING, nên ta đếm yêu cầu nạp tiền chờ duyệt
            // ---------------------------------------------------------
            String sqlPending = "SELECT COUNT(*) FROM deposit_requests WHERE status = 'PENDING'";
            try (PreparedStatement ps = conn.prepareStatement(sqlPending);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    metrics.put("pendingOrders", rs.getInt(1));
                }
            }

            // ---------------------------------------------------------
            // 3. TỔNG SỐ KHÁCH HÀNG (Role = CUSTOMER)
            // ---------------------------------------------------------
            String sqlUsers = "SELECT COUNT(DISTINCT u.user_id) FROM users u " +
                              "JOIN user_roles ur ON u.user_id = ur.user_id " +
                              "JOIN roles r ON ur.role_id = r.role_id " +
                              "WHERE r.role_name = 'CUSTOMER'";
            try (PreparedStatement ps = conn.prepareStatement(sqlUsers);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    metrics.put("totalUsers", rs.getInt(1));
                }
            }

            // ---------------------------------------------------------
            // 4. SẢN PHẨM SẮP HẾT (Logic kho thực tế)
            // ---------------------------------------------------------
            String sqlLowStock = "SELECT COUNT(*) FROM card_products p " +
                                 "WHERE (SELECT COUNT(*) FROM cards c WHERE c.product_id = p.product_id AND c.status = 'IN_STOCK') <= p.min_stock_alert " +
                                 "AND p.is_active = 1";
            try (PreparedStatement ps = conn.prepareStatement(sqlLowStock);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    metrics.put("lowStock", rs.getInt(1));
                }
            }
            
            // ---------------------------------------------------------
            // 5. DỮ LIỆU BIỂU ĐỒ (7 NGÀY GẦN NHẤT)
            // ---------------------------------------------------------
            prepareChartData(conn, metrics);

        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return metrics;
    }

    // Hàm phụ trợ lấy dữ liệu biểu đồ
    private void prepareChartData(Connection conn, Map<String, Object> metrics) {
        List<String> labels = new ArrayList<>();
        List<Double> data = new ArrayList<>();
        
        // Tạo map để lưu doanh thu từng ngày
        Map<String, Double> revenueMap = new HashMap<>();
        
        String sqlChart = "SELECT DATE(paid_at) as pay_date, SUM(total_amount) as total " +
                          "FROM orders " +
                          "WHERE status = 'PAID' AND paid_at >= DATE(NOW()) - INTERVAL 6 DAY " +
                          "GROUP BY DATE(paid_at)";
        
        try (PreparedStatement ps = conn.prepareStatement(sqlChart);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                revenueMap.put(rs.getString("pay_date"), rs.getDouble("total"));
            }
        } catch (Exception e) { e.printStackTrace(); }

        // Duyệt 7 ngày gần nhất (để ngày nào không có doanh thu thì hiện 0)
        DateTimeFormatter dbFormat = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        DateTimeFormatter displayFormat = DateTimeFormatter.ofPattern("dd/MM");
        
        LocalDate today = LocalDate.now();
        for (int i = 6; i >= 0; i--) {
            LocalDate d = today.minusDays(i);
            String key = d.format(dbFormat);
            
            labels.add("'" + d.format(displayFormat) + "'"); // Format cho JS Array: '12/12'
            data.add(revenueMap.getOrDefault(key, 0.0));
        }

        metrics.put("chartLabels", labels.toString()); // "[ '12/12', '13/12', ... ]"
        metrics.put("chartData", data.toString());     // "[ 100000.0, 0.0, ... ]"
    }
}