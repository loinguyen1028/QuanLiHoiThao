<%-- file: admin_header.jsp --%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <title>LHQ SEMINAR - Admin</title>

    <!-- Font Awesome & Google Fonts -->
    <link href="<%=request.getContextPath()%>/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        body, html, p, span, a, td, th, h1, h2, h3, h4, h5, h6, button, input, label {
            font-family: 'Inter', 'Roboto', sans-serif !important;
        }

    </style>



    <!-- SB Admin & Bootstrap -->
    <link href="<%=request.getContextPath()%>/css/sb-admin-2.min.css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/css/bootstrap.min.css" rel="stylesheet">


    <style>
        .sidebar .sidebar-brand-text {
            font-size: 1rem;
            font-weight: 700;
            letter-spacing: .05rem;
        }
        .topbar .navbar-nav .nav-link {
            font-size: 0.9rem;
        }
        .btn-rounded {
            border-radius: 8px !important;
        }

    </style>
</head>

<body id="page-top">

<!-- Page Wrapper -->
<div id="wrapper">

    <!-- Sidebar -->
    <ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar">

        <!-- Brand -->
        <a class="sidebar-brand d-flex align-items-center justify-content-center"
           href="<%= request.getContextPath() %>/admin">
            <div class="sidebar-brand-icon rotate-n-15">
                <i class="fas fa-laugh-wink"></i>
            </div>
            <div class="sidebar-brand-text mx-3">LHQ SEMINAR</div>
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
                    <h6 class="collapse-header">Danh sách người đăng ký</h6>
                    <a class="collapse-item" href="<%=request.getContextPath()%>/list-user?type=environment">
                        Hội thảo môi trường
                    </a>
                    <a class="collapse-item" href="<%=request.getContextPath()%>/list-user?type=technology">
                        Hội thảo công nghệ
                    </a>
                    <a class="collapse-item" href="<%=request.getContextPath()%>/list-user?type=science">
                        Hội thảo khoa học
                    </a>
                </div>
            </div>
        </li>

        <!-- Cổng check-in -->
        <li class="nav-item">
            <a class="nav-link" href="<%=request.getContextPath()%>/check-in.jsp">
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

                    <!-- Nav Item - Thông báo (demo, tối giản) -->
                    <li class="nav-item dropdown no-arrow mx-1">
                        <a class="nav-link dropdown-toggle" href="#" id="alertsDropdown" role="button"
                           data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <i class="fas fa-bell fa-fw"></i>
                            <span class="badge badge-danger badge-counter">0</span>
                        </a>
                        <div class="dropdown-list dropdown-menu dropdown-menu-right shadow animated--grow-in"
                             aria-labelledby="alertsDropdown">
                            <h6 class="dropdown-header">
                                Thông báo
                            </h6>
                            <span class="dropdown-item small text-gray-500">
                                Hiện chưa có thông báo mới.
                            </span>
                        </div>
                    </li>

                    <!-- Nav Item - Tin nhắn (demo, tối giản) -->
                    <li class="nav-item dropdown no-arrow mx-1">
                        <a class="nav-link dropdown-toggle" href="#" id="messagesDropdown" role="button"
                           data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <i class="fas fa-envelope fa-fw"></i>
                            <span class="badge badge-danger badge-counter">0</span>
                        </a>
                        <div class="dropdown-list dropdown-menu dropdown-menu-right shadow animated--grow-in"
                             aria-labelledby="messagesDropdown">
                            <h6 class="dropdown-header">
                                Hộp thư
                            </h6>
                            <span class="dropdown-item small text-gray-500">
                                Hiện chưa có tin nhắn mới.
                            </span>
                        </div>
                    </li>

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
                            <h6 class="dropdown-header">
                                Tài khoản quản trị
                            </h6>
                            <a class="dropdown-item" href="#">
                                <i class="fas fa-user fa-sm fa-fw mr-2 text-gray-400"></i>
                                Thông tin cá nhân
                            </a>
                            <a class="dropdown-item" href="#">
                                <i class="fas fa-cogs fa-sm fa-fw mr-2 text-gray-400"></i>
                                Cài đặt
                            </a>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" href="#" data-toggle="modal" data-target="#logoutModal">
                                <i class="fas fa-sign-out-alt fa-sm fa-fw mr-2 text-gray-400"></i>
                                Đăng xuất
                            </a>
                        </div>
                    </li>

                </ul>

            </nav>
            <!-- End of Topbar -->