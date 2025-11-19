<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Xác thực sửa thông tin</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-4" style="background-color: #f8f9fa;">

<div class="container">
    <div class="card shadow-lg border-0 mx-auto" style="max-width: 500px;">
        <div class="card-body">
            <h4 class="text-center text-primary mb-4 fw-bold">🔐 Xác thực thông tin</h4>
            <p class="text-center text-muted">Vui lòng nhập email và mã chỉnh sửa (trong email) để thay đổi thông tin.</p>

            <% String msg = (String) request.getAttribute("msg"); %>
            <% if (msg != null && !msg.isEmpty()) { %>
            <div class="alert alert-danger"><%= msg %></div>
            <% } %>

            <% String successMsg = (String) request.getAttribute("msg_success"); %>
            <% if (successMsg != null && !successMsg.isEmpty()) { %>
            <div class="alert alert-success"><%= successMsg %></div>
            <% } %>

            <form action="RegisterServlet" method="GET">
                <input type="hidden" name="action" value="verifyUser">

                <div class="mb-3">
                    <label class="form-label fw-semibold">Email</label>
                    <input type="email" name="email" class="form-control" required>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-semibold">Mã chỉnh sửa</label>
                    <input type="text" name="code" class="form-control" required>
                </div>

                <div class="text-center">
                    <button type="submit" class="btn btn-primary px-4">Xác thực</button>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>