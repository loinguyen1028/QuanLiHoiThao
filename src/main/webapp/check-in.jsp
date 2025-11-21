<%@ page import="model.Register" %>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <title>Cổng Check-in - LHQ SEMINAR</title>

    <!-- Favicon -->
    <link href="img/favicon.ico" rel="icon">

    <!-- Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans&family=Space+Grotesk&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Bootstrap & style -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">

    <style>
        body {
            background-color: #f0f2f5;
        }
        .checkin-wrapper {
            min-height: 65vh;
        }
        .checkin-card {
            max-width: 650px;
            margin: 30px auto;
            border-radius: 18px;
            overflow: hidden;
        }
        .form-control-lg {
            font-size: 1.5rem;
            letter-spacing: 2px;
            text-align: center;
        }
        .user-info {
            background-color: #e8f5e9;
            border-left: 5px solid #28a745;
            padding: 20px;
            margin-top: 20px;
            border-radius: 4px;
        }
        .warning-info {
            background-color: #fff3cd;
            border-left: 5px solid #ffc107;
            padding: 20px;
            margin-top: 20px;
            border-radius: 4px;
        }
    </style>
</head>
<body>

<%@ include file="navbar.jsp" %>

<div class="container checkin-wrapper">
    <div class="card checkin-card shadow-lg border-0">
        <div class="card-header bg-primary text-white text-center py-3">
            <h3 class="mb-0">
                <i class="fas fa-qrcode me-2"></i>
                CỔNG CHECK-IN LỄ TÂN
            </h3>
            <small class="text-white-50">
                Đặt con trỏ vào ô nhập &amp; quét mã QR, hệ thống sẽ tự động nhận diện.
            </small>
        </div>

        <div class="card-body p-4">

            <!-- Form quét mã -->
            <form action="check-in" method="post">
                <div class="mb-4 text-center">
                    <label class="form-label text-muted mb-2">
                        Quét mã QR hoặc nhập mã check-in
                    </label>
                    <input type="text"
                           name="checkInCode"
                           class="form-control form-control-lg"
                           placeholder="Quét hoặc nhập mã..."
                           autofocus
                           autocomplete="off">
                </div>
                <div class="d-grid">
                    <button type="submit" class="btn btn-primary btn-lg">
                        <i class="bi bi-search me-1"></i> KIỂM TRA / CHECK-IN
                    </button>
                </div>
            </form>

            <!-- Kết quả -->
            <%
                Object error = request.getAttribute("error");
                Object warning = request.getAttribute("warning");
                Object success = request.getAttribute("success");
            %>

            <%-- 1. Lỗi (Mã không đúng) --%>
            <% if (error != null) { %>
            <div class="alert alert-danger mt-3 text-center">
                <h5 class="mb-0"><%= error %></h5>
            </div>
            <% } %>

            <%-- 2. Cảnh báo (Đã check-in rồi) --%>
            <% if (warning != null) { %>
            <div class="alert alert-warning mt-3 text-center">
                <h5 class="mb-0"><%= warning %></h5>
            </div>
            <% } %>

            <%-- 3. Thành công --%>
            <% if (success != null) { %>
            <div class="alert alert-success mt-3 text-center">
                <h3 class="mb-0"><%= success %></h3>
            </div>
            <% } %>

            <%-- HIỂN THỊ THÔNG TIN KHÁCH HÀNG (Nếu tìm thấy) --%>
            <%
                Register r = (Register) request.getAttribute("register");
                if (r != null) {
            %>
            <div class="<%= (warning != null ? "warning-info" : "user-info") %>">
                <h4 class="text-primary mb-3"><i class="fas fa-user me-2"></i><%= r.getName() %></h4>
                <p class="mb-1">
                    <i class="fas fa-envelope me-2"></i>
                    <%= r.getEmail() %>
                </p>
                <p class="mb-1">
                    <i class="fas fa-phone me-2"></i>
                    <%= r.getPhone() %>
                </p>
                <p class="mb-1">
                    <i class="fas fa-id-badge me-2"></i>
                    Loại: <strong><%= r.getUserType() %></strong>
                    <% if (r.isVip()) { %>
                    <span class="badge bg-warning text-dark ms-2">VIP</span>
                    <% } %>
                </p>
                <hr>
                <p class="mb-1">
                    <i class="fas fa-calendar-check me-2"></i>
                    Tham gia: <strong><%= r.getEventName() %></strong>
                </p>
                <p class="mb-0">
                    <i class="fas fa-clock me-2"></i>
                    Giờ Check-in: <strong><%= r.getCheckinTime() %></strong>
                </p>
            </div>

            <div class="text-center mt-4">
                <a href="check-in" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-repeat me-1"></i> Quét người tiếp theo
                </a>
            </div>
            <% } %>

        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>

<!-- JS -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
