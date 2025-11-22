<%@ page import="java.util.*, model.Register, model.Seminar" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<jsp:include page="admin-header.jsp" />

<%
    // 1. LẤY DỮ LIỆU TỪ SERVLET
    List<Register> list = (List<Register>) request.getAttribute("list");
    List<Seminar> seminars = (List<Seminar>) request.getAttribute("seminars");
    String categoryName = (String) request.getAttribute("categoryName");
    String type = (String) request.getAttribute("type");

    // Lấy ID Category (quan trọng để không bị nhảy tab)
    Integer catIdObj = (Integer) request.getAttribute("categoryId");
    int categoryId = (catIdObj != null) ? catIdObj : 1;

    // 2. LẤY TRẠNG THÁI CÁC BỘ LỌC (Để giữ 'Selected')
    // Seminar ID
    Integer sidObj = (Integer) request.getAttribute("currentSeminarId");
    int currentSid = (sidObj != null) ? sidObj : 0;

    // VIP
    Integer vipObj = (Integer) request.getAttribute("vipStatus");
    int vipStatus = (vipObj != null) ? vipObj : -1;

    // Check-in
    Integer checkObj = (Integer) request.getAttribute("checkInStatus");
    int checkInStatus = (checkObj != null) ? checkObj : -1;

    // User Type & Keyword
    String userType = (String) request.getAttribute("userType");
    if(userType == null) userType = "";

    String keyword = request.getParameter("keyword"); // Lấy từ param cho chắc chắn
    if(keyword == null) keyword = "";

    // 3. PHÂN TRANG
    Integer currentPageObj = (Integer) request.getAttribute("currentPage");
    Integer totalPagesObj = (Integer) request.getAttribute("totalPages");
    int currentPage = (currentPageObj != null) ? currentPageObj : 1;
    int totalPages = (totalPagesObj != null) ? totalPagesObj : 1;

    // 4. TẠO CHUỖI QUERY PARAMS (Để giữ bộ lọc khi bấm phân trang)
    StringBuilder params = new StringBuilder();
    params.append("&type=").append(type); // Giữ loại danh mục
    params.append("&categoryId=").append(categoryId); // Giữ ID danh mục
    params.append("&seminarId=").append(currentSid);
    params.append("&vipStatus=").append(vipStatus);
    params.append("&checkInStatus=").append(checkInStatus);

    if(!userType.isEmpty()) params.append("&userType=").append(URLEncoder.encode(userType, StandardCharsets.UTF_8));
    if(!keyword.isEmpty()) params.append("&keyword=").append(URLEncoder.encode(keyword, StandardCharsets.UTF_8));

    String queryParams = params.toString();
%>

<style>
    body { font-family: 'Nunito', sans-serif; background-color: #f8f9fc; }
    .filter-bar { background: white; padding: 15px 20px; border-radius: 15px; box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.1); margin-bottom: 20px; display: flex; flex-wrap: wrap; gap: 10px; align-items: center; }
    .filter-input { border-radius: 20px; border: 1px solid #d1d3e2; font-size: 0.9rem; padding: 0.375rem 1rem; min-width: 150px; }
    .filter-input:focus { box-shadow: none; border-color: #4e73df; }
    .btn-custom { border-radius: 20px; font-weight: 600; font-size: 0.9rem; padding: 6px 20px; transition: 0.2s; }
    .btn-search { background: #4e73df; color: white; border: none; }
    .btn-search:hover { background: #2e59d9; color: white; transform: translateY(-1px); }
    .btn-excel { background: #1cc88a; color: white; border: none; }
    .btn-excel:hover { background: #17a673; color: white; transform: translateY(-1px); }
    .table-card { border-radius: 15px; overflow: hidden; border: none; box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.1); }
    .table thead th { background-color: #f8f9fc; color: #4e73df; font-weight: 700; text-transform: uppercase; font-size: 0.8rem; border-bottom: 2px solid #e3e6f0; vertical-align: middle; white-space: nowrap; }
    .table td { vertical-align: middle; font-size: 0.9rem; padding: 12px; }
    .badge-vip { background-color: #f6c23e; color: white; padding: 5px 10px; border-radius: 10px; font-size: 0.75rem; }
    .badge-checked { background-color: #1cc88a; color: white; padding: 5px 10px; border-radius: 10px; font-size: 0.75rem;}
    .badge-pending { background-color: #e74a3b; color: white; padding: 5px 10px; border-radius: 10px; font-size: 0.75rem;}
    .avatar-circle { width: 40px; height: 40px; background-color: #4e73df; color: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 1.2rem; margin-right: 10px; }
</style>

<div class="container-fluid">

    <%-- THÔNG BÁO --%>
    <% String msg = request.getParameter("msg");
        String error = request.getParameter("error");
        if (msg != null && !msg.isEmpty()) { %>
    <div class="alert <%= (error != null) ? "alert-danger" : "alert-success" %> alert-dismissible fade show mt-3 shadow-sm" role="alert" style="border-radius: 10px;">
        <i class="fas <%= (error != null) ? "fa-exclamation-triangle" : "fa-check-circle" %> me-2"></i> <%= msg %>
        <button type="button" class="close" data-dismiss="alert">&times;</button>
    </div>
    <% } %>

    <div class="d-flex justify-content-between align-items-center mt-4 mb-3">
        <h1 class="h3 mb-0 text-gray-800">Quản lý đăng ký – <span class="text-primary"><%= categoryName %></span></h1>
    </div>

    <form id="filterForm" action="list-user" method="GET" class="filter-bar">

        <input type="hidden" name="categoryId" value="<%= categoryId %>">
        <input type="hidden" name="type" value="<%= type %>">

        <div class="input-group" style="width: 250px;">
            <input type="text" name="keyword" class="form-control filter-input" placeholder="Tìm tên, email, SĐT..." value="<%= keyword %>">
        </div>

        <select name="seminarId" class="form-select filter-input" onchange="submitForm()">
            <option value="0">📂 Tất cả Hội thảo</option>
            <% if (seminars != null) {
                for (Seminar s : seminars) { %>
            <option value="<%= s.getId() %>" <%= s.getId() == currentSid ? "selected" : "" %>>
                <%= s.getName() %>
            </option>
            <%   } } %>
        </select>

        <select name="userType" class="form-select filter-input" onchange="submitForm()">
            <option value="">👤 Tất cả Khách</option>
            <option value="Sinh viên" <%= "Sinh viên".equals(userType) ? "selected" : "" %>>Sinh viên</option>
            <option value="Giảng viên" <%= "Giảng viên".equals(userType) ? "selected" : "" %>>Giảng viên</option>
            <option value="Khách tự do" <%= "Khách tự do".equals(userType) ? "selected" : "" %>>Khách tự do</option>
        </select>

        <select name="vipStatus" class="form-select filter-input" style="width: 130px;" onchange="submitForm()">
            <option value="-1">⭐ VIP: All</option>
            <option value="1" <%= vipStatus == 1 ? "selected" : "" %>>Chỉ VIP</option>
            <option value="0" <%= vipStatus == 0 ? "selected" : "" %>>Thường</option>
        </select>

        <select name="checkInStatus" class="form-select filter-input" style="width: 150px;" onchange="submitForm()">
            <option value="-1">📍 Check-in</option>
            <option value="1" <%= checkInStatus == 1 ? "selected" : "" %>>Đã xong</option>
            <option value="0" <%= checkInStatus == 0 ? "selected" : "" %>>Chưa</option>
        </select>

        <button type="submit" class="btn btn-custom btn-search"><i class="fas fa-search"></i></button>
        <a href="list-user?type=<%= type %>&categoryId=<%= categoryId %>" class="btn btn-light btn-custom" title="Tải lại"><i class="fas fa-sync-alt"></i></a>

        <div class="ml-auto d-flex gap-2">
            <button type="button" onclick="exportExcel()" class="btn btn-custom btn-excel shadow-sm">
                <i class="fas fa-file-excel"></i> Xuất Excel
            </button>

            <a href="admin-user?action=add" class="btn btn-primary btn-custom shadow-sm">
                <i class="fas fa-plus"></i> Thêm Mới
            </a>
        </div>
    </form>

    <div class="card table-card mb-4">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0" width="100%">
                    <thead>
                    <tr>
                        <th class="text-center">ID</th>
                        <th>Họ và tên</th>
                        <th>Email / SĐT</th>
                        <th class="text-center">Loại khách</th>
                        <th>Hội thảo đăng ký</th>
                        <th class="text-center">VIP</th>
                        <th class="text-center">Check-in</th>
                        <th class="text-center">Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% if (list != null && !list.isEmpty()) {
                        for (Register r : list) { %>
                    <tr>
                        <td class="text-center text-muted">#<%= r.getId() %></td>
                        <td>
                            <div class="d-flex align-items-center">
                                <div class="avatar-circle">
                                    <%= (r.getName() != null && !r.getName().isEmpty()) ? r.getName().substring(0, 1).toUpperCase() : "U" %>
                                </div>
                                <div>
                                    <div class="font-weight-bold text-primary"><%= r.getName() %></div>
                                    <small class="text-muted">Mã: <%= (r.getCheckInId() != null) ? r.getCheckInId() : "N/A" %></small>
                                </div>
                            </div>
                        </td>
                        <td>
                            <div><i class="fas fa-envelope fa-xs text-gray-400 mr-1"></i> <%= r.getEmail() %></div>
                            <div><i class="fas fa-phone fa-xs text-gray-400 mr-1"></i> <%= r.getPhone() %></div>
                        </td>
                        <td class="text-center">
                            <span class="badge bg-light text-dark border"><%= r.getUserType() %></span>
                        </td>
                        <td style="max-width: 250px;">
                            <div class="text-truncate" title="<%= r.getEventName() %>"><%= r.getEventName() %></div>
                        </td>
                        <td class="text-center">
                            <a href="toggle-vip?id=<%= r.getId() %>" class="text-decoration-none">
                                <% if(r.isVip()) { %>
                                <span class="badge badge-vip shadow-sm"><i class="fas fa-star"></i> VIP</span>
                                <% } else { %>
                                <i class="far fa-star text-gray-400"></i>
                                <% } %>
                            </a>
                        </td>
                        <td class="text-center">
                            <% if (r.getCheckinTime() != null) { %>
                            <span class="badge badge-checked shadow-sm" title="<%= r.getCheckinTime() %>"><i class="fas fa-check"></i> Rồi</span>
                            <% } else { %>
                            <span class="badge badge-pending shadow-sm">Chưa</span>
                            <% } %>
                        </td>
                        <td class="text-center">
                            <a href="admin-user?action=edit&id=<%= r.getId() %>" class="btn btn-sm btn-info shadow-sm"><i class="fas fa-pen"></i></a>
                            <a href="admin-user?action=delete&id=<%= r.getId() %>" class="btn btn-sm btn-danger shadow-sm" onclick="return confirm('Xóa đăng ký này?');"><i class="fas fa-trash"></i></a>
                        </td>
                    </tr>
                    <% } } else { %>
                    <tr><td colspan="8" class="text-center py-5 text-muted"><i class="fas fa-folder-open fa-3x mb-3"></i><br>Không tìm thấy dữ liệu phù hợp</td></tr>
                    <% } %>
                    </tbody>
                </table>
            </div>

            <% if (totalPages > 1) { %>
            <div class="d-flex justify-content-center py-3">
                <nav>
                    <ul class="pagination m-0">
                        <li class="page-item <%= (currentPage == 1) ? "disabled" : "" %>">
                            <a class="page-link rounded-pill px-3 mr-1" href="list-user?page=<%= currentPage - 1 %><%= queryParams %>">Trước</a>
                        </li>
                        <% for (int i = 1; i <= totalPages; i++) { %>
                        <li class="page-item <%= (i == currentPage) ? "active" : "" %>">
                            <a class="page-link rounded-circle mx-1" style="width: 35px; height: 35px; display:flex; align-items:center; justify-content:center;"
                               href="list-user?page=<%= i %><%= queryParams %>"><%= i %></a>
                        </li>
                        <% } %>
                        <li class="page-item <%= (currentPage == totalPages) ? "disabled" : "" %>">
                            <a class="page-link rounded-pill px-3 ml-1" href="list-user?page=<%= currentPage + 1 %><%= queryParams %>">Sau</a>
                        </li>
                    </ul>
                </nav>
            </div>
            <% } %>
        </div>
    </div>
</div>

<script>
    function submitForm() {
        document.getElementById("filterForm").submit();
    }

    function exportExcel() {
        var form = document.getElementById("filterForm");
        var params = new URLSearchParams(new FormData(form)).toString();
        window.location.href = "export-excel?" + params;
    }
</script>

<jsp:include page="admin-footer.jsp" />