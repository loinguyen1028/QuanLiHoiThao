<%@ page import="java.util.*, model.Seminar, model.Page, model.PageRequest, dto.SeminarDTO, java.net.URLEncoder, java.nio.charset.StandardCharsets, java.time.format.DateTimeFormatter" %>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

<jsp:include page="admin-header.jsp" />

<%
    Page<SeminarDTO> result = (Page<SeminarDTO>) request.getAttribute("result");
    PageRequest pageRequest = (PageRequest) request.getAttribute("pageRequest");

    List<SeminarDTO> seminarList = new ArrayList<>();
    int totalPage = 0;
    int currentPage = 1;
    int totalItem = 0;

    if (result != null) {
        seminarList = result.getData();
        totalPage = result.getTotalPage();
        currentPage = result.getCurrentPage();
        totalItem = result.getTotalItem();
    }

    String keyword = (pageRequest != null && pageRequest.getKeyword() != null) ? pageRequest.getKeyword() : "";
    String sortField = (pageRequest != null && pageRequest.getSortField() != null) ? pageRequest.getSortField() : "id";
    String orderField = (pageRequest != null && pageRequest.getOrderField() != null) ? pageRequest.getOrderField() : "desc";

    StringBuilder params = new StringBuilder();
    if (keyword != null && !keyword.isEmpty()) {
        params.append("&keyword=").append(URLEncoder.encode(keyword, StandardCharsets.UTF_8));
    }
    if (sortField != null && !sortField.equals("id")) {
        params.append("&sortField=").append(sortField);
        params.append("&order=").append(orderField);
    }

    String queryParams = params.toString();
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy");
%>

<style>
    body {
        font-family: 'Nunito', sans-serif;
        background-color: #f8f9fc;
    }

    .page-title-icon {
        width: 42px;
        height: 42px;
        border-radius: 50%;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        background: linear-gradient(135deg, #4e73df, #1cc88a);
        color: #fff;
        margin-right: 12px;
        font-size: 18px;
    }

    .filter-bar {
        background: white;
        padding: 15px 20px;
        border-radius: 15px;
        box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.1);
        margin-bottom: 20px;
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
        align-items: center;
    }

    .filter-input {
        border-radius: 20px;
        border: 1px solid #d1d3e2;
        font-size: 0.9rem;
        padding: 0.375rem 1rem;
        min-width: 150px;
    }

    .filter-input:focus {
        box-shadow: none;
        border-color: #4e73df;
    }

    .btn-custom {
        border-radius: 20px;
        font-weight: 600;
        font-size: 0.9rem;
        padding: 6px 18px;
        transition: 0.2s;
    }

    .btn-search {
        background: #4e73df;
        color: white;
        border: none;
    }

    .btn-search:hover {
        background: #2e59d9;
        color: white;
        transform: translateY(-1px);
    }

    .btn-reset {
        background: #f8f9fc;
        color: #4e73df;
        border: 1px solid #d1d3e2;
    }

    .btn-reset:hover {
        background: #e2e6ea;
        color: #4e73df;
    }

    .table-card {
        border-radius: 15px;
        overflow: hidden;
        border: none;
        box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.1);
    }

    .table thead th {
        background-color: #f8f9fc;
        color: #4e73df;
        font-weight: 700;
        text-transform: uppercase;
        font-size: 0.8rem;
        border-bottom: 2px solid #e3e6f0;
        vertical-align: middle;
        white-space: nowrap;
    }

    .table td {
        vertical-align: middle;
        font-size: 0.9rem;
        padding: 12px;
    }

    .seminar-title {
        font-weight: 600;
        color: #4e73df;
    }

    .seminar-sub {
        font-size: 0.8rem;
        color: #858796;
    }

    .badge-category {
        font-size: 0.75rem;
        padding: 5px 10px;
        border-radius: 999px;
    }

    .btn-icon-circle {
        width: 32px;
        height: 32px;
        border-radius: 50%;
        padding: 0;
        display: inline-flex;
        align-items: center;
        justify-content: center;
    }

    .pagination .page-link {
        font-size: 0.85rem;
    }

    @media (max-width: 767.98px) {
        .filter-bar {
            flex-direction: column;
            align-items: flex-start;
        }
    }
</style>

<div class="container-fluid">

    <!-- Tiêu đề -->
    <div class="d-flex justify-content-between align-items-center mt-4 mb-3">
        <div class="d-flex align-items-center">
            <div class="page-title-icon">
                <i class="fas fa-chalkboard-teacher"></i>
            </div>
            <div>
                <h1 class="h3 mb-1 text-gray-800">Quản lý hội thảo</h1>
                <div class="text-muted small">
                    Theo dõi, tìm kiếm và sắp xếp các hội thảo trong hệ thống.
                </div>
                <div class="mt-1 small">
                    <span class="badge bg-primary text-white me-1">
                        Tổng: <%= totalItem %> hội thảo
                    </span>
                    <% if (keyword != null && !keyword.isEmpty()) { %>
                    <span class="badge bg-light text-primary border">
                        Từ khóa: "<%= keyword %>"
                    </span>
                    <% } %>
                </div>
            </div>
        </div>

        <a href="<%= request.getContextPath() %>/add_seminar"
           class="btn btn-success btn-custom shadow-sm mt-3 mt-sm-0">
            <i class="fas fa-plus fa-sm text-white-50 me-1"></i> Thêm hội thảo
        </a>
    </div>

    <!-- FILTER BAR: Tìm kiếm + Sắp xếp (giữ nguyên chức năng) -->
    <div class="filter-bar">

        <!-- Form tìm kiếm (giữ sort hiện tại qua hidden) -->
        <form action="seminar_management" method="GET" class="d-flex flex-wrap gap-2 align-items-center">
            <div class="input-group" style="min-width: 260px;">
                <input type="text"
                       name="keyword"
                       class="form-control filter-input"
                       placeholder="Tìm tên hội thảo, diễn giả, địa điểm..."
                       value="<%= keyword %>">
            </div>
            <input type="hidden" name="sortField" value="<%= sortField %>">
            <input type="hidden" name="order" value="<%= orderField %>">

            <button type="submit" class="btn btn-custom btn-search">
                <i class="fas fa-search"></i>
            </button>

            <a href="seminar_management" class="btn btn-custom btn-reset" title="Tải lại">
                <i class="fas fa-sync-alt"></i>
            </a>
        </form>

        <!-- Form sắp xếp (giữ keyword qua hidden) -->
        <form action="seminar_management" method="GET"
              class="d-flex flex-wrap gap-2 align-items-center ms-auto">

            <input type="hidden" name="keyword" value="<%= keyword %>">

            <div class="input-group input-group-sm" style="min-width: 220px;">
                <span class="input-group-text filter-input" style="border-radius: 20px 0 0 20px;">
                    <i class="fas fa-sort-amount-down-alt me-1"></i> Sắp xếp
                </span>
                <select class="form-select filter-input" name="sortField"
                        style="border-radius: 0 20px 20px 0; border-left: none;">
                    <option value="id" <%= "id".equals(sortField) ? "selected" : "" %>>Mặc định</option>
                    <option value="name" <%= "name".equals(sortField) ? "selected" : "" %>>Tên hội thảo</option>
                    <option value="start_date" <%= "start_date".equals(sortField) ? "selected" : "" %>>Ngày bắt đầu</option>
                    <option value="end_date" <%= "end_date".equals(sortField) ? "selected" : "" %>>Ngày kết thúc</option>
                </select>
            </div>

            <div class="btn-group" role="group" aria-label="Order">
                <button type="submit"
                        name="order"
                        value="asc"
                        class="btn btn-outline-secondary btn-custom <%= "asc".equals(orderField) ? "active" : "" %>">
                    <i class="fas fa-arrow-up"></i>
                </button>
                <button type="submit"
                        name="order"
                        value="desc"
                        class="btn btn-outline-secondary btn-custom <%= "desc".equals(orderField) ? "active" : "" %>">
                    <i class="fas fa-arrow-down"></i>
                </button>
            </div>
        </form>
    </div>

    <!-- BẢNG HỘI THẢO (table-card giống list-user) -->
    <div class="card table-card mb-4">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0" width="100%">
                    <thead>
                    <tr class="text-center">
                        <th style="width: 60px;">ID</th>
                        <th style="min-width: 230px;">Hội thảo</th>
                        <th style="width: 170px;">Ngày bắt đầu</th>
                        <th style="width: 170px;">Ngày kết thúc</th>
                        <th style="min-width: 160px;">Địa điểm</th>
                        <th style="min-width: 140px;">Diễn giả</th>
                        <th style="min-width: 130px;">Loại</th>
                        <th style="width: 90px;">SL tối đa</th>
                        <th style="min-width: 160px;">Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        if (seminarList != null && !seminarList.isEmpty()) {
                            for (SeminarDTO s : seminarList) {
                    %>
                    <tr>
                        <td class="text-center text-muted fw-bold">#<%= s.getId() %></td>
                        <td>
                            <div class="seminar-title mb-1"><%= s.getName() %></div>
                            <div class="seminar-sub">
                                <i class="far fa-clock me-1"></i>
                                <%= s.getStart_date().format(dtf) %> - <%= s.getEnd_date().format(dtf) %>
                            </div>
                        </td>
                        <td class="text-center text-nowrap">
                            <i class="far fa-calendar-alt me-1 text-primary"></i>
                            <%= s.getStart_date().format(dtf) %>
                        </td>
                        <td class="text-center text-nowrap">
                            <i class="far fa-calendar-check me-1 text-success"></i>
                            <%= s.getEnd_date().format(dtf) %>
                        </td>
                        <td>
                            <i class="fas fa-map-marker-alt me-1 text-danger"></i>
                            <span><%= s.getLocation() %></span>
                        </td>
                        <td>
                            <i class="fas fa-user-tie me-1 text-secondary"></i>
                            <span><%= s.getSpeaker() %></span>
                        </td>
                        <td class="text-center">
                            <% String cat = s.getCategoryName() != null ? s.getCategoryName() : "Khác"; %>
                            <span class="badge badge-category
                                <%
                                    if (cat.toLowerCase().contains("công nghệ")) {
                                        out.print("bg-info text-dark");
                                    } else if (cat.toLowerCase().contains("môi trường")) {
                                        out.print("bg-success");
                                    } else if (cat.toLowerCase().contains("khoa học")) {
                                        out.print("bg-warning text-dark");
                                    } else {
                                        out.print("bg-secondary");
                                    }
                                %>">
                                <%= cat %>
                            </span>
                        </td>
                        <td class="text-center">
                            <span class="badge bg-light text-dark border"><%= s.getMaxAttendance() %></span>
                        </td>
                        <td class="text-center">
                            <div class="btn-group" role="group" aria-label="Actions">
                                <a href="<%= request.getContextPath()%>/detail_seminar?id=<%= s.getId()%>"
                                   class="btn btn-info btn-icon-circle btn-sm me-1"
                                   data-bs-toggle="tooltip" title="Xem chi tiết">
                                    <i class="fas fa-eye"></i>
                                </a>
                                <a href="<%= request.getContextPath()%>/edit_seminar?id=<%= s.getId()%>"
                                   class="btn btn-warning btn-icon-circle btn-sm me-1"
                                   data-bs-toggle="tooltip" title="Chỉnh sửa">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <a href="<%= request.getContextPath()%>/delete_seminar?id=<%= s.getId()%>"
                                   class="btn btn-danger btn-icon-circle btn-sm"
                                   onclick="return confirm('Bạn có chắc muốn xóa hội thảo này?')"
                                   data-bs-toggle="tooltip" title="Xóa">
                                    <i class="fas fa-trash-alt"></i>
                                </a>
                            </div>
                        </td>
                    </tr>
                    <%
                        }
                    } else {
                    %>
                    <tr>
                        <td colspan="9" class="text-center py-5 text-muted">
                            <i class="far fa-folder-open fa-3x mb-3 d-block"></i>
                            Không tìm thấy hội thảo nào phù hợp với tiêu chí hiện tại.
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>

            <!-- PHÂN TRANG: style giống list-user.jsp nhưng vẫn dùng logic cũ -->
            <% if (totalPage > 1) { %>
            <div class="d-flex justify-content-center py-3">
                <nav>
                    <ul class="pagination m-0">
                        <li class="page-item <%= (currentPage <= 1) ? "disabled" : "" %>">
                            <a class="page-link rounded-pill px-3 mr-1"
                               href="seminar_management?page=<%= currentPage - 1 %><%= queryParams %>">
                                Trước
                            </a>
                        </li>

                        <%
                            for (int i = 1; i <= totalPage; i++) {
                        %>
                        <li class="page-item <%= (i == currentPage) ? "active" : "" %>">
                            <a class="page-link rounded-circle mx-1"
                               style="width: 35px; height: 35px; display:flex; align-items:center; justify-content:center;"
                               href="seminar_management?page=<%= i %><%= queryParams %>"><%= i %></a>
                        </li>
                        <%
                            }
                        %>

                        <li class="page-item <%= (currentPage >= totalPage) ? "disabled" : "" %>">
                            <a class="page-link rounded-pill px-3 ml-1"
                               href="seminar_management?page=<%= currentPage + 1 %><%= queryParams %>">
                                Sau
                            </a>
                        </li>
                    </ul>
                </nav>
            </div>
            <% } %>
        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
        tooltipTriggerList.forEach(function (tooltipTriggerEl) {
            new bootstrap.Tooltip(tooltipTriggerEl)
        })
    });
</script>

<jsp:include page="admin-footer.jsp" />
