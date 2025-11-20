<%@ page import="java.util.List, model.Seminar, model.Register" %>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<jsp:include page="admin-header.jsp" />

<%
    Register user = (Register) request.getAttribute("user"); // Nếu null là Thêm, có data là Sửa
    List<Seminar> seminars = (List<Seminar>) request.getAttribute("seminars");
    boolean isEdit = (user != null);
%>

<div class="container-fluid">
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800"><%= isEdit ? "Sửa thông tin" : "Thêm người đăng ký mới" %></h1>
        <a href="list-user" class="btn btn-sm btn-secondary shadow-sm">Quay lại</a>
    </div>

    <div class="card shadow mb-4">
        <div class="card-body">
            <form action="admin-user" method="post">
                <input type="hidden" name="action" value="<%= isEdit ? "update" : "insert" %>">
                <% if (isEdit) { %>
                <input type="hidden" name="id" value="<%= user.getId() %>">
                <% } %>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Họ và tên</label>
                        <input type="text" class="form-control" name="fullname" value="<%= isEdit ? user.getName() : "" %>" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Email</label>
                        <input type="email" class="form-control" name="email" value="<%= isEdit ? user.getEmail() : "" %>" required>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Điện thoại</label>
                        <input type="text" class="form-control" name="phone" value="<%= isEdit ? user.getPhone() : "" %>" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Loại khách</label>
                        <select class="form-control" name="type">
                            <option value="Sinh viên" <%= isEdit && "Sinh viên".equals(user.getUserType()) ? "selected" : "" %>>Sinh viên</option>
                            <option value="Giảng viên" <%= isEdit && "Giảng viên".equals(user.getUserType()) ? "selected" : "" %>>Giảng viên</option>
                            <option value="Khách tự do" <%= isEdit && "Khách tự do".equals(user.getUserType()) ? "selected" : "" %>>Khách tự do</option>
                        </select>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Tham gia Hội thảo</label>
                    <select class="form-control" name="seminarId">
                        <% for (Seminar s : seminars) { %>
                        <option value="<%= s.getId() %>" <%= isEdit && user.getSeminarId() == s.getId() ? "selected" : "" %>>
                            <%= s.getName() %>
                        </option>
                        <% } %>
                    </select>
                </div>

                <button type="submit" class="btn btn-primary"><%= isEdit ? "Lưu thay đổi" : "Thêm mới" %></button>
            </form>
        </div>
    </div>
</div>

<jsp:include page="admin-footer.jsp" />