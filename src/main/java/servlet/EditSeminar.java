package servlet;

import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig; // Quan trọng
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
import java.time.LocalDateTime;
import java.util.List;

// 1. THÊM @MultipartConfig ĐỂ XỬ LÝ UPLOAD FILE VÀ FORM DATA
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
            int id = Integer.parseInt(request.getParameter("seminarId"));

            String name =  request.getParameter("seminarName");
            String speaker = request.getParameter("speaker");
            String location = request.getParameter("location");
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            int maxAttendance = Integer.parseInt(request.getParameter("maxAttendance"));

            String endDateString = request.getParameter("endDate");
            LocalDateTime endDate = LocalDateTime.parse(endDateString);

            String startDateString = request.getParameter("startDate");
            LocalDateTime startDate = LocalDateTime.parse(startDateString);

            String description = request.getParameter("description");

            Part imagePart = request.getPart("image");


            String imagePath = "";

            // Lấy thông tin cũ để giữ lại ảnh nếu không upload ảnh mới
            Seminar oldSeminar = seminarService.findById(id);
            if (oldSeminar != null) {
                imagePath = oldSeminar.getImage();
            }

            // Nếu có file mới được upload
            if (imagePart != null && imagePart.getSize() > 0 && imagePart.getSubmittedFileName() != null && !imagePart.getSubmittedFileName().isEmpty()) {
                    String appPath = FileUploadUtil.safeAppRealPath(getServletContext());
                    imagePath = FileUploadUtil.uploadImageReturnPath(imagePart, "images", appPath);
            }
            Seminar  seminar = new Seminar(id, name, description, startDate, endDate,
                    location, speaker, categoryId, maxAttendance, imagePath);

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