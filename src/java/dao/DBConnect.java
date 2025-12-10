package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnect {

    public static Connection getConnection() {
        Connection cons = null;
        try {
            // 1. Cấu hình các thông số kết nối
            // "jdbc:mysql://localhost:3306/ten_csdl"
            // Nếu dùng tiếng Việt có lỗi font, thêm đoạn ?useUnicode=true&characterEncoding=UTF-8 vào cuối URL
            String dbURL = "jdbc:mysql://localhost:3306/card_store"; 
            String userName = "root"; // Mặc định là root
            String password = "123456"; // Nhập pass bạn vừa tạo

            // 2. Nạp Driver (Dành cho MySQL 8.0 trở lên dùng com.mysql.cj.jdbc.Driver)
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 3. Tạo kết nối
            cons = DriverManager.getConnection(dbURL, userName, password);
            System.out.println("Kết nối thành công!");

        } catch (ClassNotFoundException e) {
            System.out.println("Lỗi: Không tìm thấy thư viện MySQL JDBC Driver!");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("Lỗi: Không thể kết nối đến Database (Sai URL, User hoặc Pass)!");
            e.printStackTrace();
        }
        return cons;
    }

    // Hàm main để chạy thử ngay lập tức xem có lỗi không
    public static void main(String[] args) {
        System.out.println("Đang kiểm tra kết nối...");
        getConnection();
    }
}