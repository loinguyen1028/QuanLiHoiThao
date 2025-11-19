<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="model.Register" %>
<%
    Register r = (Register) request.getAttribute("register");
    if (r == null) {
        response.sendRedirect("RegisterServlet?action=verifyUser");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Cập nhật thông tin</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-4" style="background-color: #f8f9fa;">

<div class="container">
    <div class="card shadow-lg border-0 mx-auto" style="max-width: 600px;">
        <div class="card-body">
            <h4 class="text-center text-warning mb-4 fw-bold">✏️ Cập nhật thông tin</h4>
            <p class="text-center">Sự kiện: <b><%= r.getEventName() %></b></p>

            <form action="RegisterServlet" method="post">
                <input type="hidden" name="action" value="updateUser">
                <input type="hidden" name="id" value="<%= r.getId() %>">

                <div class="mb-3">
                    <label class="form-label fw-semibold">Họ và tên</label>
                    <input type="text" name="fullname" class="form-control" value="<%= r.getName() %>" required>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-semibold">Email (Không thể sửa)</label>
                    <input type="email" class="form-control" value="<%= r.getEmail() %>" readonly disabled>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-semibold">Điện thoại</label>
                    <input type="text" name="phone" class="form-control" value="<%= r.getPhone() %>" required>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-semibold">Loại khách</label>
                    <select class="form-select" name="type" required>
                        <option value="Sinh viên" <%= "Sinh viên".equals(r.getUserType()) ? "selected" : "" %>>Sinh viên</option>
                        <option value="Giảng viên" <%= "Giảng viên".equals(r.getUserType()) ? "selected" : "" %>>Giảng viên</option>
                        <option value="Khách tự do" <%= "Khách tự do".equals(r.getUserType()) ? "selected" : "" %>>Khách tự do</option>
                    </select>
                </div>

                <div class="text-center">
                    <button type="submit" class="btn btn-warning px-4">💾 Lưu thay đổi</button>
                    <a href="RegisterServlet?action=verifyUser" class="btn btn-outline-secondary px-4 ms-2">Hủy</a>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>