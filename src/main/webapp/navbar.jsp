<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Seminar" %>
<%@ page import="service.SeminarService" %>
<%@ page import="serviceImpl.SeminarServiceImpl" %>
<%@ page import="utils.DataSourceUtil" %>
<%@ page import="javax.sql.DataSource" %>

<%
    // Khởi tạo service từ DataSource (dùng chung JNDI)
    DataSource ds = DataSourceUtil.getDataSource();
    SeminarService seminarService = new SeminarServiceImpl(ds);

    // 1: Hội thảo môi trường, 2: Công nghệ, 3: Khoa học
    List<Seminar> envSeminars  = seminarService.findByCategoryId(1);
    List<Seminar> techSeminars = seminarService.findByCategoryId(2);
    List<Seminar> sciSeminars  = seminarService.findByCategoryId(3);

    String ctx = request.getContextPath();
%>

<div class="container-fluid sticky-top">
    <div class="container">
        <nav class="navbar navbar-expand-lg navbar-light border-bottom border-2 border-white">
            <a href="<%= ctx %>/home.jsp" class="navbar-brand">
                <img src="img/logo8.png" alt="Logo" />
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

                            <!-- 🌿 Hội thảo Môi Trường -->
                            <h6 class="dropdown-header">Hội Thảo Môi Trường</h6>
                            <%
                                if (envSeminars != null && !envSeminars.isEmpty()) {
                                    for (Seminar s : envSeminars) {
                            %>
                            <a href="<%= ctx %>/seminar_detail_user?id=<%= s.getId() %>" class="dropdown-item">
                                <%= s.getName() %>
                            </a>

                            <%
                                }
                            } else {
                            %>
                            <span class="dropdown-item text-muted">Chưa có hội thảo</span>
                            <%
                                }
                            %>

                            <div class="dropdown-divider"></div>

                            <!-- 💻 Hội thảo Công Nghệ -->
                            <h6 class="dropdown-header">Hội Thảo Công Nghệ</h6>
                            <%
                                if (techSeminars != null && !techSeminars.isEmpty()) {
                                    for (Seminar s : techSeminars) {
                            %>
                            <a href="<%= ctx %>/seminar_detail_user?id=<%= s.getId() %>" class="dropdown-item">
                                <%= s.getName() %>
                            </a>

                            <%
                                }
                            } else {
                            %>
                            <span class="dropdown-item text-muted">Chưa có hội thảo</span>
                            <%
                                }
                            %>

                            <div class="dropdown-divider"></div>

                            <!-- 🔬 Hội thảo Khoa Học -->
                            <h6 class="dropdown-header">Hội Thảo Khoa Học</h6>
                            <%
                                if (sciSeminars != null && !sciSeminars.isEmpty()) {
                                    for (Seminar s : sciSeminars) {
                            %>
                            <a href="<%= ctx %>/seminar_detail_user?id=<%= s.getId() %>" class="dropdown-item">
                                <%= s.getName() %>
                            </a>

                            <%
                                }
                            } else {
                            %>
                            <span class="dropdown-item text-muted">Chưa có hội thảo</span>
                            <%
                                }
                            %>
                        </div>
                    </div>

                    <!-- Link Admin (tùy bạn chỉnh lại URL) -->
                    <a href="<%= ctx %>/admin.jsp" class="nav-item nav-link">Admin</a>
                </div>
            </div>
        </nav>
    </div>
</div>
