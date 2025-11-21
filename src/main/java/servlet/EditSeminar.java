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
            request.setCharacterEncoding("UTF-8");
            int id = Integer.parseInt(request.getParameter("seminarId"));

            Seminar oldSeminar = seminarService.findById(id);
            if (oldSeminar == null) {
                throw new IllegalArgumentException("Không tìm thấy hội thảo có ID: " + id);
            }
            //Lấy ngày bắt đầu MỚI và kiểm tra Logic
            String startDateString = request.getParameter("startDate");
            LocalDateTime newStartDate = LocalDateTime.parse(startDateString);

            //Ngày mới không được sớm hơn ngày cũ
            if (newStartDate.isBefore(oldSeminar.getStart_date())) {
                String oldDateStr = oldSeminar.getStart_date().toString().replace("T", " ");
                throw new IllegalArgumentException("Ngày bắt đầu mới không được sớm hơn ngày cũ (" + oldDateStr + ")");
            }

            String name = request.getParameter("seminarName");
            String speaker = request.getParameter("speaker");
            String location = request.getParameter("location");
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            int maxAttendance = Integer.parseInt(request.getParameter("maxAttendance"));
            String description = request.getParameter("description");

            String endDateString = request.getParameter("endDate");
            LocalDateTime endDate = LocalDateTime.parse(endDateString);

            //Ngày kết thúc phải sau ngày bắt đầu
            if (endDate.isBefore(newStartDate)) {
                throw new IllegalArgumentException("Ngày kết thúc phải sau ngày bắt đầu!");
            }

            Timestamp registrationOpen = Timestamp.valueOf(newStartDate.minusDays(7));
            Timestamp registrationDeadline = Timestamp.valueOf(newStartDate.minusDays(1));

            Part imagePart = request.getPart("image");
            String imagePath = oldSeminar.getImage();

            // Kiểm tra nếu người dùng có upload ảnh mới
            if (imagePart != null && imagePart.getSize() > 0 && imagePart.getSubmittedFileName() != null && !imagePart.getSubmittedFileName().isEmpty()) {
                String appPath = "C:/";
                imagePath = FileUploadUtil.uploadImageReturnPath(imagePart, "banner", appPath);
            }
            Seminar seminar = new Seminar( id, name, description, newStartDate, endDate, location, speaker,
                    categoryId, maxAttendance, imagePath, registrationOpen, registrationDeadline);

            if (seminarService.update(seminar)) {
                response.sendRedirect(request.getContextPath() + "/seminar_management?msg=success");
            } else {
                throw new Exception("Lỗi khi cập nhật vào Database.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi: " + e.getMessage());
            try {
                int id = Integer.parseInt(request.getParameter("seminarId"));
                Seminar currentSeminar = seminarService.findById(id);
                request.setAttribute("seminar", currentSeminar);
                request.setAttribute("categories", categoryService.findAll());
            } catch (Exception ex) {

            }
            request.getRequestDispatcher("/edit-seminar.jsp").forward(request, response);
        }
    }
}