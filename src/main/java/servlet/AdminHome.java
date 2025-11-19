package servlet;

import dto.ChartDataDTO;
import dto.GuestStatDTO;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.RegisterService;
import serviceImpl.RegisterServiceImpl;
import utils.DataSourceUtil;

import javax.sql.DataSource;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin")
public class AdminHome extends HttpServlet {
    private RegisterService registerService;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        DataSource ds = DataSourceUtil.getDataSource();
        registerService = new RegisterServiceImpl(ds);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<ChartDataDTO> timeStats = registerService.getRegistrationStatsByDate();

        List<GuestStatDTO> guestStats = registerService.getGuestStatistics();

        StringBuilder dateLabels = new StringBuilder("[");
        StringBuilder dateValues = new StringBuilder("[");

        for (int i = 0; i < timeStats.size(); i++) {
            dateLabels.append("\"").append(timeStats.get(i).getLabel()).append("\"");
            dateValues.append(timeStats.get(i).getValue());

            if (i < timeStats.size() - 1) {
                dateLabels.append(",");
                dateValues.append(",");
            }
        }
        dateLabels.append("]");
        dateValues.append("]");

        request.setAttribute("dateLabels", dateLabels.toString());
        request.setAttribute("dateValues", dateValues.toString());
        request.setAttribute("guestStats", guestStats);

        request.getRequestDispatcher("/admin.jsp").forward(request, response);
    }
}
