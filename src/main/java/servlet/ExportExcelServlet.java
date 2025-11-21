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

        String type = req.getParameter("type");
        if (type == null) type = "environment";

        int categoryId = 1;
        String sheetName = "MoiTruong";

        switch (type) {
            case "technology": categoryId = 2; sheetName = "CongNghe"; break;
            case "science":    categoryId = 3; sheetName = "KhoaHoc"; break;
            default:           categoryId = 1; sheetName = "MoiTruong"; break;
        }

        List<Register> list = registerService.findAllByCategoryId(categoryId);

        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet(sheetName);

            // Style Header
            CellStyle headerStyle = workbook.createCellStyle();
            Font font = workbook.createFont();
            font.setBold(true);
            font.setColor(IndexedColors.WHITE.getIndex());
            headerStyle.setFont(font);
            headerStyle.setFillForegroundColor(IndexedColors.ROYAL_BLUE.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            headerStyle.setAlignment(HorizontalAlignment.CENTER);
            headerStyle.setVerticalAlignment(VerticalAlignment.CENTER);
            setBorder(headerStyle);

            // Style Data
            CellStyle dataStyle = workbook.createCellStyle();
            setBorder(dataStyle);
            dataStyle.setVerticalAlignment(VerticalAlignment.CENTER);

            // --- 1. SỬA TIÊU ĐỀ CỘT ---
            Row headerRow = sheet.createRow(0);
            headerRow.setHeightInPoints(30);
            String[] columns = {
                    "ID", "Họ và Tên", "Email", "Điện thoại",
                    "Loại khách", "Hội Thảo", "VIP", "Trạng thái Check-in", "Ngày Đăng Ký"
            };

            for (int i = 0; i < columns.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(columns[i]);
                cell.setCellStyle(headerStyle);
            }

            // --- 2. SỬA DỮ LIỆU ---
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

                // --- LOGIC CHECK-IN MỚI ---
                String checkInInfo;
                if (r.getCheckinTime() != null) {
                    // Lấy thời gian check-in (cắt bớt phần giây lẻ nếu muốn gọn)
                    checkInInfo = "Đã check-in: " + r.getCheckinTime().toString().substring(0, 16);
                } else {
                    checkInInfo = "Chưa";
                }
                createCell(row, 7, checkInInfo, dataStyle);
                // --------------------------

                createCell(row, 8, (r.getRegisterDate() != null ? r.getRegisterDate().toString() : ""), dataStyle);
            }

            for (int i = 0; i < columns.length; i++) {
                sheet.autoSizeColumn(i);
                int currentWidth = sheet.getColumnWidth(i);
                sheet.setColumnWidth(i, currentWidth + 1000);
            }

            String fileName = "Danh_Sach_" + sheetName + ".xlsx";
            resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            resp.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

            try (OutputStream out = resp.getOutputStream()) {
                workbook.write(out);
            }
        }
    }

    private void setBorder(CellStyle style) {
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderTop(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);
        style.setBorderLeft(BorderStyle.THIN);
    }

    private void createCell(Row row, int column, String value, CellStyle style) {
        Cell cell = row.createCell(column);
        cell.setCellValue(value != null ? value : "");
        cell.setCellStyle(style);
    }
}