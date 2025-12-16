package controller;

import dao.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import ulti.PasswordUtil; // <--- NHỚ IMPORT CÁI NÀY

public class RegisterController extends HttpServlet {

    // ... (Giữ nguyên phần processRequest và doGet) ...
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 1. Lấy dữ liệu từ form
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String pass = request.getParameter("password");
        String confirmPass = request.getParameter("confirmPassword");
        if (fullName == null) {
            request.setAttribute("error", "Tên không được để trống");
            request.setAttribute("fullName", fullName);
            request.setAttribute("phone", phone);
            request.setAttribute("email", email);
            request.setAttribute("confirmPassword", confirmPass);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        if (fullName.length() > 50) {
            request.setAttribute("error", "Họ tên phải <= 50 kí tự");
            request.setAttribute("fullName", fullName);
            request.setAttribute("phone", phone);
            request.setAttribute("email", email);
            request.setAttribute("confirmPassword", confirmPass);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        if (phone != null) {
            phone = phone.trim();
        }
        if (phone == null || phone.trim().isEmpty()) {
            request.setAttribute("error", "Số điện thoại không được để trống");
            request.setAttribute("fullName", fullName);
            request.setAttribute("phone", phone);
            request.setAttribute("email", email);
            request.setAttribute("confirmPassword", confirmPass);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        String regex = "^0\\d{9}$";
        if (!phone.matches(regex)) {
            request.setAttribute("error", "Số điện thoại phải có 10 chữ số");
            request.setAttribute("fullName", fullName);
            request.setAttribute("phone", phone);
            request.setAttribute("email", email);
            request.setAttribute("confirmPassword", confirmPass);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (confirmPass == null) {
            request.setAttribute("error", "Số điện thoại phải có 10 chữ số");
            request.setAttribute("fullName", fullName);
            request.setAttribute("phone", phone);
            request.setAttribute("email", email);
            request.setAttribute("confirmPassword", confirmPass);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        if (pass == null || pass.length() < 6) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự");
            request.setAttribute("fullName", fullName);
            request.setAttribute("phone", phone);
            request.setAttribute("email", email);
            request.setAttribute("confirmPassword", confirmPass);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        // --- VALIDATE DỮ LIỆU ---
        // 2. Kiểm tra mật khẩu xác nhận
        if (!pass.equals(confirmPass)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            // Giữ lại thông tin cũ để người dùng đỡ phải nhập lại
            request.setAttribute("fullName", fullName);
            request.setAttribute("phone", phone);
            request.setAttribute("email", email);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        UserDAO dao = new UserDAO();

        // 3. Kiểm tra Email đã tồn tại chưa (Rất quan trọng)
        if (email == null) {
            request.setAttribute("error", "Số điện thoại không được để trống");
            request.setAttribute("fullName", fullName);
            request.setAttribute("phone", phone);
            request.setAttribute("email", email);
            request.setAttribute("confirmPassword", confirmPass);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        User existingUser = dao.getUserByEmail(email);
        if (existingUser != null) {
            request.setAttribute("error", "Email này đã được sử dụng!");
            request.setAttribute("fullName", fullName);
            request.setAttribute("phone", phone);
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // --- XỬ LÝ ĐĂNG KÝ ---
        // 4. Tạo đối tượng User
        User u = new User();
        u.setFullName(fullName);
        u.setPhone(phone);
        u.setEmail(email);

        // 5. MÃ HÓA MẬT KHẨU TẠI ĐÂY
        String hashedPassword = PasswordUtil.hash(pass);
        u.setPasswordHash(hashedPassword); // Lưu password đã mã hóa

        // 6. Gọi DAO để lưu vào DB
        boolean isSuccess = dao.register(u);

        if (isSuccess) {
            // Thành công -> Chuyển sang login với thông báo
            request.setAttribute("message", "Đăng ký thành công! Vui lòng đăng nhập.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            // Thất bại (Lỗi DB...)
            request.setAttribute("error", "Đăng ký thất bại! Vui lòng thử lại sau.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Register Controller";
    }
}
