<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="model.Seminar" %>

<%
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
%>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title><%= seminar.getName() %> - LHQ SEMINAR</title>

    <!-- Favicon -->
    <link href="img/favicon.ico" rel="icon">

    <!-- Google Web Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans&family=Space+Grotesk&display=swap" rel="stylesheet">

    <!-- Icon Font Stylesheet -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Libraries Stylesheet -->
    <link href="lib/animate/animate.min.css" rel="stylesheet">
    <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">

    <!-- Customized Bootstrap Stylesheet -->
    <link href="css/bootstrap.min.css" rel="stylesheet">

    <!-- Template Stylesheet -->
    <link href="css/style.css" rel="stylesheet">
</head>

<body>

<%@ include file="navbar.jsp" %>

<!-- Header nhỏ -->
<div class="container-fluid bg-light py-4 mb-4">
    <div class="container">
        <h3 class="mb-1"><i class="bi bi-calendar-event"></i> Chi tiết hội thảo</h3>
        <p class="mb-0 text-muted"><%= seminar.getName() %></p>
    </div>
</div>

<div class="container py-4">
    <div class="row g-4">
        <!-- Ảnh hội thảo -->
        <div class="col-md-5">
            <%
                String img = seminar.getImage();
                if (img == null || img.isBlank()) {
                    img = "img/default-seminar.jpg"; // ảnh mặc định nếu chưa có
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
                        <span class="badge bg-success"><%= seminar.getStatus() %></span>
                    </p>
                </div>
            </div>
        </div>

        <!-- Thông tin chi tiết -->
        <div class="col-md-7">
            <h2 class="mb-3"><%= seminar.getName() %></h2>

            <p class="text-muted mb-2">
                <i class="bi bi-calendar-week"></i>
                Thời gian:
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

            <!-- Nút Đăng ký -->
            <div class="mt-4">
                <a href="<%= request.getContextPath() %>/register_user?seminarId=<%= seminar.getId() %>"
                   class="btn btn-primary btn-lg px-4">
                    <i class="bi bi-check2-circle me-1"></i> Đăng ký tham dự
                </a>
                <a href="<%= request.getContextPath() %>/home.jsp"
                   class="btn btn-outline-secondary btn-lg ms-2">
                    Quay lại trang chủ
                </a>
            </div>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>

<!-- JavaScript Libraries -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="lib/wow/wow.min.js"></script>
<script src="lib/easing/easing.min.js"></script>
<script src="lib/waypoints/waypoints.min.js"></script>
<script src="lib/owlcarousel/owl.carousel.min.js"></script>

<!-- Template Javascript -->
<script src="js/main.js"></script>
</body>
</html>
