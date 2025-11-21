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
        super.init(config);
        DataSource ds = DataSourceUtil.getDataSource();
        this.registerService = new RegisterServiceImpl(ds);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        // --- 1. Lấy các tham số lọc giống hệt ListSeminarServlet ---
        String type = req.getParameter("type");
        if (type == null) type = "environment";

        int categoryId = 1;
        String sheetName = "MoiTruong";

        switch (type) {
            case "technology": categoryId = 2; sheetName = "CongNghe"; break;
            case "science":    categoryId = 3; sheetName = "KhoaHoc"; break;
            default:           categoryId = 1; sheetName = "MoiTruong"; break;
        }

        int seminarIdFilter = 0;
        try {
            String sId = req.getParameter("seminarId");
            if (sId != null && !sId.isEmpty()) seminarIdFilter = Integer.parseInt(sId);
        } catch (NumberFormatException e) {}

        int vipStatus = -1;
        try {
            String vId = req.getParameter("vipStatus");
            if (vId != null && !vId.isEmpty()) vipStatus = Integer.parseInt(vId);
        } catch (Exception e) {}

        String userType = req.getParameter("userType");
        if (userType == null) userType = "";

        int checkInStatus = -1;
        try {
            String cId = req.getParameter("checkInStatus");
            if (cId != null && !cId.isEmpty()) checkInStatus = Integer.parseInt(cId);
        } catch (Exception e) {}

        // --- 2. Gọi Service lấy TẤT CẢ dữ liệu (pageSize = MAX_VALUE) ---
        List<Register> list = registerService.findAllByCategoryId(
                categoryId,
                seminarIdFilter,
                vipStatus,
                userType,
                checkInStatus,
                1,
                Integer.MAX_VALUE // Lấy hết không phân trang
        );

        // --- 3. Tạo File Excel ---
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

            // Tạo Tiêu đề Cột
            Row headerRow = sheet.createRow(0);
            headerRow.setHeightInPoints(30);

            // ************ CHỈNH SỬA DUY NHẤT: THÊM MÃ CHECK-IN VÀO TIÊU ĐỀ CỘT ************
            String[] columns = {
                    "ID", "Mã Check-in", "Họ và Tên", "Email", "Điện thoại", // Thêm "Mã Check-in"
                    "Loại khách", "Tên Hội Thảo", "VIP", "Check-in", "Ngày Đăng Ký"
            };

            for (int i = 0; i < columns.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(columns[i]);
                cell.setCellStyle(headerStyle);
            }

            // Đổ dữ liệu
            int rowNum = 1;
            if (list != null) {
                for (Register r : list) {
                    Row row = sheet.createRow(rowNum++);

                    int col = 0; //

                    createCell(row, col++, String.valueOf(r.getId()), dataStyle);
                    createCell(row, col++, r.getCheckInId(), dataStyle);
                    createCell(row, col++, r.getName(), dataStyle);
                    createCell(row, col++, r.getEmail(), dataStyle);
                    createCell(row, col++, r.getPhone(), dataStyle);
                    createCell(row, col++, r.getUserType(), dataStyle);
                    createCell(row, col++, r.getEventName(), dataStyle);
                    createCell(row, col++, r.isVip() ? "Có" : "Không", dataStyle);

                    // Xử lý Check-in text
                    String checkInInfo = "Chưa";
                    if (r.getCheckinTime() != null) {
                        String timeStr = r.getCheckinTime().toString();
                        if (timeStr.length() > 16) timeStr = timeStr.substring(0, 16);
                        checkInInfo = timeStr;
                    }
                    createCell(row, col++, checkInInfo, dataStyle);

                    // Ngày đăng ký
                    createCell(row, col++, (r.getRegisterDate() != null ? r.getRegisterDate().toString() : ""), dataStyle);
                }
            }

            // Auto Size cột
            for (int i = 0; i < columns.length; i++) {
                sheet.autoSizeColumn(i);
                int currentWidth = sheet.getColumnWidth(i);
                sheet.setColumnWidth(i, currentWidth + 1000);
            }

            // Xuất file
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