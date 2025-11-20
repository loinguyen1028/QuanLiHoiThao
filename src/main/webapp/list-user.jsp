<%@ page import="java.util.*, model.Register" %>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<jsp:include page="admin-header.jsp" />

<%
    List<Register> list = (List<Register>) request.getAttribute("list");
    String categoryName = (String) request.getAttribute("categoryName");
    String type = (String) request.getAttribute("type");
    int vipStatus = (request.getAttribute("vipStatus") != null) ? (Integer) request.getAttribute("vipStatus") : -1;
%>

<style>
    /* --- CẤU HÌNH FONT CHỮ ĐẸP CHO TIẾNG VIỆT --- */
    body {
        font-family: 'Nunito', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
        letter-spacing: 0.5px; /* Giãn chữ ra 1 chút cho thoáng */
    }

    /* Style cho bảng dữ liệu */
    .table {
        font-size: 0.95rem; /* Cỡ chữ vừa phải */
    }

    /* Căn giữa nội dung trong ô và giãn dòng */
    table th, table td {
        vertical-align: middle !important;
        padding: 12px 15px !important; /* Tăng khoảng cách đệm trong ô */
        line-height: 1.5 !important;   /* Giãn dòng để dấu không bị dính */
    }

    /* Làm đậm tiêu đề bảng */
    .table-primary th {
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 1px; /* Tiêu đề giãn rộng hơn chút */
        font-size: 0.85rem;
    }

    /* --- CÁC STYLE CŨ GIỮ NGUYÊN --- */
    .btn-rounded {
        border-radius: 12px !important;
        padding-left: 18px !important;
        padding-right: 18px !important;
        font-weight: 600; /* Nút bấm chữ đậm hơn xíu */
    }
    .btn-reload {
        background-color: #4e73df;
        color: white;
        border: none;
        border-radius: 12px;
        box-shadow: 0 3px 8px rgba(78,115,223,0.25);
        transition: 0.2s ease-in-out;
    }
    .btn-reload:hover {
        background-color: #3b5cc4;
        box-shadow: 0 4px 12px rgba(78,115,223,0.35);
        color: white;
    }
    .spin {
        display: inline-block;
        animation: spin 1s linear infinite;
    }
    @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }

    .table-rounded { border-radius: 12px !important; overflow: hidden !important; }
    .card-rounded { border-radius: 18px !important; overflow: hidden !important; }
    .card-header-rounded { border-radius: 18px 18px 0 0 !important; }

    /* Style cho dropdown header */
    .dropdown-toggle::after { vertical-align: middle; }
</style>


<div class="container-fluid">

    <%-- THÔNG BÁO (Popup xanh/đỏ) --%>
    <%
        String msg = (String) request.getAttribute("msg");
        if (msg != null && !msg.isEmpty()) {
    %>
    <div class="alert alert-success alert-dismissible fade show mt-3 shadow-sm" role="alert" style="border-radius: 10px;">
        <i class="fas fa-check-circle me-2"></i> <strong>Thành công!</strong> <%= msg %>
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <% } %>

    <div class="row align-items-center mb-4 mt-4">
        <div class="col-12 col-md-5">
            <h3 class="text-gray-800 m-0 font-weight-bold" style="letter-spacing: 1px;">
                Quản lí đăng ký – <span class="text-primary"><%= categoryName %></span>
            </h3>
        </div>

        <div class="col-12 col-md-7 text-md-end mt-3 mt-md-0">

            <a href="export-excel?type=<%= type %>" class="btn btn-success btn-rounded btn-sm me-2 shadow-sm">
                <i class="fas fa-file-excel"></i> Xuất Excel (.xlsx)
            </a>

            <a href="admin-user?action=add" class="btn btn-primary btn-rounded btn-sm me-2 shadow-sm">
                <i class="fas fa-plus"></i> Thêm
            </a>

            <form action="list-user" method="get" onsubmit="startLoading()" style="display:inline-block;">
                <input type="hidden" name="type" value="<%= type %>">
                <input type="hidden" name="vipStatus" value="<%= vipStatus %>">
                <button id="reloadBtn" class="btn btn-reload btn-rounded btn-sm">
                    <span id="reloadIcon"></span> 🔄 Tải lại
                </button>
            </form>

        </div>
    </div>

    <div class="card shadow-sm border-0 card-rounded">

        <div class="card-header bg-primary text-white card-header-rounded py-3">
            <h6 class="m-0 font-weight-bold text-uppercase" style="letter-spacing: 1px;">Danh sách người đăng ký</h6>
        </div>

        <div class="card-body">

            <div class="table-responsive">
                <table class="table table-hover table-bordered table-rounded" id="dataTable" width="100%" cellspacing="0">
                    <thead class="table-primary text-center">
                    <tr>
                        <th>ID</th>
                        <th>Họ và tên</th>
                        <th>Email</th>
                        <th>Điện thoại</th>
                        <th>Loại khách</th>
                        <th>Loại hội thảo</th>

                        <th class="text-center" style="min-width: 110px;">
                            <div class="dropdown no-arrow">
                                <a class="dropdown-toggle text-white text-decoration-none font-weight-bold"
                                   href="#" role="button" id="vipFilterLink"
                                   data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                    VIP
                                    <% if (vipStatus != -1) { %>
                                    <i class="fas fa-filter fa-xs text-warning"></i>
                                    <% } else { %>
                                    <i class="fas fa-caret-down fa-sm"></i>
                                    <% } %>
                                </a>

                                <div class="dropdown-menu shadow animated--fade-in" aria-labelledby="vipFilterLink">
                                    <a class="dropdown-item <%= vipStatus == -1 ? "active" : "" %>"
                                       href="list-user?type=<%=type%>&vipStatus=-1">
                                        📝 Tất cả
                                    </a>
                                    <a class="dropdown-item <%= vipStatus == 1 ? "active" : "" %>"
                                       href="list-user?type=<%=type%>&vipStatus=1">
                                        ⭐ Chỉ hiện VIP
                                    </a>
                                    <a class="dropdown-item <%= vipStatus == 0 ? "active" : "" %>"
                                       href="list-user?type=<%=type%>&vipStatus=0">
                                        👤 Khách thường
                                    </a>
                                </div>
                            </div>
                        </th>

                        <th class="text-center">Hành động</th>
                    </tr>
                    </thead>

                    <tbody>
                    <%
                        if (list != null && !list.isEmpty()) {
                            for (Register r : list) {
                    %>
                    <tr>
                        <td class="text-center"><%= r.getId() %></td>
                        <td class="fw-bold text-dark"><%= r.getName() %></td>
                        <td><%= r.getEmail() %></td>
                        <td class="text-center"><%= r.getPhone() %></td>
                        <td class="text-center">
                            <span class="badge <%= "sinhvien".equalsIgnoreCase(r.getUserType()) ? "bg-info" : "bg-secondary" %> text-white"
                                  style="font-weight: 500; letter-spacing: 0.5px; padding: 6px 10px;">
                                <%= r.getUserType() %>
                            </span>
                        </td>
                        <td><%= categoryName %></td>

                        <td class="text-center">
                            <a href="toggle-vip?id=<%= r.getId() %>"
                               class="btn btn-sm <%= r.isVip() ? "btn-warning shadow-sm" : "btn-outline-secondary" %>"
                               title="Bấm để đổi trạng thái VIP"
                               style="border-radius: 50%; width: 34px; height: 34px; padding: 0; display: inline-flex; align-items: center; justify-content: center; transition: 0.2s;">
                                <i class="<%= r.isVip() ? "fas fa-star" : "far fa-star" %>"></i>
                            </a>
                        </td>

                        <td class="text-center text-nowrap">
                            <a href="admin-user?action=edit&id=<%= r.getId() %>" class="btn btn-sm btn-info shadow-sm" title="Sửa">
                                <i class="fas fa-edit"></i>
                            </a>
                            <a href="admin-user?action=delete&id=<%= r.getId() %>" class="btn btn-sm btn-danger shadow-sm ml-1" onclick="return confirm('Bạn có chắc muốn xóa?');" title="Xóa">
                                <i class="fas fa-trash"></i>
                            </a>
                        </td>
                    </tr>
                    <%
                        }
                    } else {
                    %>
                    <tr>
                        <td colspan="8" class="text-center py-4 text-muted">
                            <i class="fas fa-inbox fa-2x mb-2"></i><br>
                            Chưa có dữ liệu đăng ký nào
                        </td>
                    </tr>
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
            <nav aria-label="Page navigation" class="mt-4">
                <ul class="pagination justify-content-center">

                    <li class="page-item <%= (currentPage == 1) ? "disabled" : "" %>">
                        <a class="page-link" href="list-user?type=<%=type%>&page=<%= currentPage - 1 %>&vipStatus=<%=vipStatus%>">Trước</a>
                    </li>

                    <% for (int i = 1; i <= totalPages; i++) { %>
                    <li class="page-item <%= (i == currentPage) ? "active" : "" %>">
                        <a class="page-link" href="list-user?type=<%=type%>&page=<%= i %>&vipStatus=<%=vipStatus%>"><%= i %></a>
                    </li>
                    <% } %>

                    <li class="page-item <%= (currentPage == totalPages) ? "disabled" : "" %>">
                        <a class="page-link" href="list-user?type=<%=type%>&page=<%= currentPage + 1 %>&vipStatus=<%=vipStatus%>">Sau</a>
                    </li>

                </ul>
            </nav>
            <% } %>

        </div>
    </div>
</div>

<script>
    function startLoading() {
        let icon = document.getElementById("reloadIcon");
        let btn = document.getElementById("reloadBtn");

        if(icon) icon.classList.add("spin");
        if(btn) {
            btn.disabled = true;
            btn.style.opacity = "0.7";
        }
    }
</script>

<jsp:include page="admin-footer.jsp" />