<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="model.Seminar" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // 1. Lấy thông tin Seminar
    Seminar seminar = (Seminar) request.getAttribute("seminar");
    if (seminar == null) {
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Không tìm thấy hội thảo</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container py-5">
    <h3>Không tìm thấy hội thảo.</h3>
    <a href="<%= request.getContextPath() %>/home.jsp" class="btn btn-primary mt-3">
        Quay lại trang chủ
    </a>
</div>
</body>
</html>
<%
        return;
    }

    // --- 2. LOGIC XỬ LÝ THỜI GIAN & TRẠNG THÁI ---
    Date now = new Date();
    SimpleDateFormat sdf = new SimpleDateFormat("HH:mm dd/MM/yyyy");

    // A. Xử lý ngày mở
    Date openTime = seminar.getRegistrationOpen();
    if (openTime == null) openTime = new Date(0); // Mặc định mở từ quá khứ

    // B. Xử lý ngày đóng (Tự động trừ 1 ngày nếu Admin không set)
    Date closeTime = seminar.getRegistrationDeadline();
    boolean isAutoDeadline = false; // Cờ đánh dấu để hiện chú thích

    if (closeTime == null) {
        if (seminar.getStart_date() != null) {
            // Trừ 1 ngày (24h) so với giờ bắt đầu sự kiện
            closeTime = java.sql.Timestamp.valueOf(seminar.getStart_date().minusDays(1));
            isAutoDeadline = true;
        } else {
            closeTime = new Date(); // Fallback an toàn
        }
    }

    // C. Tính toán trạng thái
    boolean isNotYetOpen = now.before(openTime);
    boolean isClosed = now.after(closeTime);
%>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title><%= seminar.getName() %> - LHQ SEMINAR</title>
    <link href="img/favicon.ico" rel="icon">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans&family=Space+Grotesk&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="lib/animate/animate.min.css" rel="stylesheet">
    <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
</head>

<body>

<%@ include file="navbar.jsp" %>

<div class="container-fluid bg-light py-4 mb-4">
    <div class="container">
        <h3 class="mb-1"><i class="bi bi-calendar-event"></i> Chi tiết hội thảo</h3>
        <p class="mb-0 text-muted"><%= seminar.getName() %></p>
    </div>
</div>

<div class="container py-4">
    <div class="row g-4">
        <div class="col-md-5">
            <%
                String img = seminar.getImage();
                if (img == null || img.isBlank()) {
                    img = "img/default-seminar.jpg";
                }
            %>
            <img src="<%= img %>" alt="Ảnh hội thảo" class="img-fluid rounded shadow-sm mb-3">

            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <h5 class="card-title mb-3">Thông tin nhanh</h5>

                    <p class="mb-2">
                        <i class="bi bi-people-fill text-primary me-2"></i>
                        Số lượng tối đa: <strong><%= seminar.getMaxAttendance() %></strong>
                    </p>

                    <p class="mb-2">
                        <i class="bi bi-info-circle text-primary me-2"></i>
                        Trạng thái:
                        <% if (isNotYetOpen) { %>
                        <span class="badge bg-warning text-dark">Sắp mở đăng ký</span>
                        <% } else if (isClosed) { %>
                        <span class="badge bg-danger">Đã đóng đăng ký</span>
                        <% } else { %>
                        <span class="badge bg-success">Đang mở đăng ký</span>
                        <% } %>
                    </p>

                    <hr>

                    <p class="mb-1 text-muted small"><i class="bi bi-hourglass-top me-1"></i> Thời gian mở đăng ký:</p>
                    <p class="fw-bold text-dark ms-4">
                        <%= (seminar.getRegistrationOpen() != null) ? sdf.format(seminar.getRegistrationOpen()) : "Đang mở" %>
                    </p>

                    <p class="mb-1 text-muted small"><i class="bi bi-hourglass-bottom me-1"></i> Thời gian đóng đăng ký:</p>
                    <p class="fw-bold text-danger ms-4">
                        <%= sdf.format(closeTime) %>
                        <% if (isAutoDeadline) { %>
                        <br><span class="badge bg-light text-muted fw-normal" style="font-size: 0.75rem;">(Tự động đóng trước 1 ngày)</span>
                        <% } %>
                    </p>
                </div>
            </div>
        </div>

        <div class="col-md-7">
            <h2 class="mb-3"><%= seminar.getName() %></h2>

            <p class="text-muted mb-2">
                <i class="bi bi-calendar-week"></i>
                Thời gian diễn ra:
                <strong><%= seminar.getStart_date() %></strong>
                –
                <strong><%= seminar.getEnd_date() %></strong>
            </p>

            <p class="text-muted mb-2">
                <i class="bi bi-geo-alt"></i>
                Địa điểm:
                <strong><%= seminar.getLocation() %></strong>
            </p>

            <p class="text-muted mb-4">
                <i class="bi bi-person-circle"></i>
                Diễn giả:
                <strong><%= seminar.getSpeaker() %></strong>
            </p>

            <h5 class="mb-2">Mô tả hội thảo</h5>
            <p class="mb-4">
                <%= seminar.getDescription() %>
            </p>

            <div class="mt-4">
                <% if (isNotYetOpen) { %>
                <div class="alert alert-warning">
                    <i class="bi bi-alarm"></i> Chưa đến giờ đăng ký!<br>
                    Cổng mở lúc: <strong><%= sdf.format(openTime) %></strong>
                </div>
                <button class="btn btn-secondary btn-lg px-4" disabled>
                    <i class="bi bi-lock-fill me-1"></i> Chưa mở đăng ký
                </button>

                <% } else if (isClosed) { %>
                <div class="alert alert-danger">
                    <i class="bi bi-x-circle"></i> Đã hết hạn đăng ký!<br>
                    Cổng đã đóng lúc: <strong><%= sdf.format(closeTime) %></strong>
                </div>
                <button class="btn btn-secondary btn-lg px-4" disabled>
                    <i class="bi bi-x-octagon-fill me-1"></i> Đã đóng đăng ký
                </button>

                <% } else { %>
                <a href="<%= request.getContextPath() %>/register_user?seminarId=<%= seminar.getId() %>"
                   class="btn btn-primary btn-lg px-4">
                    <i class="bi bi-check2-circle me-1"></i> Đăng ký tham dự
                </a>
                <% } %>

                <a href="<%= request.getContextPath() %>/home.jsp"
                   class="btn btn-outline-secondary btn-lg ms-2">
                    Quay lại trang chủ
                </a>
            </div>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="lib/wow/wow.min.js"></script>
<script src="lib/easing/easing.min.js"></script>
<script src="lib/waypoints/waypoints.min.js"></script>
<script src="lib/owlcarousel/owl.carousel.min.js"></script>
<script src="js/main.js"></script>
</body>
</html>