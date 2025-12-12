package ulti;


import java.util.Properties;
// ĐỔI HẾT 'javax' THÀNH 'jakarta'
import jakarta.mail.*;
import jakarta.mail.internet.*;


// --------------------------------------

public class EmailUtil {

    // Lưu ý: Với Gmail, bạn cần dùng "App Password" chứ không phải mật khẩu đăng nhập thường
    private static final String SMTP_HOST = "smtp.gmail.com"; 
    private static final String SMTP_USER = "anhlhhe153263@fpt.edu.vn"; 
    private static final String SMTP_PASS = "@Huyanh2001"; 
    private static final String SMTP_PORT = "587"; // Cổng TLS thường là 587

    public static boolean send(String to, String subject, String htmlContent) {
        try {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            // Thêm dòng này để fix lỗi SSL nếu gặp trên Java mới
            props.put("mail.smtp.ssl.protocols", "TLSv1.2"); 
            props.put("mail.smtp.ssl.trust", SMTP_HOST);

            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(SMTP_USER, SMTP_PASS);
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SMTP_USER));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setContent(htmlContent, "text/html; charset=UTF-8");

            Transport.send(message);
            System.out.println("Email sent successfully!");
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}