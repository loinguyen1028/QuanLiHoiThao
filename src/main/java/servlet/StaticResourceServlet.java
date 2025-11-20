package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.net.URLDecoder;

// Servlet này sẽ bắt tất cả request bắt đầu bằng /static/
@WebServlet(name = "StaticResourceServlet", urlPatterns = {"/static/*"})
public class StaticResourceServlet extends HttpServlet {

    // Đường dẫn gốc nơi bạn lưu file (phải khớp với UploadImageServlet)
    private static final String BASE_DIR = "D:/img";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Lấy phần đường dẫn sau /static (ví dụ: /ck4/anh.jpg)
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Decode URL (để xử lý tên file có dấu hoặc ký tự đặc biệt)
        String decodedPath = URLDecoder.decode(pathInfo, "UTF-8");

        // 2. Tạo đối tượng File trỏ tới ổ đĩa thật
        File file = new File(BASE_DIR, decodedPath);

        // 3. Kiểm tra file có tồn tại không
        if (!file.exists() || !file.isFile()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND); // Trả về 404 nếu không thấy file
            return;
        }

        // 4. Thiết lập Content-Type (MIME type) tự động dựa trên đuôi file
        String contentType = getServletContext().getMimeType(file.getName());
        if (contentType == null) {
            contentType = "application/octet-stream";
        }
        response.setContentType(contentType);
        response.setContentLengthLong(file.length());

        // 5. Copy dữ liệu từ file vào luồng phản hồi (Response Output Stream)
        Files.copy(file.toPath(), response.getOutputStream());
    }
}