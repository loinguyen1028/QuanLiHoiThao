package servlet;

import dao.RegisterDAO;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Register;
import model.Seminar;
import service.SeminarService;
import serviceImpl.SeminarServiceImpl;
import utils.DataSourceUtil;

import javax.sql.DataSource;
import java.io.IOException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    private RegisterDAO registerDAO;
    private SeminarService seminarService;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        registerDAO = new RegisterDAO();

        DataSource ds = DataSourceUtil.getDataSource();
        seminarService = new SeminarServiceImpl(ds);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Lấy tham số
        String seminarIdStr = request.getParameter("seminarId");
        String fullname     = request.getParameter("fullname");
        String email        = request.getParameter("email");
        String phone        = request.getParameter("phone");
        String type         = request.getParameter("type");

        int seminarId = 0;
        try {
            seminarId = Integer.parseInt(seminarIdStr);
        } catch (Exception e) {
            seminarId = 0;
        }

        // Lấy lại thông tin seminar để hiển thị trên form kể cả khi lỗi
        Seminar seminar = null;
        if (seminarId > 0) {
            seminar = seminarService.findById(seminarId);
        }
        request.setAttribute("seminar", seminar);

        // Tối thiểu validate
        if (seminarId <= 0 || fullname == null || fullname.isBlank()
                || email == null || email.isBlank()) {

            request.setAttribute("errorMessage", "Dữ liệu không hợp lệ. Vui lòng kiểm tra lại.");
            request.getRequestDispatcher("/register-user.jsp").forward(request, response);
            return;
        }

        // Tạo đối tượng Register
        Register r = new Register();
        r.setSeminarId(seminarId);
        r.setName(fullname);
        r.setEmail(email);
        r.setPhone(phone);
        r.setUserType(type);  // sinh viên / giảng viên / khách tự do

        // Gọi DAO insert
        boolean ok = false;
        try {
            ok = registerDAO.insert(r);
        } catch (Exception e) {
            e.printStackTrace();
            ok = false;
        }

        if (ok) {
            request.setAttribute("successMessage", "Đăng ký thành công! Cảm ơn bạn đã tham gia.");
        } else {
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi lưu đăng ký. Vui lòng thử lại sau.");
        }

        // Forward lại trang register-user.jsp để hiển thị thông báo
        request.getRequestDispatcher("/register-user.jsp").forward(request, response);
    }
}
