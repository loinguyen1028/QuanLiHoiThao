package servlet;

import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Register;
import service.RegisterService;
import serviceImpl.RegisterServiceImpl;
import utils.DataSourceUtil;

import javax.sql.DataSource;
import java.io.IOException;

@WebServlet("/check-in")
public class CheckInServlet extends HttpServlet {

    private RegisterService registerService;

    @Override
    public void init(ServletConfig config) throws ServletException {
        DataSource ds = DataSourceUtil.getDataSource();
        this.registerService = new RegisterServiceImpl(ds);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/check-in.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String code = req.getParameter("checkInCode");

        // 1. Cắt khoảng trắng (Fix lỗi nhập liệu)
        if (code != null) {
            code = code.trim();
        }

        if (code == null || code.isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập mã hoặc quét QR!");
            req.getRequestDispatcher("/check-in.jsp").forward(req, resp);
            return;
        }

        // 2. Tìm người dùng
        Register r = registerService.findByCheckInId(code);

        if (r == null) {
            req.setAttribute("error", "❌ Mã vé không tồn tại: " + code);
            req.setAttribute("lastCode", code);
        } else {
            if (r.getCheckinTime() != null) {
                req.setAttribute("warning", "⚠️ Cảnh báo: Vé này ĐÃ check-in lúc: " + r.getCheckinTime());
                req.setAttribute("register", r);
            } else {
                boolean success = registerService.checkInUser(code);
                if (success) {
                    Register updatedR = registerService.findByCheckInId(code);
                    req.setAttribute("success", "✅ Check-in THÀNH CÔNG!");
                    req.setAttribute("register", updatedR);
                } else {
                    req.setAttribute("error", "❌ Lỗi hệ thống.");
                }
            }
        }

        req.getRequestDispatcher("/check-in.jsp").forward(req, resp);
    }
}