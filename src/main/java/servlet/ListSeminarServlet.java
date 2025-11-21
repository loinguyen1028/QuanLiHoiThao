package servlet;

import dao.RegisterDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Register;

import java.io.IOException;
import java.util.List;

@WebServlet("/list-user")
public class ListSeminarServlet extends HttpServlet {
    private RegisterDAO dao;

    @Override
    public void init() {
        dao = new RegisterDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        try {
            String msg = req.getParameter("msg");
            if (msg != null) req.setAttribute("msg", msg);

            String type = req.getParameter("type");
            if (type == null) type = "environment";

            // --- LẤY CÁC THAM SỐ LỌC ---

            // 1. VIP (-1: All, 1: VIP, 0: Normal)
            int vipStatus = -1;
            try { if(req.getParameter("vipStatus") != null) vipStatus = Integer.parseInt(req.getParameter("vipStatus")); } catch(Exception e){}

            // 2. Loại khách (Rỗng: All)
            String userType = req.getParameter("userType");
            if (userType == null) userType = "";

            // 3. Check-in (-1: All, 1: Checked, 0: Not)
            int checkInStatus = -1;
            try { if(req.getParameter("checkInStatus") != null) checkInStatus = Integer.parseInt(req.getParameter("checkInStatus")); } catch(Exception e){}

            // 4. Từ khóa tìm kiếm
            String keyword = req.getParameter("keyword");
            if (keyword == null) keyword = "";

            int categoryId;
            String categoryName;
            switch (type) {
                case "technology": categoryId = 2; categoryName = "Hội thảo công nghệ"; break;
                case "science": categoryId = 3; categoryName = "Hội thảo khoa học"; break;
                default: case "environment": categoryId = 1; categoryName = "Hội thảo môi trường"; break;
            }

            // --- PHÂN TRANG ---
            int page = 1;
            int pageSize = 10;
            if (req.getParameter("page") != null) {
                try { page = Integer.parseInt(req.getParameter("page")); } catch (Exception ignored) {}
            }

            // GỌI DAO
            List<Register> list = dao.getByCategoryIdWithPaging(categoryId, page, pageSize, vipStatus, userType, checkInStatus, keyword);
            int totalRecords = dao.countByCategoryId(categoryId, vipStatus, userType, checkInStatus, keyword);
            int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

            // GỬI VỀ JSP
            req.setAttribute("list", list);
            req.setAttribute("categoryName", categoryName);
            req.setAttribute("type", type);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);

            // Gửi lại trạng thái lọc để JSP hiển thị đúng
            req.setAttribute("vipStatus", vipStatus);
            req.setAttribute("userType", userType);
            req.setAttribute("checkInStatus", checkInStatus);
            req.setAttribute("keyword", keyword);

            req.getRequestDispatcher("list-user.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("home.jsp");
        }
    }
}