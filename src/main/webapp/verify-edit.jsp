<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Xác thực sửa thông tin - LHQ SEMINAR</title>

    <!-- CSS chung -->
    <link href="img/favicon.ico" rel="icon">

    <!-- Bootstrap & fonts giống các trang khác -->
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans&family=Space+Grotesk&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">

    <style>
        .verify-wrapper {
            min-height: 60vh;
        }
        .verify-card {
            max-width: 520px;
            width: 100%;
            border-radius: 16px;
        }
        .verify-header-icon {
            width: 56px;
            height: 56px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: rgba(13,110,253,0.08);
            color: #0d6efd;
            font-size: 1.7rem;
        }
        .form-label {
            font-weight: 600;
        }
    </style>
</head>
<body class="bg-light">

<%@ include file="navbar.jsp" %>

<%
    String msg = (String) request.getAttribute("msg");
    String successMsg = (String) request.getAttribute("msg_success");
%>

<!-- Nội dung chính -->
<div class="container verify-wrapper py-5">
    <div class="row justify-content-center">
        <div class="col-md-10 col-lg-6">
            <div class="card shadow-lg border-0 mx-auto verify-card">
                <div class="card-body p-4 p-md-5">

                    <!-- Header -->
                    <div class="text-center mb-4">
                        <div class="verify-header-icon mb-3">
                            <i class="bi bi-shield-lock"></i>
                        </div>
                        <h4 class="text-primary fw-bold mb-1">Xác thực sửa thông tin</h4>
                        <p class="text-muted mb-0">
                            Vui lòng nhập <strong>email</strong> và <strong>mã chỉnh sửa</strong> đã được gửi tới email của bạn
                            để tiếp tục thay đổi thông tin đăng ký.
                        </p>
                    </div>

                    <!-- Thông báo -->
                    <%
                        if (msg != null && !msg.isEmpty()) {
                    %>
                    <div class="alert alert-danger small mb-3">
                        <i class="bi bi-exclamation-triangle me-1"></i>
                        <%= msg %>
                    </div>
                    <%
                        }
                        if (successMsg != null && !successMsg.isEmpty()) {
                    %>
                    <div class="alert alert-success small mb-3">
                        <i class="bi bi-check-circle me-1"></i>
                        <%= successMsg %>
                    </div>
                    <%
                        }
                    %>

                    <!-- Form -->
                    <form action="RegisterServlet" method="GET">
                        <input type="hidden" name="action" value="verifyUser">

                        <div class="mb-3">
                            <label class="form-label">Email đã đăng ký</label>
                            <input type="email"
                                   name="email"
                                   class="form-control"
                                   placeholder="Nhập email bạn đã dùng để đăng ký"
                                   required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Mã chỉnh sửa</label>
                            <input type="text"
                                   name="code"
                                   class="form-control"
                                   placeholder="Nhập mã chỉnh sửa trong email"
                                   required>
                            <small class="text-muted">
                                Nếu bạn chưa nhận được mã, vui lòng kiểm tra hộp thư rác (Spam/Junk).
                            </small>
                        </div>

                        <div class="d-flex justify-content-between align-items-center mt-4">
                            <a href="home.jsp" class="btn btn-outline-secondary btn-sm">
                                <i class="bi bi-arrow-left me-1"></i> Quay lại trang chủ
                            </a>
                            <button type="submit" class="btn btn-primary px-4">
                                <i class="bi bi-check2-circle me-1"></i> Xác thực
                            </button>
                        </div>
                    </form>

                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>

<!-- JS chung -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="lib/wow/wow.min.js"></script>
<script src="lib/easing/easing.min.js"></script>
<script src="lib/waypoints/waypoints.min.js"></script>
<script src="lib/owlcarousel/owl.carousel.min.js"></script>
<script src="js/main.js"></script>

</body>
</html>
