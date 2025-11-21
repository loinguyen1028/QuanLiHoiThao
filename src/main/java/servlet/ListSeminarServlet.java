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
            // 1. Nhận thông báo (nếu có)
            String msg = req.getParameter("msg");
            String error = req.getParameter("error");
            if (msg != null) req.setAttribute("msg", msg);
            if (error != null) req.setAttribute("error", error);

            // 2. Xác định Loại danh mục (Environment, Tech, Science)
            String type = req.getParameter("type");
            if (type == null) type = "environment";

            int categoryId = 1; // Mặc định
            String categoryName = "Hội thảo môi trường";

            switch (type) {
                case "technology": categoryId = 2; categoryName = "Hội thảo công nghệ"; break;
                case "science": categoryId = 3; categoryName = "Hội thảo khoa học"; break;
            }

            // 3. Lấy tham số Lọc (Seminar ID & VIP)
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

            int page = 1;
            int pageSize = 10; // Số lượng mỗi trang
            try {
                String p = req.getParameter("page");
                if (p != null) page = Integer.parseInt(p);
            } catch (Exception e) {}

            int totalRecords = registerService.countByFilter(categoryId, seminarIdFilter, vipStatus);
            int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

            List<Register> list = registerService.findAllByCategoryId(categoryId, seminarIdFilter, vipStatus, page, pageSize);

            // Lấy danh sách hội thảo (để đổ vào dropdown lọc)
            List<Seminar> seminars = seminarService.findByCategoryId(categoryId);

            // 5. Gửi dữ liệu sang JSP
            req.setAttribute("list", list);
            req.setAttribute("seminars", seminars);
            req.setAttribute("categoryName", categoryName);
            req.setAttribute("type", type);

            req.setAttribute("currentSeminarId", seminarIdFilter);
            req.setAttribute("vipStatus", vipStatus);

            // Gửi thông tin phân trang
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);

            req.getRequestDispatcher("list-user.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("home.jsp");
        }
    }
}