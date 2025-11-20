<%@ page import="model.Register" %>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <title>Lễ tân Check-in</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f0f2f5; }
        .checkin-card { max-width: 600px; margin: 50px auto; border-radius: 15px; overflow: hidden; }
        .form-control-lg { font-size: 1.5rem; letter-spacing: 2px; text-align: center; }
        .user-info { background-color: #e8f5e9; border-left: 5px solid #28a745; padding: 20px; margin-top: 20px; border-radius: 4px; }
        .warning-info { background-color: #fff3cd; border-left: 5px solid #ffc107; padding: 20px; margin-top: 20px; border-radius: 4px; }
    </style>
</head>
<body>

<div class="container">
    <div class="card checkin-card shadow">
        <div class="card-header bg-primary text-white text-center py-3">
            <h3 class="mb-0"><i class="fas fa-qrcode"></i> CỔNG CHECK-IN</h3>
        </div>
        <div class="card-body p-4">

            <form action="check-in" method="post">
                <div class="mb-4 text-center">
                    <label class="form-label text-muted">Đặt con trỏ vào ô dưới và quét mã QR</label>
                    <input type="text" name="checkInCode" class="form-control form-control-lg"
                           placeholder="Quét hoặc nhập mã..." autofocus autocomplete="off">
                </div>
                <div class="d-grid">
                    <button type="submit" class="btn btn-primary btn-lg">KIỂM TRA / CHECK-IN</button>
                </div>
            </form>

            <%-- KHU VỰC HIỂN THỊ KẾT QUẢ --%>

            <%-- 1. Lỗi (Mã không đúng) --%>
            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger mt-3 text-center">
                <h4><%= request.getAttribute("error") %></h4>
            </div>
            <% } %>

            <%-- 2. Cảnh báo (Đã check-in rồi) --%>
            <% if (request.getAttribute("warning") != null) { %>
            <div class="alert alert-warning mt-3 text-center">
                <h4><%= request.getAttribute("warning") %></h4>
            </div>
            <% } %>

            <%-- 3. Thành công --%>
            <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success mt-3 text-center">
                <h1><%= request.getAttribute("success") %></h1>
            </div>
            <% } %>

            <%-- HIỂN THỊ THÔNG TIN KHÁCH HÀNG (Nếu tìm thấy) --%>
            <% Register r = (Register) request.getAttribute("register"); %>
            <% if (r != null) { %>
            <div class="<%= request.getAttribute("warning") != null ? "warning-info" : "user-info" %>">
                <h4 class="text-primary mb-3"><%= r.getName() %></h4>
                <p><i class="fas fa-envelope"></i> <%= r.getEmail() %></p>
                <p><i class="fas fa-phone"></i> <%= r.getPhone() %></p>
                <p><i class="fas fa-id-badge"></i> Loại: <strong><%= r.getUserType() %></strong>
                    <% if(r.isVip()) { %> <span class="badge bg-warning text-dark">VIP</span> <% } %>
                </p>
                <hr>
                <p><i class="fas fa-calendar-check"></i> Tham gia: <strong><%= r.getEventName() %></strong></p>
                <p><i class="fas fa-clock"></i> Giờ Check-in: <strong><%= r.getCheckinTime() %></strong></p>
            </div>

            <div class="text-center mt-4">
                <a href="check-in" class="btn btn-outline-secondary">Quét người tiếp theo (F5)</a>
            </div>
            <% } %>

        </div>
    </div>
</div>

</body>
</html>