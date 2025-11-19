package utils;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import jakarta.activation.DataHandler;
import jakarta.activation.DataSource;

import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.util.Properties;

public class EmailUtil {

    public static void sendEmailWithAttachment(
            String toEmail,
            String subject,
            String body,
            byte[] qrBytes
    ) throws MessagingException, UnsupportedEncodingException {

        // THÔNG TIN EMAIL GỬI ĐI
        final String fromEmail = "nguyenhuyhoang260703@gmail.com";
        final String password = "yzde deek cyoy xkhr"; // Mật khẩu ứng dụng (App Password)

        // Cấu hình SMTP Gmail
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        // Đăng nhập
        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        });

        // Tạo đối tượng Email
        MimeMessage msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress(fromEmail, "ESD 2025 - Ban Tổ Chức")); // Tên người gửi hiển thị
        msg.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
        msg.setSubject(subject, "UTF-8");

        // Tạo nội dung Multipart (để chứa cả HTML và Ảnh)
        MimeMultipart multipart = new MimeMultipart("related");

        // 1. Phần Nội dung chữ (HTML)
        MimeBodyPart htmlPart = new MimeBodyPart();
        // Thẻ <img src='cid:qrImage'/> sẽ lấy ảnh từ phần đính kèm bên dưới
        htmlPart.setContent(
                body + "<br><br><div style='text-align:center;'><b>Mã QR Check-in của bạn:</b><br><img src='cid:qrImage' style='width:200px;'/></div>",
                "text/html; charset=UTF-8"
        );
        multipart.addBodyPart(htmlPart);

        // 2. Phần Ảnh QR (Inline Image)
        MimeBodyPart imagePart = new MimeBodyPart();

        // Tạo DataSource từ mảng byte[] của QR Code
        DataSource ds = new DataSource() {
            @Override
            public InputStream getInputStream() {
                return new java.io.ByteArrayInputStream(qrBytes);
            }

            @Override
            public OutputStream getOutputStream() {
                throw new UnsupportedOperationException("Not supported");
            }

            @Override
            public String getContentType() {
                return "image/png";
            }

            @Override
            public String getName() {
                return "qr.png";
            }
        };

        imagePart.setDataHandler(new DataHandler(ds));
        imagePart.setHeader("Content-ID", "<qrImage>"); // ID này khớp với cid:qrImage ở trên
        imagePart.setDisposition(MimeBodyPart.INLINE);

        multipart.addBodyPart(imagePart);

        // Gắn nội dung vào email và gửi
        msg.setContent(multipart);
        Transport.send(msg);
    }
}