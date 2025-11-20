package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Seminar;
import service.SeminarService;
import serviceImpl.SeminarServiceImpl;
import utils.DataSourceUtil;

import javax.sql.DataSource;
import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.Date;

@WebServlet("/register_user")
public class RegisterUserServlet extends HttpServlet {

    private SeminarService seminarService;

    @Override
    public void init() throws ServletException {
        DataSource ds = DataSourceUtil.getDataSource();
        seminarService = new SeminarServiceImpl(ds);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String idStr = request.getParameter("seminarId");
            if (idStr == null || idStr.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/home.jsp");
                return;
            }

            int seminarId = Integer.parseInt(idStr);
            Seminar seminar = seminarService.findById(seminarId);

            if (seminar == null) {
                response.sendRedirect(request.getContextPath() + "/home.jsp");
                return;
            }

            // ============================================================
            // 🛡️ BẢO MẬT CẤP 1: CHẶN TRUY CẬP FORM NẾU HẾT HẠN
            // ============================================================
            Date now = new Date();

            // 1. Kiểm tra ngày mở (Nếu chưa đến giờ mở)
            Date openTime = seminar.getRegistrationOpen();
            if (openTime != null && now.before(openTime)) {
                // Chuyển hướng về trang chi tiết báo lỗi
                response.sendRedirect(request.getContextPath() + "/seminar_detail?id=" + seminarId + "&error=not_open_yet");
                return;
            }

            // 2. Kiểm tra ngày đóng (Logic tự động trừ 1 ngày giống JSP)
            Date closeTime = seminar.getRegistrationDeadline();
            if (closeTime == null) {
                if (seminar.getStart_date() != null) {
                    LocalDateTime defaultDeadline = seminar.getStart_date().minusDays(1);
                    closeTime = Timestamp.valueOf(defaultDeadline);
                } else {
                    closeTime = new Date(); // Fallback an toàn
                }
            }

            // Nếu hiện tại đã quá hạn
            if (now.after(closeTime)) {
                // Chuyển hướng về trang chi tiết báo lỗi
                response.sendRedirect(request.getContextPath() + "/seminar_detail?id=" + seminarId + "&error=expired");
                return;
            }
            // ============================================================

            request.setAttribute("seminar", seminar);
            request.getRequestDispatcher("/register-user.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/home.jsp");
        }
    }
}