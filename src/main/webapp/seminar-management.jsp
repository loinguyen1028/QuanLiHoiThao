<%@ page import="java.util.*, model.Seminar, model.Page, model.PageRequest, dto.SeminarDTO, java.net.URLEncoder, java.nio.charset.StandardCharsets, java.time.format.DateTimeFormatter" %>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<jsp:include page="admin-header.jsp" />
<%
    Page<SeminarDTO> result = (Page<SeminarDTO>) request.getAttribute("result");
    PageRequest pageRequest = (PageRequest) request.getAttribute("pageRequest");

    List<SeminarDTO> seminarList = new ArrayList<>();
    int totalPage = 0;
    int currentPage = 1;

    // Kiểm tra null để tránh lỗi khi result là null
    if (result != null) {
        seminarList = result.getData();
        totalPage = result.getTotalPage();
        currentPage = result.getCurrentPage();
    }

    // --- Xây dựng các tham số cho link phân trang ---
    StringBuilder params = new StringBuilder();
    if (pageRequest != null && pageRequest.getKeyword() != null && !pageRequest.getKeyword().isEmpty()) {
        params.append("&keyword=").append(URLEncoder.encode(pageRequest.getKeyword(), StandardCharsets.UTF_8));
    }
    if (pageRequest != null && pageRequest.getSortField() != null && !pageRequest.getSortField().equals("id")) {
        params.append("&sortField=").append(pageRequest.getSortField());
        params.append("&order=").append(pageRequest.getOrderField());
    }

    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy");
%>
<div class="container-fluid">
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800">Quản lí hội thảo</h1>
        <a href="<%= request.getContextPath()%>/add_seminar"
           class="btn btn-success btn-sm">Thêm</a>
    </div>

    <form action="seminar_management" method="GET" class="mb-3">
        <div class="input-group">
            <input type="text" name="keyword" class="form-control" placeholder="Tìm theo tên, diễn giả, hoặc loại..."
                   value="<%= pageRequest != null && pageRequest.getKeyword() != null ? pageRequest.getKeyword() : "" %>">
            <div class="input-group-append">
                <button class="btn btn-primary" type="submit">Tìm kiếm</button>
            </div>
        </div>
    </form>

    <table class="table table-bordered table-striped">
        <thead class="table-primary">
        <tr>
            <th>ID</th>
            <th>Tên</th>
            <th>Ngày bắt đầu</th>
            <th>Ngày kết thúc</th>
            <th>Địa điểm</th>
            <th>Diễn giả</th>
            <th>Loại</th>
            <th>Số lượng</th>
            <th>Hành động</th>
        </tr>
        </thead>
        <tbody>
        <%
            if (seminarList != null && !seminarList.isEmpty()) {
                for (SeminarDTO s : seminarList) {
        %>
        <tr>
            <td><%= s.getId() %></td>
            <td><%= s.getName() %></td>
            <td><%= s.getStart_date().format(dtf) %></td>
            <td><%= s.getEnd_date().format(dtf) %></td>
            <td><%= s.getLocation() %></td>
            <td><%= s.getSpeaker() %></td>
            <td><%= s.getCategoryName() %></td>
            <td><%= s.getMaxAttendance() %></td>
            <td>
                <a href="<%= request.getContextPath()%>/detail_seminar?id=<%= s.getId()%>"
                   class="btn btn-info btn-sm" >Xem</a>
                <a href="<%= request.getContextPath()%>/edit_seminar?id=<%= s.getId()%>"
                   class="btn btn-warning btn-sm" >Sửa</a>
                <a href="<%= request.getContextPath()%>/delete_seminar?id=<%=s.getId()%>"
                   class="btn btn-danger btn-sm" onclick="return confirm('Bạn có chắc muốn xóa?')">Xóa</a>
            </td>
        </tr>
        <%
            }
        } else { %>
        <tr><td colspan="9" class="text-center">Không tìm thấy hội thảo nào.</td></tr>
        <% } %>
        </tbody>
    </table>
    <% if (totalPage > 1) { %>
    <nav aria-label="Page navigation">
        <ul class="pagination justify-content-center">
                <% for (int i = 1; i <= totalPage; i++) { %>
                <li class="page-item <%= (i == currentPage) ? "active" : "" %>">
                    <a class="page-link" href="seminar_management?page=<%= i %><%= params.toString() %>"><%= i %></a>
                </li>
                <% } %>
        </ul>
    </nav>
    <% } %>
</div>
<jsp:include page="admin-footer.jsp" />