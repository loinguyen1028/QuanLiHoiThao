package servlet;

import dto.SeminarDTO;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Page;
import model.PageRequest;
import model.Seminar;
import service.SeminarService;
import serviceImpl.SeminarServiceImpl;
import utils.DataSourceUtil;
import utils.RequestUtil;

import javax.sql.DataSource;
import java.io.IOException;
import java.util.List;

@WebServlet("/seminar_management")
public class SeminarManagement extends HttpServlet {

    private SeminarService seminarService;

    @Override
    public void init(ServletConfig config) throws ServletException {
        DataSource ds = DataSourceUtil.getDataSource();
        seminarService = new SeminarServiceImpl(ds);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int page = RequestUtil.getInt(request, "page", 1);
        int size = RequestUtil.getInt(request, "size", 10);
        String sort = RequestUtil.getString(request, "sortField", "max_attendees");
        String order = RequestUtil.getString(request, "order", "asc");
        String keyword = RequestUtil.getString(request,"keyword","");

        PageRequest pageRequest = new PageRequest(page, size, sort, order, keyword);
        Page<SeminarDTO> result = seminarService.findAllToDTO(pageRequest);

//        List<Seminar> seminarList = seminarService.findAll();
//        request.setAttribute("seminarList", seminarList);

        request.setAttribute("result", result);
        request.setAttribute("pageRequest", pageRequest);
        request.getRequestDispatcher("/seminar-management.jsp").forward(request, response);
    }

}
