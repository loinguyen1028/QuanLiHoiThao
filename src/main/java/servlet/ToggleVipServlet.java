package servlet;

import dao.RegisterDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/toggle-vip")
public class ToggleVipServlet extends HttpServlet {

    private RegisterDAO dao;

    @Override
    public void init() {
        dao = new RegisterDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // 1. Lấy ID từ đường dẫn
            int id = Integer.parseInt(req.getParameter("id"));

            // 2. Gọi hàm đổi trạng thái
            dao.toggleVip(id);

            // 3. Quay lại trang danh sách mà Admin đang đứng
            String referer = req.getHeader("Referer");
            resp.sendRedirect(referer != null ? referer : "list-user");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("list-user");
        }
    }
}