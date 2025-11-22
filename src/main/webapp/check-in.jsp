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
            font-family: 'Nunito', sans-serif;
            background-color: #f8f9fc; /* đồng bộ với admin/list-user */
        }

        .checkin-wrapper {
            min-height: 65vh;
        }

        .checkin-card {
            max-width: 650px;
            margin: 40px auto;
            border-radius: 18px;
            overflow: hidden;
            border: none;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
        }

        .checkin-header {
            background: linear-gradient(135deg, #4e73df, #1cc88a);
        }

        .checkin-header h3 {
            font-weight: 700;
            letter-spacing: 0.05em;
        }

        .checkin-subtitle {
            font-size: 0.9rem;
        }

        .form-control-lg {
            font-size: 1.5rem;
            letter-spacing: 2px;
            text-align: center;
            border-radius: 999px;
            border: 1px solid #d1d3e2;
        }

        .form-control-lg:focus {
            box-shadow: 0 0 0 0.2rem rgba(78, 115, 223, 0.25);
            border-color: #4e73df;
        }

        .btn-primary {
            background-color: #4e73df;
            border-color: #4e73df;
            border-radius: 999px;
            font-weight: 600;
        }

        .btn-primary:hover {
            background-color: #2e59d9;
            border-color: #2e59d9;
        }

        .btn-outline-secondary {
            border-radius: 999px;
        }

        .qr-toggle-btn {
            border-radius: 999px;
            font-size: 0.85rem;
            padding: 6px 14px;
            background-color: rgba(255, 255, 255, 0.15);
            border: 1px solid rgba(255, 255, 255, 0.5);
            color: #fff;
        }

        .qr-toggle-btn:hover {
            background-color: rgba(255, 255, 255, 0.25);
            color: #fff;
        }

        .user-info {
            background-color: #e8f5ff;
            border-left: 5px solid #4e73df;
            padding: 20px;
            margin-top: 20px;
            border-radius: 10px;
        }

        .warning-info {
            background-color: #fff3cd;
            border-left: 5px solid #ffc107;
            padding: 20px;
            margin-top: 20px;
            border-radius: 10px;
        }

        .alert {
            border-radius: 12px;
        }
    </style>
</head>
<body>

<%@ include file="navbar.jsp" %>

<div class="container checkin-wrapper">
    <div class="card checkin-card">
        <div class="card-header checkin-header text-white py-3">
            <div class="d-flex justify-content-between align-items-center">
                <div class="text-center flex-grow-1">
                    <h3 class="mb-1 text-uppercase">
                        <i class="fas fa-qrcode me-2"></i>
                        CỔNG CHECK-IN LỄ TÂN
                    </h3>
                    <small class="text-white-50 checkin-subtitle">
                        Đặt con trỏ vào ô nhập &amp; quét mã QR, hệ thống sẽ tự động nhận diện.
                    </small>
                </div>
                <!-- Icon chuyển sang chế độ quét QR (chưa có chức năng) -->
                <div class="ms-3 d-none d-md-block">
                    <button type="button"
                            class="qr-toggle-btn"
                            title="Chuyển sang chế độ quét QR bằng camera (sắp ra mắt)">
                        <i class="fas fa-camera me-1"></i> QR
                    </button>
                </div>
            </div>
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
            <div class="alert alert-danger mt-3 text-center shadow-sm">
                <h5 class="mb-0">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    <%= error %>
                </h5>
            </div>
            <% } %>

            <%-- 2. Cảnh báo (Đã check-in rồi) --%>
            <% if (warning != null) { %>
            <div class="alert alert-warning mt-3 text-center shadow-sm">
                <h5 class="mb-0">
                    <i class="fas fa-info-circle me-2"></i>
                    <%= warning %>
                </h5>
            </div>
            <% } %>

            <%-- 3. Thành công --%>
            <% if (success != null) { %>
            <div class="alert alert-success mt-3 text-center shadow-sm">
                <h3 class="mb-0"><%= success %></h3>
            </div>

            <% } %>

            <%-- HIỂN THỊ THÔNG TIN KHÁCH HÀNG (Nếu tìm thấy) --%>
            <%
                Register r = (Register) request.getAttribute("register");
                if (r != null) {
            %>
            <div class="<%= (warning != null ? "warning-info" : "user-info") %>">
                <h4 class="text-primary mb-3">
                    <i class="fas fa-user me-2"></i>
                    <%= r.getName() %>
                </h4>
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
