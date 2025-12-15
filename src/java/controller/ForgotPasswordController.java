package controller;

import dao.UserDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import ulti.EmailUtil;

@WebServlet(name = "ForgotPasswordController", urlPatterns = "/forgot-password")
public class ForgotPasswordController extends HttpServlet {
// in-memory store token->email for demo. In prod save to table reset_tokens with expiry

    private static final Map<String, String> tokens = new HashMap<>();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("forgot-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
      String rawEmail = req.getParameter("email");
        String email = (rawEmail != null) ? rawEmail.trim() : "";

        System.out.println("========== DEBUG FORGOT PASSWORD ==========");
        System.out.println("1. Email nhận được từ Form: [" + email + "]");

        if (email.isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập email.");
            req.getRequestDispatcher("forgot-password.jsp").forward(req, resp);
            return;
        }

        // 2. Gọi DAO
        UserDAO dao = new UserDAO();
        System.out.println("2. Đang gọi DAO để tìm user...");
        User u = dao.getUserByEmail(email);

        // 3. Kiểm tra kết quả
        if (u == null) {
            System.out.println("❌ KẾT QUẢ: User bị NULL.");
            System.out.println("-> Khả năng 1: Email sai hoặc chưa có trong DB.");
            System.out.println("-> Khả năng 2: Kết nối DB lỗi (Check file DBContext).");
            System.out.println("-> Khả năng 3: Tên cột trong UserDAO không khớp DB.");
            
            req.setAttribute("error", "Không tìm thấy email: " + email);
            req.getRequestDispatcher("forgot-password.jsp").forward(req, resp);
            return;
        }

        System.out.println("✅ KẾT QUẢ: Đã tìm thấy User ID: " + u.getUserId());
        String token = UUID.randomUUID().toString();
        tokens.put(token, email);
        String link = req.getRequestURL().toString().replace(req.getRequestURI(), req.getContextPath()) + "/reset-password?token=" + token;

        String html = "<p>Xin chào " + u.getFullName() + ",</p>"
                + "<p>Click để đặt lại mật khẩu: <a href='" + link + "' target='_blank'>Reset password</a></p>"
                + "<p>Nếu bạn không yêu cầu, hãy bỏ qua email này.</p>";

        boolean sent = EmailUtil.send(email, "Yêu cầu đặt lại mật khẩu", html);
        if (sent) {
            req.setAttribute("message", "Đã gửi email. Vui lòng kiểm tra hộp thư.");
        } else {
            req.setAttribute("error", "Gửi email thất bại (check SMTP)");
        }
        req.getRequestDispatcher("forgot-password.jsp").forward(req, resp);
    }

    public static String getEmailByToken(String token) {
        return tokens.get(token);
    }

    public static void removeToken(String token) {
        tokens.remove(token);
    }
}
