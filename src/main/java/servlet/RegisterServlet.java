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
import service.SeminarService;
import serviceImpl.SeminarServiceImpl;
import utils.EmailUtil;
import utils.DataSourceUtil;

import javax.sql.DataSource;
import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.UUID;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    private RegisterRepository registerRepository;
    private SeminarService seminarService;

    @Override
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        DataSource ds = DataSourceUtil.getDataSource();
        this.registerRepository = new RegisterRepositoryImpl(ds);
        this.seminarService = new SeminarServiceImpl(ds);
    }

    // --- XỬ LÝ LINK TỪ EMAIL & XÁC THỰC ĐỂ SỬA (GET) ---
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("verifyUser".equals(action)) {
            String email = req.getParameter("email");
            String code = req.getParameter("code");

            if (email != null && code != null) {
                Register r = registerRepository.findByEmailAndCode(email, code);

                if (r != null) {
                    // Check hạn sửa (dùng hàm isExpiredForEdit riêng ở dưới)
                    if (isExpiredForEdit(r.getSeminarId())) {
                        req.setAttribute("msg", "❌ Đã quá hạn chỉnh sửa thông tin! Sự kiện đã hoặc đang diễn ra.");
                    } else {
                        req.setAttribute("register", r);
                        Seminar s = seminarService.findById(r.getSeminarId());
                        if (s != null) r.setEventName(s.getName());

                        req.getRequestDispatcher("/user-edit.jsp").forward(req, resp);
                        return;
                    }
                } else {
                    req.setAttribute("msg", "❌ Email hoặc Mã chỉnh sửa không đúng.");
                }
            }
            req.getRequestDispatcher("/verify-edit.jsp").forward(req, resp);
        }
    }

    // --- XỬ LÝ ĐĂNG KÝ & CẬP NHẬT (POST) ---
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        // === TRƯỜNG HỢP 1: CẬP NHẬT THÔNG TIN (SỬA) ===
        if ("updateUser".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));

            Register current = registerRepository.findById(id);
            if (current == null) {
                request.setAttribute("msg", "Không tìm thấy thông tin.");
                request.getRequestDispatcher("/verify-edit.jsp").forward(request, response);
                return;
            }

            if (isExpiredForEdit(current.getSeminarId())) {
                request.setAttribute("msg", "❌ Lỗi: Đã quá hạn chỉnh sửa! Thay đổi không được lưu.");
                request.getRequestDispatcher("/verify-edit.jsp").forward(request, response);
                return;
            }

            current.setName(request.getParameter("fullname"));
            current.setPhone(request.getParameter("phone"));
            current.setUserType(request.getParameter("type"));

            registerRepository.update(current);

            request.setAttribute("msg_success", "✅ Cập nhật thông tin thành công!");
            request.getRequestDispatcher("/verify-edit.jsp").forward(request, response);
            return;
        }

        // === TRƯỜNG HỢP 2: ĐĂNG KÝ MỚI ===

        String seminarIdStr = request.getParameter("seminarId");
        String fullname     = request.getParameter("fullname");
        String email        = request.getParameter("email");
        String phone        = request.getParameter("phone");
        String type         = request.getParameter("type");

        int seminarId = 0;
        try { seminarId = Integer.parseInt(seminarIdStr); } catch (Exception e) {}

        Seminar seminar = null;
        if (seminarId > 0) seminar = seminarService.findById(seminarId);
        request.setAttribute("seminar", seminar);

        // ============================================================
        // 🛡️ BẢO MẬT CẤP 2: CHẶN LƯU DB NẾU HẾT HẠN (QUAN TRỌNG)
        // ============================================================
        if (seminar != null) {
            Date now = new Date();
            Date closeTime = seminar.getRegistrationDeadline();

            // Logic tự động đóng trước 1 ngày nếu không set deadline
            if (closeTime == null) {
                if (seminar.getStart_date() != null) {
                    LocalDateTime defaultDeadline = seminar.getStart_date().minusDays(1);
                    closeTime = Timestamp.valueOf(defaultDeadline);
                } else {
                    closeTime = new Date();
                }
            }

            // Kiểm tra ngày mở
            Date openTime = seminar.getRegistrationOpen();
            if (openTime != null && now.before(openTime)) {
                request.setAttribute("errorMessage", "❌ Chưa đến thời gian đăng ký.");
                request.getRequestDispatcher("/register-user.jsp").forward(request, response);
                return;
            }

            // Kiểm tra ngày đóng
            if (now.after(closeTime)) {
                request.setAttribute("errorMessage", "❌ Đã hết hạn đăng ký. Không thể thực hiện thao tác này.");
                request.getRequestDispatcher("/register-user.jsp").forward(request, response);
                return;
            }
        }
        // ============================================================


        if (seminarId <= 0 || fullname == null || fullname.isBlank() || email == null || email.isBlank()) {
            request.setAttribute("errorMessage", "Dữ liệu không hợp lệ.");
            request.getRequestDispatcher("/register-user.jsp").forward(request, response);
            return;
        }

        // ... (Phần tạo mã và gửi email giữ nguyên như cũ) ...
        String registrationCode = UUID.randomUUID().toString().substring(0, 6).toUpperCase();
        String checkInId = "EVT-" + (100 + new java.util.Random().nextInt(899));

        Register r = new Register();
        r.setSeminarId(seminarId);
        r.setName(fullname);
        r.setEmail(email);
        r.setPhone(phone);
        r.setUserType(type);
        r.setRegistrationCode(registrationCode);
        r.setCheckInId(checkInId);

        Register created = registerRepository.create(r);

        if (created != null) {
            try {
                String eventName = (seminar != null) ? seminar.getName() : "Hội thảo";
                String timeStr = (seminar != null && seminar.getStart_date() != null) ? seminar.getStart_date().toString().replace("T", " - ") : "Đang cập nhật";
                String locationStr = (seminar != null) ? seminar.getLocation() : "HCMUTE";
                byte[] qrBytes = QRCodeGenerator.generateQRCodeImage(checkInId, 250, 250);

                // CẬP NHẬT URL CHO ĐÚNG VỚI PROJECT CỦA BẠN
                String linkSua = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/RegisterServlet?action=verifyUser";

                StringBuilder sb = new StringBuilder();
                sb.append("<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; border: 1px solid #e0e0e0; border-radius: 8px; overflow: hidden;'>");
                sb.append("<div style='background-color: #4e73df; padding: 20px; text-align: center; color: white;'><h2 style='margin:0'>XÁC NHẬN ĐĂNG KÝ</h2></div>");
                sb.append("<div style='padding: 20px; color: #333;'>");
                sb.append("<p>Xin chào <b>").append(fullname).append("</b>,</p>");
                sb.append("<p>Bạn đã đăng ký thành công sự kiện: <b style='color:#4e73df'>").append(eventName).append("</b></p>");
                sb.append("<p>📅 Thời gian: ").append(timeStr).append("<br>📍 Địa điểm: ").append(locationStr).append("</p>");
                sb.append("<hr>");
                sb.append("<div style='background-color: #f0fcf9; padding: 15px; border-left: 5px solid #1cc88a; margin-bottom: 20px;'>");
                sb.append("<h4 style='margin:0; color:#1cc88a'>🎫 THÔNG TIN CHECK-IN</h4>");
                sb.append("<p>Mã vé của bạn: <b style='font-size:18px'>").append(checkInId).append("</b></p>");
                sb.append("</div>");
                sb.append("<div style='background-color: #fffcf0; padding: 15px; border-left: 5px solid #f6c23e;'>");
                sb.append("<h4 style='margin:0; color:#856404'>✏️ SỬA THÔNG TIN</h4>");
                sb.append("<p>Mã bảo mật: <b>").append(registrationCode).append("</b></p>");
                sb.append("<p><a href='").append(linkSua).append("'>Bấm vào đây để sửa thông tin</a></p>");
                sb.append("</div>");
                sb.append("</div></div>");

                EmailUtil.sendEmailWithAttachment(email, "Vé tham dự: " + eventName, sb.toString(), qrBytes);

            } catch (Exception e) {
                e.printStackTrace();
            }

            request.setAttribute("successMessage", "Đăng ký thành công! Vé đã được gửi đến email của bạn.");
            request.removeAttribute("fullname");
            request.removeAttribute("email");
            request.removeAttribute("phone");
        } else {
            request.setAttribute("errorMessage", "Đăng ký thất bại. Có thể email đã được sử dụng.");
        }

        request.getRequestDispatcher("/register-user.jsp").forward(request, response);
    }

    // Hàm check hạn cho việc SỬA thông tin (Cho phép sửa đến ngày diễn ra)
    private boolean isExpiredForEdit(int seminarId) {
        Seminar seminar = seminarService.findById(seminarId);
        if (seminar == null || seminar.getStart_date() == null) {
            return false;
        }
        LocalDate today = LocalDate.now();
        LocalDate eventDate = seminar.getStart_date().toLocalDate();
        // Nếu hôm nay > ngày sự kiện -> Không cho sửa nữa
        return today.isAfter(eventDate);
    }
}