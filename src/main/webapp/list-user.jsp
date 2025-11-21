<%@ page import="java.util.*, model.Register" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<jsp:include page="admin-header.jsp" />

<%
List<Register> list = (List<Register>) request.getAttribute("list");
String categoryName = (String) request.getAttribute("categoryName");
String type = (String) request.getAttribute("type");

```
// Lấy lại trạng thái lọc
int vipStatus = (request.getAttribute("vipStatus") != null) ? (Integer) request.getAttribute("vipStatus") : -1;
int checkInStatus = (request.getAttribute("checkInStatus") != null) ? (Integer) request.getAttribute("checkInStatus") : -1;
String userType = (String) request.getAttribute("userType");
if(userType == null) userType = "";
String keyword = (String) request.getAttribute("keyword");
if(keyword == null) keyword = "";

// Tạo chuỗi params để giữ bộ lọc khi phân trang
String queryParams = "&vipStatus=" + vipStatus + "&checkInStatus=" + checkInStatus + "&userType=" + URLEncoder.encode(userType, StandardCharsets.UTF_8) + "&keyword=" + URLEncoder.encode(keyword, StandardCharsets.UTF_8);
```

%>

<style>
    body { font-family: 'Nunito', sans-serif; letter-spacing: 0.5px; }
    .table { font-size: 0.95rem; }
    table th, table td { vertical-align: middle !important; padding: 12px 15px !important; line-height: 1.5 !important; }
    .table-primary th { font-weight: 700; text-transform: uppercase; letter-spacing: 1px; font-size: 0.85rem; }
    .btn-rounded { border-radius: 12px !important; font-weight: 600; }
    .card-rounded { border-radius: 18px !important; overflow: hidden !important; }
    .dropdown-toggle::after { vertical-align: middle; margin-left: 5px; }
    .dropdown-item.active, .dropdown-item:active { background-color: #4e73df; }
    .filter-active { color: #ffc107 !important; }
</style>

<div class="container-fluid">

```
<%-- THÔNG BÁO --%>
<% String msg = (String) request.getAttribute("msg"); if (msg != null && !msg.isEmpty()) { %>
<div class="alert alert-success alert-dismissible fade show mt-3 shadow-sm" role="alert" style="border-radius: 10px;">
    <i class="fas fa-check-circle me-2"></i> <%= msg %>
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
</div>
<% } %>

<div class="d-flex justify-content-between align-items-center mb-4 mt-4 flex-wrap">
    <div>
        <h3 class="text-gray-800 m-0 font-weight-bold">Quản lí đăng ký – <span class="text-primary"><%= categoryName %></span></h3>
    </div>

    <div>
        <form action="list-user" method="get" class="d-inline-flex align-items-center">
            <input type="hidden" name="type" value="<%= type %>">
            <input type="hidden" name="vipStatus" value="<%= vipStatus %>">
            <input type="hidden" name="checkInStatus" value="<%= checkInStatus %>">
            <input type="hidden" name="userType" value="<%= userType %>">

            <div class="input-group me-2" style="width: 250px;">
                <input type="text" name="keyword" class="form-control border-end-0" placeholder="Tên, Email, SĐT..." value="<%= keyword %>">
                <button class="btn btn-outline-secondary bg-white border-start-0" type="submit"><i class="fas fa-search"></i></button>
            </div>

            <a href="export-excel?type=<%= type %>" class="btn btn-success btn-rounded btn-sm me-2 shadow-sm"><i class="fas fa-file-excel"></i> Excel</a>
            <a href="admin-user?action=add" class="btn btn-primary btn-rounded btn-sm me-2 shadow-sm"><i class="fas fa-plus"></i> Thêm</a>
            <a href="list-user?type=<%= type %>" class="btn btn-outline-secondary btn-rounded btn-sm shadow-sm" title="Reset bộ lọc"><i class="fas fa-sync-alt"></i></a>
        </form>
    </div>
</div>

<div class="card shadow-sm border-0 card-rounded">
    <div class="card-header bg-primary text-white card-header-rounded py-3">
        <h6 class="m-0 font-weight-bold text-uppercase" style="letter-spacing: 1px;">Danh sách đăng ký</h6>
    </div>

    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover table-striped mb-0">
                <thead class="table-primary text-center text-nowrap">
                <tr>
                    <th>ID</th>
                    <th>Họ và tên</th>
                    <th>Email</th>
                    <th>SĐT</th>

                    <th>
                        <div class="dropdown">
                            <a class="dropdown-toggle text-white text-decoration-none" href="#" data-toggle="dropdown">
                                Loại khách <% if(!userType.isEmpty()){ %><i class="fas fa-filter fa-xs filter-active"></i><% } %>
                            </a>
                            <div class="dropdown-menu shadow">
                                <a class="dropdown-item <%= userType.isEmpty() ? "active" : "" %>" href="list-user?type=<%=type%>&userType=&vipStatus=<%=vipStatus%>&checkInStatus=<%=checkInStatus%>&keyword=<%=keyword%>">Tất cả</a>
                                <a class="dropdown-item <%= "Sinh viên".equals(userType) ? "active" : "" %>" href="list-user?type=<%=type%>&userType=Sinh viên&vipStatus=<%=vipStatus%>&checkInStatus=<%=checkInStatus%>&keyword=<%=keyword%>">Sinh viên</a>
                                <a class="dropdown-item <%= "Giảng viên".equals(userType) ? "active" : "" %>" href="list-user?type=<%=type%>&userType=Giảng viên&vipStatus=<%=vipStatus%>&checkInStatus=<%=checkInStatus%>&keyword=<%=keyword%>">Giảng viên</a>
                                <a class="dropdown-item <%= "Khách tự do".equals(userType) ? "active" : "" %>" href="list-user?type=<%=type%>&userType=Khách tự do&vipStatus=<%=vipStatus%>&checkInStatus=<%=checkInStatus%>&keyword=<%=keyword%>">Khách tự do</a>
                            </div>
                        </div>
                    </th>

                    <th>Loại hội thảo</th>

                    <th class="text-center" style="min-width: 90px;">
                        <div class="dropdown">
                            <a class="dropdown-toggle text-white text-decoration-none" href="#" data-toggle="dropdown">
                                VIP <% if(vipStatus != -1){ %><i class="fas fa-filter fa-xs filter-active"></i><% } %>
                            </a>
                            <div class="dropdown-menu shadow">
                                <a class="dropdown-item <%= vipStatus == -1 ? "active" : "" %>" href="list-user?type=<%=type%>&vipStatus=-1&userType=<%=userType%>&checkInStatus=<%=checkInStatus%>&keyword=<%=keyword%>">Tất cả</a>
                                <a class="dropdown-item <%= vipStatus == 1 ? "active" : "" %>" href="list-user?type=<%=type%>&vipStatus=1&userType=<%=userType%>&checkInStatus=<%=checkInStatus%>&keyword=<%=keyword%>">⭐ VIP</a>
                                <a class="dropdown-item <%= vipStatus == 0 ? "active" : "" %>" href="list-user?type=<%=type%>&vipStatus=0&userType=<%=userType%>&checkInStatus=<%=checkInStatus%>&keyword=<%=keyword%>">👤 Thường</a>
                            </div>
                        </div>
                    </th>

                    <th class="text-center" style="min-width: 130px;">
                        <div class="dropdown">
                            <a class="dropdown-toggle text-white text-decoration-none" href="#" data-toggle="dropdown">
                                Check-in <% if(checkInStatus != -1){ %><i class="fas fa-filter fa-xs filter-active"></i><% } %>
                            </a>
                            <div class="dropdown-menu shadow">
                                <a class="dropdown-item <%= checkInStatus == -1 ? "active" : "" %>" href="list-user?type=<%=type%>&checkInStatus=-1&userType=<%=userType%>&vipStatus=<%=vipStatus%>&keyword=<%=keyword%>">Tất cả</a>
                                <a class="dropdown-item <%= checkInStatus == 1 ? "active" : "" %>" href="list-user?type=<%=type%>&checkInStatus=1&userType=<%=userType%>&vipStatus=<%=vipStatus%>&keyword=<%=keyword%>">✅ Đã Check-in</a>
                                <a class="dropdown-item <%= checkInStatus == 0 ? "active" : "" %>" href="list-user?type=<%=type%>&checkInStatus=0&userType=<%=userType%>&vipStatus=<%=vipStatus%>&keyword=<%=keyword%>">⏳ Chưa</a>
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
                    <td class="text-center"><%= r.getId() %></td>
                    <td class="fw-bold text-dark"><%= r.getName() %></td>
                    <td><%= r.getEmail() %></td>
                    <td class="text-center"><%= r.getPhone() %></td>

                    <td class="text-center">
                        <span class="badge <%= "sinhvien".equalsIgnoreCase(r.getUserType()) ? "bg-info" : "bg-secondary" %> text-white" style="font-weight: 500; padding: 6px 10px;">
                            <%= r.getUserType() %>
                        </span>
                    </td>

                    <td><%= categoryName %></td>

                    <td class="text-center">
                        <a href="toggle-vip?id=<%= r.getId() %>" class="btn btn-sm <%= r.isVip() ? "btn-warning text-white" : "btn-outline-secondary" %> rounded-circle" style="width:32px;height:32px;display:inline-flex;align-items:center;justify-content:center;">
                            <i class="<%= r.isVip() ? "fas" : "far" %> fa-star"></i>
                        </a>
                    </td>

                    <td class="text-center">
                        <% if (r.getCheckinTime() != null) { %>
                        <span class="badge bg-success p-2" title="<%= r.getCheckinTime() %>"><i class="fas fa-check"></i> Đã check-in</span>
                        <% } else { %>
                        <span class="badge bg-light text-secondary border p-2">Chưa</span>
                        <% } %>
                    </td>

                    <td class="text-center text-nowrap">
                        <a href="admin-user?action=edit&id=<%= r.getId() %>" class="btn btn-sm btn-info text-white" title="Sửa"><i class="fas fa-edit"></i></a>
                        <a href="admin-user?action=delete&id=<%= r.getId() %>" class="btn btn-sm btn-danger" onclick="return confirm('Xóa người này?');" title="Xóa"><i class="fas fa-trash"></i></a>
                    </td>
                </tr>
                <% } } else { %>
                <tr><td colspan="9" class="text-center py-5 text-muted"><i class="fas fa-inbox fa-3x mb-3"></i><br>Không tìm thấy dữ liệu nào</td></tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <%-- PHÂN TRANG --%>
        <%
            int currentPage = (Integer) request.getAttribute("currentPage");
            int totalPages = (Integer) request.getAttribute("totalPages");
        %>
        <% if (totalPages > 1) { %>
        <div class="p-3">
            <nav aria-label="Page navigation">
                <ul class="pagination justify-content-center m-0">
                    <li class="page-item <%= (currentPage == 1) ? "disabled" : "" %>">
                        <a class="page-link" href="list-user?type=<%=type%>&page=<%= currentPage - 1 %><%= queryParams %>">Trước</a>
                    </li>
                    <% for (int i = 1; i <= totalPages; i++) { %>
                    <li class="page-item <%= (i == currentPage) ? "active" : "" %>">
                        <a class="page-link" href="list-user?type=<%=type%>&page=<%= i %><%= queryParams %>"><%= i %></a>
                    </li>
                    <% } %>
                    <li class="page-item <%= (currentPage == totalPages) ? "disabled" : "" %>">
                        <a class="page-link" href="list-user?type=<%=type%>&page=<%= currentPage + 1 %><%= queryParams %>">Sau</a>
                    </li>
                </ul>
            </nav>
        </div>
        <% } %>
    </div>
</div>
```

</div>

<jsp:include page="admin-footer.jsp" />
