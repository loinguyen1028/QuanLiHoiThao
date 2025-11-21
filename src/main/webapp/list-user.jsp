<%@ page import="java.util.*, model.Register, model.Seminar" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<jsp:include page="admin-header.jsp" />

<%
    List<Register> list = (List<Register>) request.getAttribute("list");
    List<Seminar> seminars = (List<Seminar>) request.getAttribute("seminars"); // Lấy danh sách hội thảo để tạo dropdown
    String categoryName = (String) request.getAttribute("categoryName");
    String type = (String) request.getAttribute("type");

    // Lấy lại trạng thái lọc
    int vipStatus = (request.getAttribute("vipStatus") != null) ? (Integer) request.getAttribute("vipStatus") : -1;
    int currentSid = (request.getAttribute("currentSeminarId") != null) ? (Integer) request.getAttribute("currentSeminarId") : 0; // Lọc theo SeminarID

    // Code cũ của bạn (Checkin, UserType, Keyword) - Nếu Servlet chưa gửi thì để mặc định
    int checkInStatus = (request.getAttribute("checkInStatus") != null) ? (Integer) request.getAttribute("checkInStatus") : -1;
    String userType = (String) request.getAttribute("userType");
    if(userType == null) userType = "";
    String keyword = (String) request.getAttribute("keyword");
    if(keyword == null) keyword = "";

    // Tạo chuỗi params để giữ bộ lọc khi phân trang
    StringBuilder params = new StringBuilder();
    params.append("&vipStatus=").append(vipStatus);
    params.append("&seminarId=").append(currentSid);
    // params.append("&checkInStatus=").append(checkInStatus); // Bỏ comment nếu Servlet hỗ trợ
    // params.append("&userType=").append(URLEncoder.encode(userType, StandardCharsets.UTF_8)); // Bỏ comment nếu Servlet hỗ trợ
    // params.append("&keyword=").append(URLEncoder.encode(keyword, StandardCharsets.UTF_8));   // Bỏ comment nếu Servlet hỗ trợ
    String queryParams = params.toString();
%>

<style>
    body { font-family: 'Nunito', sans-serif; letter-spacing: 0.5px; }
    .table { font-size: 0.9rem; }
    table th, table td { vertical-align: middle !important; padding: 10px 12px !important; }
    .table-primary th { font-weight: 700; text-transform: uppercase; font-size: 0.8rem; letter-spacing: 0.5px;}
    .btn-rounded { border-radius: 20px !important; font-weight: 600; font-size: 0.85rem; }
    .card-rounded { border-radius: 15px !important; overflow: hidden !important; }
    .filter-active { color: #f6c23e !important; }
    .badge-soft { background-color: rgba(78,115,223,0.1); color: #4e73df; border: 1px solid rgba(78,115,223,0.2); }
</style>

<div class="container-fluid">

    <%-- THÔNG BÁO --%>
    <% String msg = request.getParameter("msg"); if (msg != null && !msg.isEmpty()) { %>
    <div class="alert alert-success alert-dismissible fade show mt-3 shadow-sm" role="alert" style="border-radius: 10px;">
        <i class="fas fa-check-circle me-2"></i> <%= msg %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
    <% } %>

    <div class="d-flex justify-content-between align-items-center mb-4 mt-4 flex-wrap">
        <div>
            <h4 class="text-gray-800 m-0 font-weight-bold">Quản lí đăng ký – <span class="text-primary"><%= categoryName %></span></h4>
        </div>

        <div class="d-flex align-items-center gap-2">
            <form action="list-user" method="GET" class="d-inline-block me-2">
                <input type="hidden" name="type" value="<%= type %>">
                <input type="hidden" name="vipStatus" value="<%= vipStatus %>">

                <select name="seminarId" class="form-select form-select-sm shadow-sm border-primary"
                        style="border-radius: 20px; min-width: 220px; font-weight: 500;"
                        onchange="this.form.submit()">
                    <option value="0">📂 Tất cả Hội thảo</option>
                    <% if (seminars != null) {
                        for (Seminar s : seminars) { %>
                    <option value="<%= s.getId() %>" <%= s.getId() == currentSid ? "selected" : "" %>>
                        <%= s.getName() %>
                    </option>
                    <%   }
                    } %>
                </select>
            </form>

            <a href="export-excel?type=<%= type %>&seminarId=<%= currentSid %>" class="btn btn-success btn-rounded btn-sm shadow-sm">
                <i class="fas fa-file-excel"></i> Excel
            </a>
            <a href="admin-user?action=add" class="btn btn-primary btn-rounded btn-sm shadow-sm">
                <i class="fas fa-plus"></i> Thêm
            </a>
        </div>
    </div>

    <div class="card shadow-sm border-0 card-rounded">
        <div class="card-header bg-white py-3 border-bottom">
            <h6 class="m-0 font-weight-bold text-primary text-uppercase">Danh sách người đăng ký</h6>
        </div>

        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead class="bg-light text-center text-nowrap text-secondary">
                    <tr>
                        <th>ID</th>
                        <th class="text-start">Họ và tên</th>
                        <th class="text-start">Email</th>
                        <th>SĐT</th>
                        <th>Loại khách</th>

                        <th class="text-start" style="width: 25%;">Tên Hội thảo</th>

                        <th class="text-center" style="min-width: 90px;">
                            <div class="dropdown">
                                <a class="dropdown-toggle text-secondary text-decoration-none font-weight-bold" href="#" data-toggle="dropdown">
                                    VIP <% if(vipStatus != -1){ %><i class="fas fa-filter fa-xs filter-active"></i><% } %>
                                </a>
                                <div class="dropdown-menu shadow border-0">
                                    <a class="dropdown-item <%= vipStatus == -1 ? "active" : "" %>" href="list-user?type=<%=type%>&vipStatus=-1&seminarId=<%=currentSid%>">Tất cả</a>
                                    <a class="dropdown-item <%= vipStatus == 1 ? "active" : "" %>" href="list-user?type=<%=type%>&vipStatus=1&seminarId=<%=currentSid%>">⭐ VIP</a>
                                    <a class="dropdown-item <%= vipStatus == 0 ? "active" : "" %>" href="list-user?type=<%=type%>&vipStatus=0&seminarId=<%=currentSid%>">👤 Thường</a>
                                </div>
                            </div>
                        </th>

                        <th>Hành động</th>
                    </tr>
                    </thead>

                    <tbody>
                    <% if (list != null && !list.isEmpty()) {
                        for (Register r : list) { %>
                    <tr>
                        <td class="text-center text-muted"><%= r.getId() %></td>
                        <td class="fw-bold text-dark"><%= r.getName() %></td>
                        <td class="text-muted"><%= r.getEmail() %></td>
                        <td class="text-center"><%= r.getPhone() %></td>

                        <td class="text-center">
                            <span class="badge badge-soft rounded-pill px-3">
                                <%= r.getUserType() %>
                            </span>
                        </td>

                        <td>
                            <div class="text-truncate" style="max-width: 250px;" title="<%= r.getEventName() %>">
                                <%= r.getEventName() %>
                            </div>
                        </td>

                        <td class="text-center">
                            <a href="toggle-vip?id=<%= r.getId() %>" class="btn btn-sm <%= r.isVip() ? "btn-warning text-white" : "btn-light text-secondary" %> rounded-circle shadow-sm"
                               style="width:32px;height:32px;display:inline-flex;align-items:center;justify-content:center;">
                                <i class="<%= r.isVip() ? "fas" : "far" %> fa-star"></i>
                            </a>
                        </td>

                        <td class="text-center text-nowrap">
                            <a href="admin-user?action=edit&id=<%= r.getId() %>" class="btn btn-sm btn-outline-info border-0" title="Sửa"><i class="fas fa-edit"></i></a>
                            <a href="admin-user?action=delete&id=<%= r.getId() %>" class="btn btn-sm btn-outline-danger border-0" onclick="return confirm('Xóa người này?');" title="Xóa"><i class="fas fa-trash-alt"></i></a>
                        </td>
                    </tr>
                    <% } } else { %>
                    <tr><td colspan="9" class="text-center py-5 text-muted bg-light"><i class="fas fa-inbox fa-3x mb-3 text-gray-300"></i><br>Không tìm thấy dữ liệu nào</td></tr>
                    <% } %>
                    </tbody>
                </table>
            </div>

            <%-- PHÂN TRANG --%>
            <%
                // (Code phân trang giữ nguyên như cũ)
                Integer currentPageObj = (Integer) request.getAttribute("currentPage"); // Đảm bảo Servlet gửi đúng tên biến này
                Integer totalPagesObj = (Integer) request.getAttribute("totalPages");
                int currentPage = (currentPageObj != null) ? currentPageObj : 1;
                int totalPages = (totalPagesObj != null) ? totalPagesObj : 1;
            %>
            <% if (totalPages > 1) { %>
            <div class="p-3 border-top">
                <nav aria-label="Page navigation">
                    <ul class="pagination justify-content-center m-0">
                        <li class="page-item <%= (currentPage == 1) ? "disabled" : "" %>">
                            <a class="page-link rounded-pill px-3 me-1" href="list-user?type=<%=type%>&page=<%= currentPage - 1 %><%= queryParams %>">Trước</a>
                        </li>
                        <% for (int i = 1; i <= totalPages; i++) { %>
                        <li class="page-item <%= (i == currentPage) ? "active" : "" %>">
                            <a class="page-link rounded-circle mx-1" style="width: 35px; height: 35px; display: flex; align-items: center; justify-content: center;"
                               href="list-user?type=<%=type%>&page=<%= i %><%= queryParams %>"><%= i %></a>
                        </li>
                        <% } %>
                        <li class="page-item <%= (currentPage == totalPages) ? "disabled" : "" %>">
                            <a class="page-link rounded-pill px-3 ms-1" href="list-user?type=<%=type%>&page=<%= currentPage + 1 %><%= queryParams %>">Sau</a>
                        </li>
                    </ul>
                </nav>
            </div>
            <% } %>
        </div>
    </div>
</div>

<jsp:include page="admin-footer.jsp" />