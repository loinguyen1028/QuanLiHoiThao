package servlet;

import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Category; // Import model Category
import model.Register;
import model.Seminar;
import service.CategoryService; // Import CategoryService
import service.RegisterService;
import service.SeminarService;
import serviceImpl.CategoryServiceImpl; // Import Impl
import serviceImpl.RegisterServiceImpl;
import serviceImpl.SeminarServiceImpl;
import utils.DataSourceUtil;

import javax.sql.DataSource;
import java.io.IOException;
import java.util.List;

@WebServlet("/list-user")
public class ListSeminarServlet extends HttpServlet {

    private RegisterService registerService;
    private SeminarService seminarService;
    private CategoryService categoryService; // Thêm service này

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        DataSource ds = DataSourceUtil.getDataSource();
        this.registerService = new RegisterServiceImpl(ds);
        this.seminarService = new SeminarServiceImpl(ds);
        this.categoryService = new CategoryServiceImpl(ds); // Khởi tạo
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // 1. Xử lý thông báo
            String msg = req.getParameter("msg");
            String error = req.getParameter("error");
            if (msg != null) req.setAttribute("msg", msg);
            if (error != null) req.setAttribute("error", error);

            // 2. Xử lý Category ID (Logic Mới)
            int categoryId = 1; // Mặc định
            String categoryName = "Danh sách đăng ký";

            String catIdParam = req.getParameter("categoryId");
            String type = req.getParameter("type");

            if (catIdParam != null && !catIdParam.isEmpty()) {
                // Ưu tiên 1: Lấy theo ID
                try {
                    categoryId = Integer.parseInt(catIdParam);
                } catch (NumberFormatException e) {
                    categoryId = 1;
                }
            } else if (type != null) {
                // Ưu tiên 2: Fallback theo type (để tương thích link cũ)
                switch (type) {
                    case "technology": categoryId = 2; break;
                    case "science": categoryId = 3; break;
                    default: categoryId = 1; break;
                }
            }

            // Lấy tên Category từ Database (Chuẩn hơn gán cứng)
            // Bạn cần đảm bảo CategoryService có hàm findById
            // Hoặc tạm thời lấy từ danh sách tất cả nếu chưa có hàm findById
            // Ở đây giả sử bạn có thể lấy tên:
            List<Category> allCats = categoryService.findAll();
            for (Category c : allCats) {
                if (c.getId() == categoryId) {
                    categoryName = "Hội thảo " + c.getName();
                    break;
                }
            }

            // 3. Lấy các tham số Lọc
            int seminarIdFilter = 0;
            try {
                String sId = req.getParameter("seminarId");
                if (sId != null && !sId.isEmpty()) seminarIdFilter = Integer.parseInt(sId);
            } catch (Exception e) {}

            int vipStatus = -1;
            try {
                String vId = req.getParameter("vipStatus");
                if (vId != null && !vId.isEmpty()) vipStatus = Integer.parseInt(vId);
            } catch (Exception e) {}

            String userType = req.getParameter("userType");
            if (userType == null) userType = "";

            int checkInStatus = -1;
            try {
                String cId = req.getParameter("checkInStatus");
                if (cId != null && !cId.isEmpty()) checkInStatus = Integer.parseInt(cId);
            } catch (Exception e) {}

            // 4. Phân trang
            int page = 1;
            int pageSize = 10;
            try {
                String p = req.getParameter("page");
                if (p != null) page = Integer.parseInt(p);
            } catch (Exception e) {}

            // 5. Gọi Service lấy dữ liệu
            List<Register> list = registerService.findAllByCategoryId(
                    categoryId, seminarIdFilter, vipStatus, userType, checkInStatus, page, pageSize
            );

            int totalRecords = registerService.countByFilter(categoryId, seminarIdFilter, vipStatus);
            int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

            // Đổ danh sách hội thảo vào dropdown (theo category hiện tại)
            List<Seminar> seminars = seminarService.findByCategoryId(categoryId); // Đã sửa tên hàm cho khớp với SeminarRepository

            // 6. Gửi về JSP
            req.setAttribute("list", list);
            req.setAttribute("seminars", seminars);
            req.setAttribute("categoryName", categoryName);

            // Gửi lại categoryId để JSP dùng cho các link
            req.setAttribute("categoryId", categoryId);
            req.setAttribute("type", type); // Vẫn gửi type để giữ tương thích nếu cần

            req.setAttribute("currentSeminarId", seminarIdFilter);
            req.setAttribute("vipStatus", vipStatus);
            req.setAttribute("userType", userType);
            req.setAttribute("checkInStatus", checkInStatus);

            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);

            req.getRequestDispatcher("list-user.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("home.jsp");
        }
    }
}