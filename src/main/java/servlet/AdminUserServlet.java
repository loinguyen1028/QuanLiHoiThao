package servlet;

import QRCode.QRCodeGenerator;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Register;
import model.Seminar;
import repository.RegisterRepository;
import repositoryImpl.RegisterRepositoryImpl;
import service.RegisterService;
import service.SeminarService;
import serviceImpl.RegisterServiceImpl;
import serviceImpl.SeminarServiceImpl;
import utils.EmailUtil; // Import gửi mail
import utils.DataSourceUtil;

import javax.sql.DataSource;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.UUID;

@WebServlet("/admin-user")
public class AdminUserServlet extends HttpServlet {

    private RegisterService registerService;
    private SeminarService seminarService;

    @Override
    public void init(ServletConfig config) throws ServletException {
        DataSource ds = DataSourceUtil.getDataSource();
        this.registerService = new RegisterServiceImpl(ds);
        this.seminarService = new SeminarServiceImpl(ds);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "delete": deleteUser(req, resp); break;
            case "edit":   showEditForm(req, resp); break;
            case "add":    showAddForm(req, resp); break;
            default:       resp.sendRedirect("list-user"); break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        if ("insert".equals(action)) insertUser(req, resp);
        else if ("update".equals(action)) updateUser(req, resp);
    }

    // --- HÀM QUAN TRỌNG: Xác định loại hội thảo để quay về ---
    private String getTypeBySeminarId(int seminarId) {
        Seminar s = seminarService.findById(seminarId);
        if (s != null) {
            int catId = s.getCategoryId();
            if (catId == 2) return "technology";
            if (catId == 3) return "science";
        }
        return "environment";
    }

    private void deleteUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            Register old = registerService.findById(id);
            String typeRedirect = "environment";
            if (old != null) typeRedirect = getTypeBySeminarId(old.getSeminarId());

            registerService.delete(id);

            // Redirect kèm msg
            String msg = URLEncoder.encode("Xóa thành công!", StandardCharsets.UTF_8);
            resp.sendRedirect("list-user?type=" + typeRedirect + "&msg=" + msg);
        } catch (Exception e) {
            e.printStackTrace();
            // Nếu có lỗi xóa thì báo lỗi (về JSP hiển thị alert-danger)
            String msg = URLEncoder.encode("Xóa thất bại! Đã xảy ra lỗi.", StandardCharsets.UTF_8);
            resp.sendRedirect("list-user?msg=" + msg + "&error=1");
        }
    }

    // 🔥 HÀM NÀY ĐÃ ĐƯỢC THÊM CHỨC NĂNG GỬI MAIL
    private void insertUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int seminarId = Integer.parseInt(req.getParameter("seminarId"));
            String fullname = req.getParameter("fullname");
            String email = req.getParameter("email");
            String phone = req.getParameter("phone");
            String type = req.getParameter("type");

            Register r = new Register();
            r.setSeminarId(seminarId);
            r.setName(fullname);
            r.setEmail(email);
            r.setPhone(phone);
            r.setUserType(type);

            // 2. Tạo mã
            String registrationCode = UUID.randomUUID().toString().substring(0, 6).toUpperCase();
            String checkInId = "ADM-" + (100 + new java.util.Random().nextInt(899)); // Mã do Admin tạo

            r.setRegistrationCode(registrationCode);
            r.setCheckInId(checkInId);

            // 3. Lưu vào CSDL
            Register created = registerService.create(r);

            String typeRedirect = getTypeBySeminarId(seminarId);

            if (created != null) {
                // --- GỬI MAIL VÉ MỜI CHO KHÁCH ---
                try {
                    // Lấy thông tin hội thảo để hiện trong mail
                    Seminar seminar = seminarService.findById(seminarId);
                    String eventName = (seminar != null) ? seminar.getName() : "Hội thảo";
                    String timeStr = (seminar != null && seminar.getStart_date() != null)
                            ? seminar.getStart_date().toString().replace("T", " - ") : "Đang cập nhật";
                    String locationStr = (seminar != null) ? seminar.getLocation() : "HCMUTE";

                    // Tạo QR
                    byte[] qrBytes = QRCodeGenerator.generateQRCodeImage(checkInId, 250, 250);

                    // Link sửa (Sửa đúng link project của bạn)
                    String linkSua = "http://localhost:8080/demofinal4_war_exploded/RegisterServlet?action=verifyUser";

                    // Nội dung Email
                    StringBuilder sb = new StringBuilder();
                    sb.append("<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; border: 1px solid #e0e0e0; border-radius: 8px; overflow: hidden;'>");
                    sb.append("<div style='background-color: #4e73df; padding: 20px; text-align: center; color: white;'><h2 style='margin:0'>VÉ MỜI THAM DỰ</h2></div>");
                    sb.append("<div style='padding: 20px; color: #333;'>");
                    sb.append("<p>Xin chào <b>").append(fullname).append("</b>,</p>");
                    sb.append("<p>Admin đã hỗ trợ bạn đăng ký thành công sự kiện: <b style='color:#4e73df'>").append(eventName).append("</b></p>");
                    sb.append("<p>📅 Thời gian: ").append(timeStr).append("<br>📍 Địa điểm: ").append(locationStr).append("</p>");
                    sb.append("<hr>");
                    sb.append("<div style='background-color: #f0fcf9; padding: 15px; border-left: 5px solid #1cc88a; margin-bottom: 20px;'>");
                    sb.append("<h4 style='margin:0; color:#1cc88a'>🎫 MÃ CHECK-IN CỦA BẠN</h4>");
                    sb.append("<p>Vui lòng đưa mã này hoặc QR đính kèm cho lễ tân:</p>");
                    sb.append("<div style='font-size: 24px; font-weight: bold; text-align: center; letter-spacing: 3px; color: #333; background: #fff; padding: 10px; border: 1px solid #ddd; margin: 10px 0;'>");
                    sb.append(checkInId);
                    sb.append("</div></div>");
                    sb.append("<div style='background-color: #fffcf0; padding: 15px; border-left: 5px solid #f6c23e;'>");
                    sb.append("<h4 style='margin:0; color:#856404'>✏️ TỰ CHỈNH SỬA THÔNG TIN</h4>");
                    sb.append("<p>Mã bảo mật: <b>").append(registrationCode).append("</b></p>");
                    sb.append("<p><a href='").append(linkSua).append("'>Bấm vào đây để kiểm tra/sửa thông tin</a></p>");
                    sb.append("</div></div></div>");

                    EmailUtil.sendEmailWithAttachment(email, "Vé tham dự: " + eventName, sb.toString(), qrBytes);

                } catch (Exception e) {
                    e.printStackTrace();
                    // Mail lỗi thì vẫn báo thêm thành công (nhưng có thể log lại)
                }

                String msg = URLEncoder.encode("Thêm thành công và đã gửi vé!", StandardCharsets.UTF_8);
                resp.sendRedirect("list-user?type=" + typeRedirect + "&msg=" + msg);
            } else {
                // Thêm thất bại (ví dụ email trùng) -> redirect có flag error
                String msg = URLEncoder.encode("Thêm thất bại! Email có thể đã tồn tại.", StandardCharsets.UTF_8);
                resp.sendRedirect("list-user?type=" + typeRedirect + "&msg=" + msg + "&error=1");
            }
        } catch (Exception e) {
            e.printStackTrace();
            String msg = URLEncoder.encode("Lỗi hệ thống!", StandardCharsets.UTF_8);
            resp.sendRedirect("list-user?msg=" + msg + "&error=1");
        }
    }

    private void updateUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            int seminarId = Integer.parseInt(req.getParameter("seminarId"));
            Register r = registerService.findById(id);

            if (r != null) {
                r.setName(req.getParameter("fullname"));
                r.setEmail(req.getParameter("email"));
                r.setPhone(req.getParameter("phone"));
                r.setUserType(req.getParameter("type"));
                r.setSeminarId(seminarId);
                registerService.update(r);
            }

            String typeRedirect = getTypeBySeminarId(seminarId);
            String msg = URLEncoder.encode("Cập nhật thành công!", StandardCharsets.UTF_8);
            resp.sendRedirect("list-user?type=" + typeRedirect + "&msg=" + msg);
        } catch (Exception e) {
            e.printStackTrace();
            String msg = URLEncoder.encode("Cập nhật thất bại!", StandardCharsets.UTF_8);
            resp.sendRedirect("list-user?msg=" + msg + "&error=1");
        }
    }

    private void showAddForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Seminar> seminars = seminarService.findAll();
        req.setAttribute("seminars", seminars);
        req.getRequestDispatcher("/admin-user-form.jsp").forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        Register r = registerService.findById(id);
        List<Seminar> seminars = seminarService.findAll();
        req.setAttribute("user", r);
        req.setAttribute("seminars", seminars);
        req.getRequestDispatcher("/admin-user-form.jsp").forward(req, resp);
    }

}
