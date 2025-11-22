<%-- file: admin_header.jsp --%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Category" %>
<%@ page import="service.CategoryService" %>
<%@ page import="serviceImpl.CategoryServiceImpl" %>
<%@ page import="utils.DataSourceUtil" %>

<%
    javax.sql.DataSource ds = DataSourceUtil.getDataSource();
    CategoryService categoryService = new CategoryServiceImpl(ds);
    List<Category> sidebarCategories = categoryService.findAll();
%>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <title>LHQ SEMINAR - Admin</title>

    <!-- Font Awesome -->
    <link href="<%=request.getContextPath()%>/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">

    <!-- Google Fonts: Nunito (đồng bộ với list-user.jsp) -->
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@300;400;600;700;800&display=swap" rel="stylesheet">

    <!-- SB Admin & Bootstrap -->
    <link href="<%=request.getContextPath()%>/css/sb-admin-2.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/bootstrap.min.css" rel="stylesheet">

    <style>
        /* Font chung cho toàn bộ Admin */
        body, html, p, span, a, td, th, h1, h2, h3, h4, h5, h6, button, input, label {
            font-family: 'Nunito', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif !important;
        }

        /* Sidebar tổng thể */
        .sidebar {
            background: linear-gradient(180deg, #4e73df 10%, #224abe 100%);
        }

        .sidebar .sidebar-brand {
            height: 4.375rem;
        }

        .sidebar .sidebar-brand-icon {
            font-size: 1.6rem;
        }

        .sidebar .sidebar-brand-text {
            font-size: 1rem;
            font-weight: 800;
            letter-spacing: .08rem;
            text-transform: uppercase;
        }

        /* Nav item & link */
        .sidebar .nav-item .nav-link {
            padding: 0.65rem 1rem;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            border-radius: 0.35rem;
            margin: 0 0.5rem 0.25rem;
            transition: all 0.15s ease-in-out;
        }

        .sidebar .nav-item .nav-link i {
            font-size: 0.95rem;
            margin-right: 0.6rem;
        }

        .sidebar .nav-item .nav-link span {
            font-weight: 600;
        }

        .sidebar .nav-item .nav-link:hover {
            background-color: rgba(255, 255, 255, 0.15);
            transform: translateX(2px);
        }

        .sidebar .nav-item.active .nav-link {
            background-color: rgba(255, 255, 255, 0.25);
            box-shadow: 0 0.2rem 0.5rem rgba(0, 0, 0, 0.15);
        }

        /* Heading trong sidebar */
        .sidebar-heading {
            font-size: 0.75rem;
            text-transform: uppercase;
            color: rgba(255, 255, 255, 0.6);
            padding: 0.75rem 1rem 0.25rem 1rem;
            font-weight: 700;
        }

        /* Collapse menu (Quản lý đăng ký) */
        .collapse-inner {
            border-radius: 0.35rem;
        }

        .collapse-inner .collapse-header {
            font-size: 0.75rem;
            font-weight: 700;
            color: #b7b9cc;
            text-transform: uppercase;
        }

        .collapse-inner .collapse-item {
            font-size: 0.85rem;
            padding: 0.35rem 1rem;
            border-radius: 0.25rem;
        }

        .collapse-inner .collapse-item:hover {
            background-color: #f8f9fc;
        }

        /* Topbar */
        .topbar {
            background-color: #ffffff;
        }

        .topbar .navbar-nav .nav-link {
            font-size: 0.9rem;
        }

        .topbar .dropdown-menu {
            font-size: 0.9rem;
        }

        .img-profile {
            height: 2.3rem;
            width: 2.3rem;
            object-fit: cover;
        }

        .topbar-divider {
            width: 0;
            border-right: 1px solid #e3e6f0;
            margin: 0 1rem;
        }

        /* Button bo tròn dùng chung */
        .btn-rounded {
            border-radius: 999px !important;
        }
    </style>
</head>

<body id="page-top">

<!-- Page Wrapper -->
<div id="wrapper">

    <!-- Sidebar -->
    <ul class="navbar-nav sidebar sidebar-dark accordion" id="accordionSidebar">

        <!-- Brand -->
        <a class="sidebar-brand d-flex align-items-center justify-content-center"
           href="<%= request.getContextPath() %>/admin">
            <div class="sidebar-brand-icon rotate-n-15">
                <i class="fas fa-laugh-wink"></i>
            </div>
            <div class="sidebar-brand-text mx-3">
                LHQ SEMINAR
            </div>
        </a>

        <hr class="sidebar-divider my-0">

        <!-- Dashboard -->
        <li class="nav-item active">
            <a class="nav-link" href="<%= request.getContextPath()%>/admin">
                <i class="fas fa-fw fa-tachometer-alt"></i>
                <span>Tổng quan</span>
            </a>
        </li>

        <hr class="sidebar-divider">

        <!-- Heading -->
        <div class="sidebar-heading">
            Quản lý
        </div>

        <!-- Quản lý hội thảo -->
        <li class="nav-item">
            <a class="nav-link" href="<%= request.getContextPath()%>/seminar_management">
                <i class="fas fa-fw fa-calendar-alt"></i>
                <span>Quản lý hội thảo</span>
            </a>
        </li>

        <!-- Quản lý đăng ký -->
        <li class="nav-item">
            <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseRegister"
               aria-expanded="false" aria-controls="collapseRegister">
                <i class="fas fa-fw fa-users"></i>
                <span>Quản lý đăng ký</span>
            </a>
            <div id="collapseRegister" class="collapse" aria-labelledby="headingRegister" data-parent="#accordionSidebar">
                <div class="bg-white py-2 collapse-inner rounded">
                    <h6 class="collapse-header">Danh mục hội thảo</h6>

                    <% if (sidebarCategories != null && !sidebarCategories.isEmpty()) { %>
                    <% for (Category c : sidebarCategories) { %>
                    <a class="collapse-item"
                       href="<%=request.getContextPath()%>/list-user?categoryId=<%= c.getId() %>">
                        Hội thảo <%= c.getName() %>
                    </a>
                    <% } %>
                    <% } else { %>
                    <span class="collapse-item text-muted">Chưa có danh mục nào.</span>
                    <% } %>
                </div>
            </div>
        </li>

        <!-- Cổng check-in -->
        <li class="nav-item">
            <a class="nav-link" href="<%=request.getContextPath()%>/check-in">
                <i class="fas fa-fw fa-qrcode"></i>
                <span>Cổng check-in</span>
            </a>
        </li>

        <!-- Sidebar Divider -->
        <hr class="sidebar-divider d-none d-md-block">

    </ul>
    <!-- End of Sidebar -->

    <!-- Content Wrapper -->
    <div id="content-wrapper" class="d-flex flex-column">

        <!-- Main Content -->
        <div id="content">

            <!-- Topbar -->
            <nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow">

                <!-- Sidebar Toggle (Topbar) -->
                <button id="sidebarToggleTop" class="btn btn-link d-md-none rounded-circle mr-3">
                    <i class="fa fa-bars"></i>
                </button>

                <!-- Topbar Navbar -->
                <ul class="navbar-nav ml-auto">

                    <div class="topbar-divider d-none d-sm-block"></div>

                    <!-- Nav Item - User Information -->
                    <li class="nav-item dropdown no-arrow">
                        <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button"
                           data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <span class="mr-2 d-none d-lg-inline text-gray-600 small">
                                Admin
                            </span>
                            <img class="img-profile rounded-circle"
                                 src="<%=request.getContextPath()%>/img/undraw_profile.svg">
                        </a>
                        <div class="dropdown-menu dropdown-menu-right shadow animated--grow-in"
                             aria-labelledby="userDropdown">

                            <a class="dropdown-item" href="#" data-toggle="modal" data-target="#logoutModal">
                                <i class="fas fa-sign-out-alt fa-sm fa-fw mr-2 text-gray-400"></i>
                                Đăng xuất
                            </a>
                        </div>
                    </li>

                </ul>

            </nav>
            <!-- End of Topbar -->
