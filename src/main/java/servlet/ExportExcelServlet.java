package servlet;

import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Register;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import service.RegisterService;
import serviceImpl.RegisterServiceImpl;
import utils.DataSourceUtil;

import javax.sql.DataSource;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@WebServlet("/export-excel")
public class ExportExcelServlet extends HttpServlet {

    private RegisterService registerService;

    @Override
    public void init(ServletConfig config) throws ServletException {
        DataSource ds = DataSourceUtil.getDataSource();
        this.registerService = new RegisterServiceImpl(ds);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        // 1. Lấy loại hội thảo
        String type = req.getParameter("type");
        if (type == null) type = "environment";

        int categoryId = 1;
        String sheetName = "MoiTruong";

        switch (type) {
            case "technology": categoryId = 2; sheetName = "CongNghe"; break;
            case "science":    categoryId = 3; sheetName = "KhoaHoc"; break;
            default:           categoryId = 1; sheetName = "MoiTruong"; break;
        }

        // 2. Lấy dữ liệu
        List<Register> list = registerService.findAllByCategoryId(categoryId);

        // 3. TẠO FILE EXCEL
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet(sheetName);

            // --- STYLE CHO TIÊU ĐỀ (Đậm, Giữa, Nền Xám) ---
            CellStyle headerStyle = workbook.createCellStyle();
            Font font = workbook.createFont();
            font.setBold(true);
            font.setColor(IndexedColors.WHITE.getIndex());
            headerStyle.setFont(font);
            headerStyle.setFillForegroundColor(IndexedColors.ROYAL_BLUE.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            headerStyle.setAlignment(HorizontalAlignment.CENTER);
            headerStyle.setVerticalAlignment(VerticalAlignment.CENTER);
            setBorder(headerStyle); // Kẻ khung

            // --- STYLE CHO DỮ LIỆU (Kẻ khung) ---
            CellStyle dataStyle = workbook.createCellStyle();
            setBorder(dataStyle);
            dataStyle.setVerticalAlignment(VerticalAlignment.CENTER);

            // --- TẠO DÒNG TIÊU ĐỀ ---
            Row headerRow = sheet.createRow(0);
            headerRow.setHeightInPoints(30); // Cao hơn chút cho đẹp
            String[] columns = {"ID", "Họ và Tên", "Email", "Điện thoại", "Loại khách", "Hội Thảo", "VIP", "Mã Check-in", "Ngày Đăng Ký"};

            for (int i = 0; i < columns.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(columns[i]);
                cell.setCellStyle(headerStyle);
            }

            // --- ĐỔ DỮ LIỆU ---
            int rowNum = 1;
            for (Register r : list) {
                Row row = sheet.createRow(rowNum++);

                createCell(row, 0, String.valueOf(r.getId()), dataStyle);
                createCell(row, 1, r.getName(), dataStyle);
                createCell(row, 2, r.getEmail(), dataStyle);
                createCell(row, 3, r.getPhone(), dataStyle);
                createCell(row, 4, r.getUserType(), dataStyle);
                createCell(row, 5, r.getEventName(), dataStyle);
                createCell(row, 6, r.isVip() ? "VIP" : "", dataStyle);
                createCell(row, 7, r.getCheckInId(), dataStyle);
                createCell(row, 8, (r.getRegisterDate() != null ? r.getRegisterDate().toString() : ""), dataStyle);
            }

            // --- QUAN TRỌNG: TỰ ĐỘNG GIÃN CỘT ---
            for (int i = 0; i < columns.length; i++) {
                sheet.autoSizeColumn(i);
                // Cộng thêm chút chiều rộng cho thoáng (khoảng 2 ký tự)
                int currentWidth = sheet.getColumnWidth(i);
                sheet.setColumnWidth(i, currentWidth + 1000);
            }

            // 4. Xuất file ra trình duyệt
            String fileName = "Danh_Sach_" + sheetName + ".xlsx";
            resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            resp.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

            try (OutputStream out = resp.getOutputStream()) {
                workbook.write(out);
            }
        }
    }

    // Hàm phụ để kẻ khung nhanh
    private void setBorder(CellStyle style) {
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderTop(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);
        style.setBorderLeft(BorderStyle.THIN);
    }

    // Hàm phụ tạo ô nhanh
    private void createCell(Row row, int column, String value, CellStyle style) {
        Cell cell = row.createCell(column);
        cell.setCellValue(value != null ? value : "");
        cell.setCellStyle(style);
    }
}