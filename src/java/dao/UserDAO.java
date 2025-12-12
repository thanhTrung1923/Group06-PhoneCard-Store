package dao;

import dao.DBConnect;
import java.sql.Statement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import static java.util.Collections.list;
import java.util.List;
import model.User;

public class UserDAO extends DBConnect {

    // Hàm lấy tất cả user (Code cũ của bạn, mình sửa lại cho đúng bảng)
    public List<User> getAllUser() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users"; // Nhớ là bảng 'users' số nhiều
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setEmail(rs.getString("email"));
                u.setFullName(rs.getString("full_name"));
                // ... map các trường khác
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Hàm LOGIN: Kiểm tra user và lấy luôn Role
     *
     * @param email
     * @param password
     * @return User object nếu thành công (kèm roles), null nếu thất bại
     */
    public User login(String email, String password) {
        User user = null;

        // 1. Kiểm tra đăng nhập cơ bản
        // Lưu ý: Thực tế password nên được mã hóa (MD5/BCrypt), ở đây mình so sánh string thuần cho bài tập
        String sqlUser = "SELECT * FROM users WHERE email = ? AND password_hash = ? AND is_locked = 0";

        // 2. Câu lệnh lấy Roles của user đó
        String sqlRoles = "SELECT r.role_name FROM roles r "
                + "JOIN user_roles ur ON r.role_id = ur.role_id "
                + "WHERE ur.user_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sqlUser)) {

            ps.setString(1, email);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setEmail(rs.getString("email"));
                    user.setFullName(rs.getString("full_name"));
                    user.setIsLocked(rs.getBoolean("is_locked"));
                    // Map thêm các trường khác nếu cần...

                    // --- BƯỚC 2: LẤY DANH SÁCH ROLE ---
                    // Dùng user_id vừa lấy được để tìm role
                    PreparedStatement psRole = conn.prepareStatement(sqlRoles);
                    psRole.setInt(1, user.getUserId());
                    ResultSet rsRole = psRole.executeQuery();

                    while (rsRole.next()) {
                        String roleName = rsRole.getString("role_name");
                        user.addRole(roleName); // Thêm role vào list trong User
                    }
                    // Đóng resource con
                    rsRole.close();
                    psRole.close();
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi login: " + e.getMessage());
            e.printStackTrace();
        }
        return user;
    }

    public boolean register(User user) {
        String sqlAddUser = "INSERT INTO users (email, password_hash, full_name, phone, is_locked) VALUES (?, ?, ?, ?, 0)";
        String sqlAddRole = "INSERT INTO user_roles (user_id, role_id) VALUES (?, (SELECT role_id FROM roles WHERE role_name = 'CUSTOMER'))";

        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);

            int newUserId = 0;

            // Insert user
            try (PreparedStatement psUser = conn.prepareStatement(sqlAddUser, Statement.RETURN_GENERATED_KEYS)) {
                psUser.setString(1, user.getEmail());
                psUser.setString(2, user.getPasswordHash());
                psUser.setString(3, user.getFullName());
                psUser.setString(4, user.getPhone());

                int rowAffected = psUser.executeUpdate();
                if (rowAffected == 0) {
                    throw new Exception("Insert user failed");
                }

                try (ResultSet rs = psUser.getGeneratedKeys()) {
                    if (rs.next()) {
                        newUserId = rs.getInt(1);
                    } else {
                        throw new Exception("Cannot get generated user ID");
                    }
                }
            }

            // Insert role
            try (PreparedStatement psRole = conn.prepareStatement(sqlAddRole)) {
                psRole.setInt(1, newUserId);
                psRole.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public User getUserByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = mapRowToUser(rs);
// load roles
                    loadRoles(conn, u);
                    return u;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public User getUserById(int id) {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = mapRowToUser(rs);
                    loadRoles(conn, u);
                    return u;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private User mapRowToUser(ResultSet rs) throws Exception {
        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setEmail(rs.getString("email"));
        u.setPhone(rs.getString("phone"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setFullName(rs.getString("full_name"));
        u.setAvatarUrl(rs.getString("avatar_url"));
        u.setIsLocked(rs.getBoolean("is_locked"));
        return u;
    }

    private void loadRoles(Connection conn, User u) throws Exception {
        String sqlRoles = "SELECT r.role_name FROM roles r JOIN user_roles ur ON r.role_id = ur.role_id WHERE ur.user_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sqlRoles)) {
            ps.setInt(1, u.getUserId());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    u.addRole(rs.getString("role_name"));
                }
            }
        }
    }

    public boolean updateProfile(int userId, String fullName, String phone, String avatarUrl) {
        String sql = "UPDATE users SET full_name = ?, phone = ?, avatar_url = ?, updated_at = NOW() WHERE user_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fullName);
            ps.setString(2, phone);
            ps.setString(3, avatarUrl);
            ps.setInt(4, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updatePassword(int userId, String newHash) {
        String sql = "UPDATE users SET password_hash = ?, updated_at = NOW() WHERE user_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newHash);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<User> getUsers(int offset, int limit, String q) {
        ArrayList<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users " + (q != null && !q.isEmpty() ? "WHERE email LIKE ? OR full_name LIKE ? " : "") + "ORDER BY user_id DESC LIMIT ? OFFSET ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            if (q != null && !q.isEmpty()) {
                ps.setString(idx++, "%" + q + "%");
                ps.setString(idx++, "%" + q + "%");
            }
            ps.setInt(idx++, limit);
            ps.setInt(idx++, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User u = mapRowToUser(rs);
                    loadRoles(conn, u);
                    list.add(u);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

// admin: create or update user (without registering role logic)
    public int createUserByAdmin(User u, String roleName) throws Exception {
        String sqlUser = "INSERT INTO users (email, password_hash, full_name, phone, is_locked) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            int newId = 0;
            try (PreparedStatement ps = conn.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, u.getEmail());
                ps.setString(2, u.getPasswordHash());
                ps.setString(3, u.getFullName());
                ps.setString(4, u.getPhone());
                ps.setBoolean(5, u.getIsLocked());
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        newId = rs.getInt(1);
                    }
                }
            }
// assign role
            try (PreparedStatement psr = conn.prepareStatement("INSERT INTO user_roles (user_id, role_id) VALUES (?, (SELECT role_id FROM roles WHERE role_name = ?))")) {
                psr.setInt(1, newId);
                psr.setString(2, roleName);
                psr.executeUpdate();
            }
            conn.commit();
            return newId;
        }
    }

    public boolean updateUserByAdmin(User u, String roleName) throws Exception {
        String sql = "UPDATE users SET full_name=?, phone=?, is_locked=?, avatar_url=?, updated_at=NOW() WHERE user_id=?";
        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, u.getFullName());
                ps.setString(2, u.getPhone());
                ps.setBoolean(3, u.getIsLocked());
                ps.setString(4, u.getAvatarUrl());
                ps.setInt(5, u.getUserId());
                ps.executeUpdate();
            }
// update role: delete existing, add new (simple)
            try (PreparedStatement psd = conn.prepareStatement("DELETE FROM user_roles WHERE user_id=?")) {
                psd.setInt(1, u.getUserId());
                psd.executeUpdate();
            }
            try (PreparedStatement psr = conn.prepareStatement("INSERT INTO user_roles (user_id, role_id) VALUES (?, (SELECT role_id FROM roles WHERE role_name = ?))")) {
                psr.setInt(1, u.getUserId());
                psr.setString(2, roleName);
                psr.executeUpdate();
            }
            conn.commit();
            return true;
        }
    }
}
