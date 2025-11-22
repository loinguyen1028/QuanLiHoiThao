package servlet;

import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Register;
import model.Seminar;
import service.RegisterService;
import service.SeminarService;
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

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        DataSource ds = DataSourceUtil.getDataSource();
        this.registerService = new RegisterServiceImpl(ds);
        this.seminarService = new SeminarServiceImpl(ds);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // --- 1. Xử lý thông báo (nếu có) ---
            String msg = req.getParameter("msg");
            String error = req.getParameter("error");
            if (msg != null) req.setAttribute("msg", msg);
            if (error != null) req.setAttribute("error", error);

            // --- 2. Xử lý tham số Loại danh mục (Môi trường/Công nghệ/Khoa học) ---
            int categoryId = 1;
            String type = "environment";
            String categoryName = "Hội thảo môi trường";

            // Lấy tham số từ URL
            String catIdParam = req.getParameter("categoryId");
            String typeParam = req.getParameter("type");

            // QUY TẮC: Ưu tiên lấy theo ID. Nếu có ID thì Type phải theo ID.
            if (catIdParam != null && !catIdParam.isEmpty()) {
                try {
                    categoryId = Integer.parseInt(catIdParam);

                    // Map ngược từ ID ra Type và Name
                    if (categoryId == 2) {
                        type = "technology";
                        categoryName = "Hội thảo công nghệ";
                    } else if (categoryId == 3) {
                        type = "science";
                        categoryName = "Hội thảo khoa học";
                    } else {
                        // ID = 1 hoặc khác
                        type = "environment";
                        categoryName = "Hội thảo môi trường";
                    }
                } catch (NumberFormatException e) {
                    categoryId = 1; // Fallback nếu ID lỗi
                }
            }
            // Nếu không có ID, mới xét đến Type (Fallback cho link cũ)
            else if (typeParam != null) {
                type = typeParam;
                switch (type) {
                    case "technology":
                        categoryId = 2;
                        categoryName = "Hội thảo công nghệ";
                        break;
                    case "science":
                        categoryId = 3;
                        categoryName = "Hội thảo khoa học";
                        break;
                    default:
                        categoryId = 1;
                        categoryName = "Hội thảo môi trường";
                        type = "environment";
                        break;
                }
            }

            // --- 3. Lấy các tham số Lọc (Filter) ---

            // Lọc theo Seminar ID
            int seminarIdFilter = 0;
            try {
                String sId = req.getParameter("seminarId");
                if (sId != null && !sId.isEmpty()) seminarIdFilter = Integer.parseInt(sId);
            } catch (Exception e) {}

            // Lọc theo VIP
            int vipStatus = -1;
            try {
                String vId = req.getParameter("vipStatus");
                if (vId != null && !vId.isEmpty()) vipStatus = Integer.parseInt(vId);
            } catch (Exception e) {}

            // Lọc theo Loại khách (Sinh viên/Giảng viên...)
            String userType = req.getParameter("userType");
            if (userType == null) userType = "";

            // Lọc theo Check-in
            int checkInStatus = -1;
            try {
                String cId = req.getParameter("checkInStatus");
                if (cId != null && !cId.isEmpty()) checkInStatus = Integer.parseInt(cId);
            } catch (Exception e) {}

            // --- 4. Xử lý Phân trang ---
            int page = 1;
            int pageSize = 10;
            try {
                String p = req.getParameter("page");
                if (p != null) page = Integer.parseInt(p);
            } catch (Exception e) {}

            // --- 5. Gọi Service lấy dữ liệu ---

            List<Register> list = registerService.findAllByCategoryId(
                    categoryId, seminarIdFilter, vipStatus, userType, checkInStatus, page, pageSize
            );

            int totalRecords = registerService.countByFilter(categoryId, seminarIdFilter, vipStatus); // Lưu ý: Hàm count nên hỗ trợ đủ bộ lọc
            int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

            // Lấy danh sách Seminar để đổ vào dropdown (theo categoryId đúng)
            List<Seminar> seminars = seminarService.findByCategoryId(categoryId);

            // --- 6. Gửi dữ liệu sang JSP ---
            req.setAttribute("list", list);
            req.setAttribute("seminars", seminars);
            req.setAttribute("categoryName", categoryName);

            // Gửi lại ID và Type chuẩn để JSP dùng cho form
            req.setAttribute("categoryId", categoryId);
            req.setAttribute("type", type);

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