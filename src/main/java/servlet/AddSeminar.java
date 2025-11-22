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

@WebServlet("/add_seminar")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
        maxFileSize = 1024 * 1024 * 10,      // 10 MB
        maxRequestSize = 1024 * 1024 * 15    // 15 MB
)
public class AddSeminar extends HttpServlet {

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
        List<Category> categories = categoryService.findAll();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/add-seminar.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            request.setCharacterEncoding("UTF-8");

            String name = request.getParameter("seminarName");
            String speaker = request.getParameter("speaker");
            String location = request.getParameter("location");
            int category = Integer.parseInt(request.getParameter("categoryId"));
            int maxAttendance = Integer.parseInt(request.getParameter("maxAttendance"));
            String description = request.getParameter("description");

            // Xử lý ngày bắt đầu & kết thúc
            String endDateString = request.getParameter("endDate");
            LocalDateTime endDate = LocalDateTime.parse(endDateString);

            String startDateString = request.getParameter("startDate");
            LocalDateTime startDate = LocalDateTime.parse(startDateString);

            LocalDateTime now = LocalDateTime.now();

            if (startDate.isBefore(now)) {
                // Nếu ngày chọn NHỎ HƠN (sớm hơn) ngày hợp lệ
                throw new IllegalArgumentException("Ngày bắt đầu phải thời gian trong tương lai!");
            }

            if (endDate.isBefore(startDate)) {
                throw new IllegalArgumentException("Ngày kết thúc không được trước ngày bắt đầu!");
            }

            String registrationOpenString =  request.getParameter("registrationOpen");
            String registrationDeadlineString = request.getParameter("registrationDeadline");

            Timestamp registrationOpen = null;
            Timestamp registrationDeadline = null;

            if (registrationDeadlineString != null && !registrationDeadlineString.trim().isEmpty()) {
                String cleanDeadStr = registrationDeadlineString.replace("T", " ");
                if (cleanDeadStr.length() == 16) {
                    cleanDeadStr += ":00";
                }
                registrationDeadline = Timestamp.valueOf(cleanDeadStr);
            } else {
                registrationDeadline = Timestamp.valueOf(startDate);
            }

            if (registrationDeadline.after(Timestamp.valueOf(startDate))) {
                throw new IllegalArgumentException("Ngày đóng đăng ký phải trước ngày bắt đầu!");
            }

            if (registrationOpenString != null && !registrationOpenString.trim().isEmpty()) {
                String cleanOpenStr = registrationOpenString.replace("T", " ");
                if (cleanOpenStr.length() == 16) {
                    cleanOpenStr += ":00";
                }
                registrationOpen = Timestamp.valueOf(cleanOpenStr);
            } else {
                LocalDateTime idealOpenDate = startDate.minusDays(7);
                if (idealOpenDate.isAfter(now)) {
                    registrationOpen = Timestamp.valueOf(idealOpenDate);
                } else {
                    registrationOpen = Timestamp.valueOf(now);
                }
            }

            if (registrationOpen.after(registrationDeadline)) {
                throw new IllegalArgumentException("Ngày mở đăng ký phải trước hạn chót đăng ký!");
            }

//            Timestamp registrationOpen = null;
//            Timestamp registrationDeadline = null;
//            if (startDate != null && registrationOpen == null && registrationDeadline == null) {
//                //registrationDeadline = Timestamp.valueOf(startDate.minusDays(1));
//                registrationDeadline = Timestamp.valueOf(startDate);
//                //co ngay thoi gian thi mo dk trc 7 ngày, it thì mo ngay
//                LocalDateTime idealOpenDate = startDate.minusDays(7);
//                if (idealOpenDate.isAfter(now)) {
//                    registrationOpen = Timestamp.valueOf(idealOpenDate);
//                } else {
//                    registrationOpen = Timestamp.valueOf(now);
//                }
//            }

            // Xử lý ảnh
            Part imagePart = request.getPart("image");
            String imagePath = "";

            if (imagePart != null && imagePart.getSize() > 0 && imagePart.getSubmittedFileName() != null && !imagePart.getSubmittedFileName().isEmpty()) {
                String appPath = "C:/"; // Đường dẫn lưu ảnh
                imagePath = FileUploadUtil.uploadImageReturnPath(imagePart, "banner", appPath);
            }

            Seminar seminar = new Seminar(name, description, startDate, endDate,
                    location, speaker, category, maxAttendance, imagePath);

            seminar.setRegistrationOpen(registrationOpen);
            seminar.setRegistrationDeadline(registrationDeadline);

            seminarService.create(seminar);

            response.sendRedirect(request.getContextPath() + "/seminar_management?msg=add_success");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", e.getMessage());

            List<Category> categories = categoryService.findAll();
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("/add-seminar.jsp").forward(request, response);
        }
    }
}