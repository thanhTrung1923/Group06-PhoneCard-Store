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