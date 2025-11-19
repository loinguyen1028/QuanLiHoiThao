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

        int seminarId = Integer.parseInt(request.getParameter("seminarId"));
        Seminar seminar = seminarService.findById(seminarId);

        request.setAttribute("seminar", seminar);
        request.getRequestDispatcher("/register-user.jsp").forward(request, response);
    }
}
