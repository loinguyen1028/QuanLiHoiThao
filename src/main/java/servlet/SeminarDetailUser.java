// file: src/main/java/servlet/SeminarDetailUser.java
package servlet;

import jakarta.servlet.ServletConfig;
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

@WebServlet("/seminar_detail_user")
public class SeminarDetailUser extends HttpServlet {

    private SeminarService seminarService;

    @Override
    public void init(ServletConfig config) throws ServletException {
        DataSource ds = DataSourceUtil.getDataSource();
        seminarService = new SeminarServiceImpl(ds);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");
        int idParam;

        try {
            idParam = Integer.parseInt(id);
        } catch (Exception e) {
            // nếu id sai → về 404 hoặc home
            response.sendRedirect(request.getContextPath() + "/home.jsp");
            return;
        }

        Seminar seminar = seminarService.findById(idParam);
        if (seminar == null) {
            response.sendRedirect(request.getContextPath() + "/home.jsp");
            return;
        }

        request.setAttribute("seminar", seminar);
        request.getRequestDispatcher("/seminar-detail-user.jsp").forward(request, response);
    }
}
