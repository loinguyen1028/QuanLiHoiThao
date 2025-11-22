package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Register;
import service.RegisterService;
import service.SeminarService;
import serviceImpl.RegisterServiceImpl;
import serviceImpl.SeminarServiceImpl;
import utils.DataSourceUtil;

import javax.sql.DataSource;
import java.io.IOException;
import java.util.List;

@WebServlet("/delete_seminar")
public class DeleteSeminar extends HttpServlet {

    private SeminarService seminarService;
    private RegisterService registerService;
    @Override
    public void init() throws ServletException {
        DataSource ds = DataSourceUtil.getDataSource();
        seminarService = new SeminarServiceImpl(ds);
        registerService = new RegisterServiceImpl(ds);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        List<Register> listRegister = registerService.findBySeminarId(id);
        if (listRegister == null) {
            seminarService.delete(id);
            response.sendRedirect(request.getContextPath() + "/seminar_management");
        }else {
            String err = "Hội thảo đăng có người đăng kí";
            request.setAttribute("err", err);
            response.sendRedirect(request.getContextPath() + "/seminar_management");
        }
    }
}
