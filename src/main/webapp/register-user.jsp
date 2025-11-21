<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="model.Seminar" %>

<%
    Seminar seminar = (Seminar) request.getAttribute("seminar");
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage   = (String) request.getAttribute("errorMessage");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <title>Đăng ký hội thảo</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="lib/animate/animate.min.css" rel="stylesheet">
    <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
</head>

<body>
<%@ include file="navbar.jsp" %>
<!-- Spinner Start -->
<div id="spinner"
     class="show bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center">
    <div class="spinner-grow text-primary" style="width: 3rem; height: 3rem;" role="status">
        <span class="sr-only">Loading...</span>
    </div>
</div>
<!-- Spinner End -->
<!-- Hero Start -->
<div class="container-fluid py-5">
    <div class="container py-5">
        <div class="text-center wow fadeIn" data-wow-delay="0.1s">
            <h1 class="mb-3">
                <span class="text-uppercase text-primary bg-light px-2">Đăng ký</span>
            </h1>
            <p class="mb-0">
                <% if (seminar != null) { %>
                Bạn đang đăng ký tham gia: <strong><%= seminar.getName() %></strong>
                <% } %>
            </p>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-7">

                <!-- ALERT THÀNH CÔNG / LỖI -->
                <% if (successMessage != null) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle me-2"></i> <%= successMessage %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% } else if (errorMessage != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle me-2"></i> <%= errorMessage %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <% } %>

                <p class="text-center mb-4">
                    Vui lòng điền thông tin của bạn vào biểu mẫu bên dưới để đăng ký tham gia
                    <strong>hội thảo</strong>.
                </p>

                <div class="wow fadeIn" data-wow-delay="0.3s">
                    <!-- FORM GỬI DỮ LIỆU -->
                    <form action="<%= request.getContextPath() %>/RegisterServlet" method="post">
                        <div class="row g-3">

                            <!-- seminarId ẩn -->
                            <% if (seminar != null) { %>
                            <input type="hidden" name="seminarId" value="<%= seminar.getId() %>">
                            <% } %>

                            <!-- Họ tên -->
                            <div class="col-md-6">
                                <div class="form-floating">
                                    <input type="text" class="form-control" id="fullname" name="fullname"
                                           placeholder="Họ và tên" required>
                                    <label for="fullname">Họ và tên</label>
                                </div>
                            </div>

                            <!-- Email -->
                            <div class="col-md-6">
                                <div class="form-floating">
                                    <input type="email" class="form-control" id="email" name="email"
                                           placeholder="Email" required>
                                    <label for="email">Email</label>
                                </div>
                            </div>

                            <!-- Số điện thoại -->
                            <div class="col-md-6">
                                <div class="form-floating">
                                    <input type="text" class="form-control" id="phone" name="phone"
                                           placeholder="Số điện thoại"
                                           maxlength="11" pattern="[0-9]{10,11}" required
                                           oninput="this.value = this.value.replace(/[^0-9]/g, '');">
                                    <label for="phone">Số điện thoại</label>
                                </div>
                            </div>

                            <!-- Loại khách -->
                            <div class="col-md-6">
                                <div class="form-floating">
                                    <select class="form-select" id="type" name="type" required>
                                        <option value="" selected disabled>Chọn loại khách</option>
                                        <option value="Sinh viên">Sinh viên</option>
                                        <option value="Giảng viên">Giảng viên</option>
                                        <option value="Khách tự do">Khách tự do</option>
                                    </select>
                                    <label for="type">Loại khách</label>
                                </div>
                            </div>

                            <!-- Nút gửi -->
                            <div class="col-12">
                                <button class="btn btn-primary w-100 py-3" type="submit">Gửi đăng ký</button>
                            </div>
                        </div>
                    </form>
                    <!-- END FORM -->
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Hero End -->

<%@ include file="footer.jsp" %>

<!-- JS -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="lib/wow/wow.min.js"></script>
<script src="lib/easing/easing.min.js"></script>
<script src="lib/waypoints/waypoints.min.js"></script>
<script src="lib/owlcarousel/owl.carousel.min.js"></script>
<script src="js/main.js"></script>
</body>
</html>
