<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Seminar" %>
<%@ page import="model.Category" %>
<%@ page import="service.SeminarService" %>
<%@ page import="service.CategoryService" %>
<%@ page import="serviceImpl.SeminarServiceImpl" %>
<%@ page import="serviceImpl.CategoryServiceImpl" %>
<%@ page import="utils.DataSourceUtil" %>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="java.util.ArrayList" %>

<%
    DataSource ds = DataSourceUtil.getDataSource();
    SeminarService seminarService = new SeminarServiceImpl(ds);
    CategoryService categoryService = new CategoryServiceImpl(ds);

    // Lấy toàn bộ các category trong database
    List<Category> categories = categoryService.findAll();

    String ctx = request.getContextPath();
    // --- TÌM KIẾM HỘI THẢO THEO TÊN (CHO NAVBAR) ---
    String searchKeyword = request.getParameter("q");
    List<Seminar> searchResult = new ArrayList<>();

    if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
        String kwLower = searchKeyword.toLowerCase();
        // Cách đơn giản: lấy tất cả rồi filter theo tên
        List<Seminar> allSeminars = seminarService.findAll();
        if (allSeminars != null) {
            for (Seminar s : allSeminars) {
                if (s.getName() != null &&
                        s.getName().toLowerCase().contains(kwLower)) {
                    searchResult.add(s);
                }
            }
        }
    }
%>
<style>
    .nav-search-wrapper {
        min-width: 260px;
        margin-left: 16px; /* cho nó cách menu một chút */
        position: relative;
    }

    @media (max-width: 991.98px) {
        .nav-search-wrapper {
            width: 100%;
            margin: .5rem 0;
        }
    }
</style>

<div class="container-fluid sticky-top">
    <div class="container">
        <nav class="navbar navbar-expand-lg navbar-light border-bottom border-2 border-white">
            <a href="<%= ctx %>" class="navbar-brand">
                <img src="<%= ctx %>/img/logo8.png" alt="Logo">
            </a>

            <button type="button" class="navbar-toggler ms-auto me-0"
                    data-bs-toggle="collapse"
                    data-bs-target="#navbarCollapse">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarCollapse">
                <div class="navbar-nav ms-auto">

                    <!-- Dropdown Danh Mục Hội Thảo -->
                    <div class="nav-item dropdown">
                        <a href="#!" class="nav-link dropdown-toggle" data-bs-toggle="dropdown">
                            Danh Mục Hội Thảo
                        </a>

                        <div class="dropdown-menu bg-light mt-2">

                            <% for (Category c : categories) {
                                List<Seminar> seminars = seminarService.findByCategoryId(c.getId());
                            %>

                            <!-- Header tên Category -->
                            <h6 class="dropdown-header">Hội thảo <%= c.getName() %></h6>

                            <% if (seminars != null && !seminars.isEmpty()) { %>

                            <% for (Seminar s : seminars) { %>
                            <a href="<%= ctx %>/seminar_detail_user?id=<%= s.getId() %>"
                               class="dropdown-item">
                                <%= s.getName() %>
                            </a>
                            <% } %>

                            <% } else { %>

                            <span class="dropdown-item text-muted">Chưa có hội thảo</span>

                            <% } %>

                            <div class="dropdown-divider"></div>

                            <% } %>
                        </div>
                    </div>

                    <!-- Link Về chúng tôi -->
                    <a href="<%= ctx %>/about.jsp" class="nav-item nav-link">Về Chúng Tôi</a>
                </div>

                <!-- Ô TÌM KIẾM HỘI THẢO -->
                <div class="nav-item nav-search-wrapper d-flex align-items-center me-2">
                    <form class="d-flex w-100"
                          action="<%= ctx %>/home.jsp"
                          method="get">
                        <input type="text"
                               name="q"
                               class="form-control form-control-sm"
                               placeholder="Tìm hội thảo..."
                               value="<%= (searchKeyword != null) ? searchKeyword : "" %>">
                        <button class="btn btn-outline-primary btn-sm ms-1" type="submit">
                            <i class="fas fa-search"></i>
                        </button>
                    </form>

                    <%-- DROPDOWN KẾT QUẢ TÌM KIẾM  --%>
                    <% if (searchResult != null && !searchResult.isEmpty()) { %>
                    <div class="dropdown-menu bg-light mt-2 show"
                         style="min-width: 260px; max-height: 260px; overflow-y: auto;">
                        <h6 class="dropdown-header">
                            Kết quả cho "<%= searchKeyword %>"
                        </h6>
                        <% for (Seminar s : searchResult) { %>
                        <a class="dropdown-item"
                           href="<%= ctx %>/seminar_detail_user?id=<%= s.getId() %>">
                            <i class="fas fa-chalkboard me-1 text-primary"></i>
                            <%= s.getName() %>
                        </a>
                        <% } %>
                    </div>
                    <% } else if (searchKeyword != null && !searchKeyword.trim().isEmpty()) { %>
                    <div class="dropdown-menu bg-light mt-2 show"
                         style="min-width: 260px;">
                        <h6 class="dropdown-header">
                            Kết quả tìm kiếm
                        </h6>
                        <span class="dropdown-item text-muted">
            Không tìm thấy hội thảo phù hợp
        </span>
                    </div>
                    <% } %>
                </div>


            </div>
        </nav>
    </div>
</div>
