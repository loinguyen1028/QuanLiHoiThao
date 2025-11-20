package servlet;

import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.Category;
import model.Seminar;
import service.CategoryService;
import service.SeminarService;
import serviceImpl.CategoryServiceImpl;
import serviceImpl.SeminarServiceImpl;
import utils.DataSourceUtil;
import utils.FileUploadUtil;

import javax.sql.DataSource;
import java.io.IOException;
import java.sql.Timestamp; 
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/edit_seminar")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
        maxFileSize = 1024 * 1024 * 10,      // 10 MB
        maxRequestSize = 1024 * 1024 * 15    // 15 MB
)
public class EditSeminar extends HttpServlet {

    private SeminarService seminarService;
    private CategoryService categoryService;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        DataSource ds = DataSourceUtil.getDataSource();
        seminarService = new SeminarServiceImpl(ds);
        categoryService = new CategoryServiceImpl(ds);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String idStr = request.getParameter("id");
            if (idStr == null || idStr.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/seminar_management");
                return;
            }
            int id = Integer.parseInt(idStr);
            Seminar seminar = seminarService.findById(id);

            if (seminar == null) {
                response.sendRedirect(request.getContextPath() + "/seminar_management?error=notfound");
                return;
            }

            List<Category> categories = categoryService.findAll();

            request.setAttribute("seminar", seminar);
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("/edit-seminar.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/seminar_management?error=invalid_id");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            request.setCharacterEncoding("UTF-8"); // Đảm bảo không lỗi font tiếng Việt

            int id = Integer.parseInt(request.getParameter("seminarId"));

            // 1. Lấy thông tin cơ bản
            String name = request.getParameter("seminarName");
            String speaker = request.getParameter("speaker");
            String location = request.getParameter("location");
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            int maxAttendance = Integer.parseInt(request.getParameter("maxAttendance"));
            String description = request.getParameter("description");

            // Lấy status (nếu form edit có cho sửa status, nếu không thì giữ nguyên logic bên dưới)
            String status = request.getParameter("status");

            // 2. Xử lý ngày bắt đầu - kết thúc (LocalDateTime)
            String endDateString = request.getParameter("endDate");
            LocalDateTime endDate = (endDateString != null && !endDateString.isEmpty())
                    ? LocalDateTime.parse(endDateString) : null;

            String startDateString = request.getParameter("startDate");
            LocalDateTime startDate = (startDateString != null && !startDateString.isEmpty())
                    ? LocalDateTime.parse(startDateString) : null;

            // 3. [MỚI] Xử lý ngày mở đăng ký - hạn chót (Timestamp)
            String regOpenStr = request.getParameter("registrationOpen");
            String regDeadlineStr = request.getParameter("registrationDeadline");

            Timestamp registrationOpen = null;
            Timestamp registrationDeadline = null;

            if (regOpenStr != null && !regOpenStr.isEmpty()) {
                // LocalDateTime.parse hiểu định dạng "yyyy-MM-ddTHH:mm" của input type="datetime-local"
                registrationOpen = Timestamp.valueOf(LocalDateTime.parse(regOpenStr));
            }

            if (regDeadlineStr != null && !regDeadlineStr.isEmpty()) {
                registrationDeadline = Timestamp.valueOf(LocalDateTime.parse(regDeadlineStr));
            }

            // 4. Xử lý ảnh (Upload hoặc giữ ảnh cũ)
            Part imagePart = request.getPart("image");

            String status = "Đang mở đăng kí";

            String imagePath = "";

            // Lấy thông tin cũ để giữ lại ảnh và status (nếu form không gửi status)
            Seminar oldSeminar = seminarService.findById(id);
            if (oldSeminar != null) {
                imagePath = oldSeminar.getImage();
                if (status == null) {
                    status = oldSeminar.getStatus(); // Giữ status cũ nếu form không gửi
                }
            }

            // Nếu có file mới được upload
            if (imagePart != null && imagePart.getSize() > 0 && imagePart.getSubmittedFileName() != null && !imagePart.getSubmittedFileName().isEmpty()) {
                // String appPath = FileUploadUtil.safeAppRealPath(getServletContext());
                String appPath = "D:/"; // Đường dẫn lưu ảnh của bạn
                imagePath = FileUploadUtil.uploadImageReturnPath(imagePart, "banner", appPath);

            Seminar  seminar = new Seminar(id, name, description, startDate, endDate,
                    location, speaker, categoryId, maxAttendance, imagePath, status);

            // 5. Tạo đối tượng Seminar với Constructor ĐẦY ĐỦ
            // Thứ tự tham số phải khớp với Constructor trong model/Seminar.java
            Seminar seminar = new Seminar(
                    id,
                    name,
                    description,
                    startDate,
                    endDate,
                    location,
                    speaker,
                    categoryId,
                    maxAttendance,
                    imagePath,
                    status,
                    registrationOpen,
                    registrationDeadline
            );

            // 6. Gọi Service update
            if (seminarService.update(seminar)) {
                response.sendRedirect(request.getContextPath() + "/seminar_management?msg=success");
            } else {
                request.setAttribute("error", "Cập nhật thất bại");
                request.setAttribute("seminar", seminar);
                request.setAttribute("categories", categoryService.findAll());
                request.getRequestDispatcher("/edit-seminar.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/seminar_management?error=exception");
        }
    }
}