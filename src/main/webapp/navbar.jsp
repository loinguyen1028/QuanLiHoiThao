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

<%
    DataSource ds = DataSourceUtil.getDataSource();
    SeminarService seminarService = new SeminarServiceImpl(ds);
    CategoryService categoryService = new CategoryServiceImpl(ds);

    // Lấy toàn bộ các category trong database
    List<Category> categories = categoryService.findAll();

    String ctx = request.getContextPath();
%>

<div class="container-fluid sticky-top">
    <div class="container">
        <nav class="navbar navbar-expand-lg navbar-light border-bottom border-2 border-white">
            <a href="<%= ctx %>/home.jsp" class="navbar-brand">
                <img src="<%= ctx %>/img/logo8.png" alt="Logo">
            </a>

            <button type="button" class="navbar-toggler ms-auto me-0"
                    data-bs-toggle="collapse"
                    data-bs-target="#navbarCollapse">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarCollapse">
                <div class="navbar-nav ms-auto">
                    <a href="<%= ctx %>/home.jsp" class="nav-item nav-link active">Trang Chủ</a>

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

                    <!-- Link Admin -->
                    <a href="<%= ctx %>/about.jsp" class="nav-item nav-link">Về chúng tôi</a>
                </div>
            </div>
        </nav>
    </div>
</div>
