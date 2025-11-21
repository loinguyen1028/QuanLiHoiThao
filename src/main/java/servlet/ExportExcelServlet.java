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
        super.init(config); // Nhớ gọi super.init
        DataSource ds = DataSourceUtil.getDataSource();
        this.registerService = new RegisterServiceImpl(ds);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        // 1. Xử lý tham số loại danh mục
        String type = req.getParameter("type");
        if (type == null) type = "environment";

        int categoryId = 1;
        String sheetName = "MoiTruong";

        switch (type) {
            case "technology": categoryId = 2; sheetName = "CongNghe"; break;
            case "science":    categoryId = 3; sheetName = "KhoaHoc"; break;
            default:           categoryId = 1; sheetName = "MoiTruong"; break;
        }

        // 2. Lấy tham số lọc (Seminar ID) để xuất đúng dữ liệu người dùng đang xem
        int seminarIdFilter = 0;
        try {
            String sId = req.getParameter("seminarId");
            if (sId != null && !sId.isEmpty()) {
                seminarIdFilter = Integer.parseInt(sId);
            }
        } catch (NumberFormatException e) {
            seminarIdFilter = 0;
        }

        // 3. Gọi Service lấy dữ liệu thực
        // Tham số thứ 3 là vipStatus, để -1 nghĩa là lấy tất cả (cả VIP và thường)
        List<Register> list = registerService.findAllByCategoryId(categoryId, seminarIdFilter, -1);

        // 4. Tạo File Excel
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet(sheetName);

            // --- Style Header ---
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

            // --- Style Data ---
            CellStyle dataStyle = workbook.createCellStyle();
            setBorder(dataStyle);
            dataStyle.setVerticalAlignment(VerticalAlignment.CENTER);

            // --- Tạo Tiêu đề Cột ---
            Row headerRow = sheet.createRow(0);
            headerRow.setHeightInPoints(30);
            String[] columns = {
                    "ID", "Họ và Tên", "Email", "Điện thoại",
                    "Loại khách", "Tên Hội Thảo", "VIP", "Check-in", "Ngày Đăng Ký"
            };

            for (int i = 0; i < columns.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(columns[i]);
                cell.setCellStyle(headerStyle);
            }

            // --- Đổ dữ liệu vào dòng ---
            int rowNum = 1;
            if (list != null) {
                for (Register r : list) {
                    Row row = sheet.createRow(rowNum++);

                    createCell(row, 0, String.valueOf(r.getId()), dataStyle);
                    createCell(row, 1, r.getName(), dataStyle);
                    createCell(row, 2, r.getEmail(), dataStyle);
                    createCell(row, 3, r.getPhone(), dataStyle);
                    createCell(row, 4, r.getUserType(), dataStyle);

                    // Tên hội thảo (đã được lấy từ JOIN trong Repository)
                    createCell(row, 5, r.getEventName(), dataStyle);

                    createCell(row, 6, r.isVip() ? "Có" : "Không", dataStyle);

                    // Xử lý Check-in
                    String checkInInfo = "Chưa";
                    if (r.getCheckinTime() != null) {
                        // Cắt chuỗi để lấy ngày giờ gọn gàng (yyyy-MM-dd HH:mm)
                        String timeStr = r.getCheckinTime().toString();
                        if (timeStr.length() > 16) timeStr = timeStr.substring(0, 16);
                        checkInInfo = timeStr;
                    }
                    createCell(row, 7, checkInInfo, dataStyle);

                    // Ngày đăng ký
                    createCell(row, 8, (r.getRegisterDate() != null ? r.getRegisterDate().toString() : ""), dataStyle);
                }
            }

            // --- Auto Size cột ---
            for (int i = 0; i < columns.length; i++) {
                sheet.autoSizeColumn(i);
                // Cộng thêm chút chiều rộng cho thoáng
                int currentWidth = sheet.getColumnWidth(i);
                sheet.setColumnWidth(i, currentWidth + 1000);
            }

            // --- Xuất file ra trình duyệt ---
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