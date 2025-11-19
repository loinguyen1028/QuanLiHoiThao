package servlet;

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
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/export_csv")
public class ExportCsvServlet extends HttpServlet {
    private RegisterService registerService;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        DataSource ds = DataSourceUtil.getDataSource();
        this.registerService = new RegisterServiceImpl(ds);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Cấu hình Header để trình duyệt tải file về
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"thong_ke_khach_hang.csv\"");
        response.setCharacterEncoding("UTF-8");

        // 2. Lấy dữ liệu
        List<GuestStatDTO> list = registerService.getGuestStatistics();

        // 3. Ghi file CSV
        try (PrintWriter writer = response.getWriter()) {
            // Thêm BOM để Excel hiển thị đúng tiếng Việt
            writer.write('\ufeff');

            // Ghi tiêu đề cột
            writer.println("Loai Khach,Tong Dang Ky,Da Check-in,Ti Le");

            // Ghi dữ liệu từng dòng
            for (GuestStatDTO dto : list) {
                double rate = dto.getTotalRegistered() > 0 ?
                        ((double)dto.getTotalCheckedIn() / dto.getTotalRegistered()) * 100 : 0;

                // Format dòng CSV: "Sinh vien,10,5,50.0%"
                writer.println(String.format("%s,%d,%d,%.1f%%",
                        dto.getGuestType(),
                        dto.getTotalRegistered(),
                        dto.getTotalCheckedIn(),
                        rate));
            }
        }
    }
}
