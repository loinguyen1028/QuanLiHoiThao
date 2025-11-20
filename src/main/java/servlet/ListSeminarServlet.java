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

        try {
            String msg = req.getParameter("msg");
            if (msg != null) req.setAttribute("msg", msg);

            String type = req.getParameter("type");
            if (type == null) type = "environment";

            // Lấy trạng thái VIP (mặc định -1)
            int vipStatus = -1;
            if (req.getParameter("vipStatus") != null) {
                try { vipStatus = Integer.parseInt(req.getParameter("vipStatus")); } catch (Exception e) {}
            }

            int categoryId;
            String categoryName;

            switch (type) {
                case "technology": categoryId = 2; categoryName = "Hội thảo công nghệ"; break;
                case "science": categoryId = 3; categoryName = "Hội thảo khoa học"; break;
                default:
                case "environment": categoryId = 1; categoryName = "Hội thảo môi trường"; break;
            }

            int page = 1;
            int pageSize = 10;
            if (req.getParameter("page") != null) {
                try { page = Integer.parseInt(req.getParameter("page")); } catch (Exception e) {}
            }

            // Gọi DAO mới có tham số vipStatus
            List<Register> list = dao.getByCategoryIdWithPaging(categoryId, page, pageSize, vipStatus);
            int totalRecords = dao.countByCategoryId(categoryId, vipStatus);
            int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

            req.setAttribute("list", list);
            req.setAttribute("categoryName", categoryName);
            req.setAttribute("type", type);
            req.setAttribute("vipStatus", vipStatus); // Gửi lại JSP
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);

            req.getRequestDispatcher("list-user.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("home.jsp");
        }
    }
}