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
            String type = req.getParameter("type");  // environment / technology / science

            if (type == null) {
                // Không truyền type → có thể cho về 404 hoặc mặc định Môi trường
                type = "environment";
            }

            int categoryId;
            String categoryName;

            switch (type) {
                case "technology":
                    categoryId = 2;
                    categoryName = "Hội thảo công nghệ";
                    break;
                case "science":
                    categoryId = 3;
                    categoryName = "Hội thảo khoa học";
                    break;
                case "environment":
                default:
                    categoryId = 1;
                    categoryName = "Hội thảo môi trường";
                    break;
            }

            // Lấy list đăng ký theo category
            List<Register> list = dao.getByCategoryId(categoryId);

            req.setAttribute("list", list);
            req.setAttribute("categoryName", categoryName);
            req.setAttribute("type", type);

            req.getRequestDispatcher("list-user.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("404.jsp");
        }
    }
}
