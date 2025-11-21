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

    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("HH:mm dd/MM/yyyy");
%>

<style>
    /* Tổng thể */
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

    .card-header-custom {
        border-bottom: 0;
        background: transparent;
        padding-bottom: 0;
    }

    /* Thanh công cụ */
    .toolbar-label {
        font-size: 0.8rem;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        color: #858796;
        margin-bottom: 0.25rem;
        font-weight: 600;
    }

    /* Bảng */
    .table thead th {
        font-size: 0.8rem;
        text-transform: uppercase;
        letter-spacing: 0.04em;
        white-space: nowrap;
    }

    .table td {
        font-size: 0.9rem;
        vertical-align: middle !important;
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
        padding: .3em .6em;
        border-radius: 999px;
    }

    .badge-status {
        font-size: 0.75rem;
        border-radius: 999px;
    }

    /* Nút hành động */
    .btn-icon-circle {
        width: 30px;
        height: 30px;
        border-radius: 50%;
        padding: 0;
        display: inline-flex;
        align-items: center;
        justify-content: center;
    }

    /* Phân trang */
    .pagination .page-link {
        font-size: 0.85rem;
        min-width: 36px;
        text-align: center;
    }

    .pagination .page-item.active .page-link {
        box-shadow: 0 0 0 0.15rem rgba(78,115,223,0.25);
    }

    /* Responsive nhỏ hơn */
    @media (max-width: 767.98px) {
        .toolbar-right {
            margin-top: 0.75rem;
        }
        .table-responsive {
            border-radius: .35rem;
        }
    }
</style>

<div class="container-fluid">

    <!-- Tiêu đề + tóm tắt -->
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <div class="d-flex align-items-center">
            <div class="page-title-icon">
                <i class="fas fa-chalkboard-teacher"></i>
            </div>
            <div>
                <h1 class="h3 mb-1 text-gray-800">Quản lý hội thảo</h1>
                <div class="text-muted small">
                    Theo dõi, tìm kiếm và quản lý các hội thảo trong hệ thống.
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

        <a href="<%= request.getContextPath()%>/add_seminar"
           class="btn btn-success btn-sm shadow-sm mt-3 mt-sm-0">
            <i class="fas fa-plus fa-sm text-white-50 me-1"></i> Thêm hội thảo
        </a>
    </div>

    <!-- Card chứa bộ lọc + bảng -->
    <div class="card shadow mb-4">
        <div class="card-header card-header-custom px-3 px-md-4 pt-3">
            <div class="row g-3 align-items-end">
                <div class="col-md-4">
                    <div class="toolbar-label">Danh sách hội thảo</div>
                    <h6 class="m-0 font-weight-bold text-primary">
                        Tất cả hội thảo
                        <% if (currentPage > 0 && totalPage > 0) { %>
                        <span class="text-muted small">
                                &mdash; Trang <%= currentPage %>/<%= totalPage %>
                            </span>
                        <% } %>
                    </h6>
                </div>

                <!-- Form tìm kiếm -->
                <div class="col-md-4 toolbar-right">
                    <div class="toolbar-label">Tìm kiếm</div>
                    <form action="seminar_management" method="GET">
                        <div class="input-group input-group-sm">
                            <input type="text"
                                   name="keyword"
                                   class="form-control"
                                   placeholder="Nhập tên hội thảo, diễn giả, địa điểm..."
                                   value="<%= keyword %>">
                            <!-- giữ sort khi search -->
                            <input type="hidden" name="sortField" value="<%= sortField %>">
                            <input type="hidden" name="order" value="<%= orderField %>">
                            <button class="btn btn-primary" type="submit">
                                <i class="fas fa-search fa-sm"></i>
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Sắp xếp -->
                <div class="col-md-4 toolbar-right">
                    <div class="toolbar-label">Sắp xếp</div>
                    <form action="seminar_management" method="GET" class="d-flex gap-2">
                        <input type="hidden" name="keyword" value="<%= keyword %>">
                        <div class="input-group input-group-sm me-2">
                            <label class="input-group-text" for="sortFieldSelect">
                                <i class="fas fa-sort-amount-down-alt"></i>
                            </label>
                            <select class="form-select" id="sortFieldSelect" name="sortField">
                                <option value="id" <%= "id".equals(sortField) ? "selected" : "" %>>Mặc định</option>
                                <option value="name" <%= "name".equals(sortField) ? "selected" : "" %>>Tên hội thảo</option>
                                <option value="start_date" <%= "start_date".equals(sortField) ? "selected" : "" %>>Ngày bắt đầu</option>
                                <option value="end_date" <%= "end_date".equals(sortField) ? "selected" : "" %>>Ngày kết thúc</option>
                            </select>
                        </div>
                        <div class="btn-group btn-group-sm" role="group" aria-label="Order">
                            <button type="submit"
                                    name="order"
                                    value="asc"
                                    class="btn btn-outline-secondary <%= "asc".equals(orderField) ? "active" : "" %>">
                                <i class="fas fa-arrow-up"></i>
                            </button>
                            <button type="submit"
                                    name="order"
                                    value="desc"
                                    class="btn btn-outline-secondary <%= "desc".equals(orderField) ? "active" : "" %>">
                                <i class="fas fa-arrow-down"></i>
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <hr class="mt-3 mb-0">
        </div>

        <div class="card-body px-2 px-md-3">
            <div class="table-responsive">
                <table class="table table-bordered table-hover mb-0">
                    <thead class="table-light">
                    <tr class="text-center align-middle">
                        <th style="width: 60px;">ID</th>
                        <th style="min-width: 220px;">Hội thảo</th>
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
                        <td class="text-center fw-bold"><%= s.getId() %></td>
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
                        <td colspan="9" class="text-center text-muted py-4">
                            <i class="far fa-folder-open fa-2x mb-2 d-block"></i>
                            Không tìm thấy hội thảo nào phù hợp với tiêu chí hiện tại.
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>

            <!-- Phân trang -->
            <% if (totalPage > 1) { %>
            <nav aria-label="Page navigation" class="mt-3">
                <ul class="pagination justify-content-center mb-0">

                    <!-- Previous -->
                    <li class="page-item <%= (currentPage <= 1 ? "disabled" : "") %>">
                        <a class="page-link"
                           href="seminar_management?page=<%= (currentPage - 1) %><%= params.toString() %>"
                           aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>

                    <!-- Page numbers -->
                    <%
                        for (int i = 1; i <= totalPage; i++) {
                    %>
                    <li class="page-item <%= (i == currentPage) ? "active" : "" %>">
                        <a class="page-link"
                           href="seminar_management?page=<%= i %><%= params.toString() %>"><%= i %></a>
                    </li>
                    <%
                        }
                    %>

                    <!-- Next -->
                    <li class="page-item <%= (currentPage >= totalPage ? "disabled" : "") %>">
                        <a class="page-link"
                           href="seminar_management?page=<%= (currentPage + 1) %><%= params.toString() %>"
                           aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>

                </ul>
            </nav>
            <% } %>
        </div>
    </div>
</div>

<script>
    // Kích hoạt tooltip Bootstrap 5 (nếu bạn đã load JS bootstrap bundle)
    document.addEventListener('DOMContentLoaded', function () {
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
        tooltipTriggerList.forEach(function (tooltipTriggerEl) {
            new bootstrap.Tooltip(tooltipTriggerEl)
        })
    });
</script>

<jsp:include page="admin-footer.jsp" />
