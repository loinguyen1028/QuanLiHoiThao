package servlet;

import com.mysql.cj.jdbc.DatabaseMetaData;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Admin;
import service.AdminService;

import serviceImpl.AdminServiceImpl;
import utils.DataSourceUtil;
import javax.sql.DataSource;
import java.io.IOException;

@WebServlet("/login")
public class LoginAdminServlet extends HttpServlet {

    private AdminService adminService;

    @Override
    public void init(ServletConfig config) throws ServletException {
        DataSource ds = DataSourceUtil.getDataSource();
        this.adminService = new AdminServiceImpl(ds);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("username") != null) {
            // Nếu đã đăng nhập, chuyển đến trang chủ admin (ví dụ /admin/home)
            // Bạn hãy đổi "/admin-home.jsp" thành trang của bạn
            request.getRequestDispatcher("/admin.jsp").forward(request, response);
        } else {
            // Nếu chưa đăng nhập, mới hiển thị trang login
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if(username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty()){
            String err = "Vui lòng nhập đầy đủ thông tin";
            request.setAttribute("err", err);
            request.getRequestDispatcher("/login.jsp").forward(request, response);

        }else{

            Admin admin = adminService.isAuthenticated(username, password);

            if(admin != null ){
                HttpSession session = request.getSession();
                session.setAttribute("username", admin.getEmail());

                response.sendRedirect(request.getContextPath()+"/admin");
            }else {
                String err = "Vui lòng kiểm tra lại user và password";
                request.setAttribute("err", err);
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        }

    }
}
