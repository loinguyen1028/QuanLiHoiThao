<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Seminar" %>
<%@ page import="model.Page" %>
<%@ page import="model.PageRequest" %>
<%@ page import="service.SeminarService" %>
<%@ page import="serviceImpl.SeminarServiceImpl" %>
<%@ page import="utils.DataSourceUtil" %>
<%@ page import="javax.sql.DataSource" %>

<%
    // Lấy 6 hội thảo mới nhất (sắp xếp theo start_date DESC)
    DataSource dsHome = DataSourceUtil.getDataSource();
    SeminarService seminarServiceHome = new SeminarServiceImpl(dsHome);

    PageRequest prHome = new PageRequest(1, 6, "start_date", "desc", "");
    Page<Seminar> pageHome = seminarServiceHome.findAll(prHome);
    List<Seminar> latestSeminars = pageHome != null ? pageHome.getData() : null;
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <style>
        /* Hiệu ứng cho toàn bộ item */
        .testimonial-item {
            transition: all 0.3s ease;
            padding: 15px;
            border-radius: 12px;
        }

        .testimonial-item:hover {
            transform: translateY(-8px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.12);
            background: #ffffff;
        }

        /* Hiệu ứng cho ảnh */
        .testimonial-item img {
            transition: all 0.4s ease;
            border-radius: 10px;
        }

        .testimonial-item:hover img {
            transform: scale(1.08);
            filter: brightness(1.1);
        }

        /* Tiêu đề đổi màu khi hover */
        .testimonial-item:hover h3 {
            color: #009966; /* xanh primary bootstrap */
            transition: color 0.3s ease;
        }
    </style>

    <meta charset="utf-8">
    <title>LHQ-SEMINAR</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <meta content="" name="keywords">
    <meta content="" name="description">

    <!-- Favicon -->
    <link href="img/favicon.ico" rel="icon">

    <!-- Google Web Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans&family=Space+Grotesk&display=swap" rel="stylesheet">

    <!-- Icon Font Stylesheet -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Libraries Stylesheet -->
    <link href="lib/animate/animate.min.css" rel="stylesheet">
    <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">

    <!-- Customized Bootstrap Stylesheet -->
    <link href="css/bootstrap.min.css" rel="stylesheet">

    <!-- Template Stylesheet -->
    <link href="css/style.css" rel="stylesheet">
</head>

<body>
<%@ include file="navbar.jsp" %>
<!-- Spinner Start -->
<div id="spinner"
     class="show bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center">
    <div class="spinner-grow text-primary" style="width: 3rem; height: 3rem;" role="status">
        <span class="sr-only">Loading...</span>
    </div>
</div>
<!-- Spinner End -->

<!-- Hero Start -->
<div class="container-fluid pb-5 hero-header bg-light mb-5">
    <div class="container py-5">
        <div class="row g-5 align-items-center mb-5">
            <div class="col-lg-6">
                <h1 class="display-1 mb-4 animated slideInRight">
                    <span class="text-primary fw-bold">BỨT PHÁ TRONG KỶ NGUYÊN CHUYỂN ĐỔI SỐ</span>
                </h1>

                <h5 class="d-inline-block border border-2 border-white py-3 px-5 mb-0 animated slideInRight">
                    "ỨNG DỤNG – ĐỔI MỚI– PHÁT TRIỂN BỀN VỮNG"</h5>
            </div>
            <div class="col-lg-6">
                <div class="owl-carousel header-carousel animated fadeIn">
                    <img class="img-fluid" src="img/banner2.jpg" alt="">
                    <img class="img-fluid" src="img/banner3.jpg" alt="">
                    <img class="img-fluid" src="img/banner4.jpg" alt="">
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Hero End -->

<!-- Testimonial Start (6 hội thảo mới nhất – chia 2 cột) -->
<div class="container-fluid py-5 bg-light">
    <div class="container py-5">
        <div class="row g-5">

            <%
                if (latestSeminars == null || latestSeminars.isEmpty()) {
            %>

            <div class="col-12 text-center">
                <h4>Chưa có hội thảo nào.</h4>
            </div>

            <%
            } else {

                // Chia trái phải
                List<Seminar> leftCol = latestSeminars.subList(0, Math.min(3, latestSeminars.size()));
                List<Seminar> rightCol = latestSeminars.size() > 3
                        ? latestSeminars.subList(3, Math.min(6, latestSeminars.size()))
                        : java.util.Collections.emptyList();
            %>

            <!-- CỘT TRÁI -->
            <div class="col-lg-6">

                <% for (Seminar s : leftCol) {
                    String img = (s.getImage() == null || s.getImage().isBlank())
                            ? "img/test1.png"
                            : s.getImage();

                    String desc = s.getDescription() != null ? s.getDescription() : "";
                    if (desc.length() > 110) desc = desc.substring(0, 110) + "...";
                %>

                <div class="testimonial-item mb-5">
                    <div class="row g-4 align-items-center">
                        <div class="col-6">
                            <a href="<%= ctx %>/seminar_detail_user?id=<%= s.getId() %>">
                                <img class="img-fluid" src="<%= img %>" alt="">
                            </a>

                        </div>
                        <div class="col-6">
                            <h3>
                                <a href="<%= ctx %>/seminar_detail_user?id=<%= s.getId() %>"
                                   style="text-decoration:none; color:#000;">
                                    <%= s.getName() %>
                                </a>
                            </h3>

                            <p><%= desc %></p>
                            <h5 class="mb-0">
                                <i class="bi bi-person-circle"></i>
                                <%= (s.getSpeaker() != null && !s.getSpeaker().isBlank())
                                        ? s.getSpeaker()
                                        : "Đang cập nhật" %>
                            </h5>
                        </div>
                    </div>
                </div>

                <% } %>
            </div>

            <!-- CỘT PHẢI -->
            <div class="col-lg-6">

                <% for (Seminar s : rightCol) {
                    String img = (s.getImage() == null || s.getImage().isBlank())
                            ? "img/test1.png"
                            : s.getImage();

                    String desc = s.getDescription() != null ? s.getDescription() : "";
                    if (desc.length() > 110) desc = desc.substring(0, 110) + "...";
                %>

                <div class="testimonial-item mb-5">
                    <div class="row g-4 align-items-center">
                        <div class="col-6">
                            <a href="<%= ctx %>/seminar_detail_user?id=<%= s.getId() %>">
                                <img class="img-fluid" src="<%= img %>" alt="">
                            </a>

                        </div>
                        <div class="col-6">
                            <h3>
                                <a href="<%= ctx %>/seminar_detail_user?id=<%= s.getId() %>"
                                   style="text-decoration:none; color:#000;">
                                    <%= s.getName() %>
                                </a>
                            </h3>

                            <p><%= desc %></p>
                            <h5 class="mb-0">
                                <i class="bi bi-person-circle"></i>
                                <%= (s.getSpeaker() != null && !s.getSpeaker().isBlank())
                                        ? s.getSpeaker()
                                        : "Đang cập nhật" %>
                            </h5>
                        </div>
                    </div>
                </div>

                <% } %>
            </div>

            <% } %>

        </div>
    </div>
</div>
<!-- Testimonial End -->


<!-- About Start -->
<div class="container-fluid py-5">
    <div class="container">
        <div class="row g-5">
            <div class="col-lg-6">
                <div class="row">
                    <div class="col-6 wow fadeIn" data-wow-delay="0.1s">
                        <img class="img-fluid" src="img/about-1.jpg" alt="">
                    </div>
                    <div class="col-6 wow fadeIn" data-wow-delay="0.3s">
                        <img class="img-fluid h-75" src="img/about-2.jpg" alt="">
                        <div class="h-25 d-flex align-items-center text-center bg-primary px-4">
                            <h4 class="text-white lh-base mb-0">Award Winning Studio Since 1990</h4>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-6 wow fadeIn" data-wow-delay="0.5s">
                <h1 class="mb-5"><span class="text-uppercase text-primary bg-light px-2">History</span> of Our
                    Creation</h1>
                <p class="mb-4">Tempor erat elitr rebum at clita. Diam dolor diam ipsum et tempor sit. Aliqu diam
                    amet diam et eos labore. Clita erat ipsum et lorem et sit, sed stet no labore lorem sit. Sanctus
                    clita duo justo et tempor eirmod magna dolore erat amet</p>
                <p class="mb-5">Aliqu diam amet diam et eos labore. Clita erat ipsum et lorem et sit, sed stet no
                    labore lorem sit. Sanctus clita duo justo et tempor.</p>
                <div class="row g-3">
                    <div class="col-sm-6">
                        <h6 class="mb-3"><i class="fa fa-check text-primary me-2"></i>Award Winning</h6>
                        <h6 class="mb-0"><i class="fa fa-check text-primary me-2"></i>Professional Staff</h6>
                    </div>
                    <div class="col-sm-6">
                        <h6 class="mb-3"><i class="fa fa-check text-primary me-2"></i>24/7 Support</h6>
                        <h6 class="mb-0"><i class="fa fa-check text-primary me-2"></i>Fair Prices</h6>
                    </div>
                </div>
                <div class="d-flex align-items-center mt-5">
                    <a class="btn btn-primary px-4 me-2" href="#!">Read More</a>
                    <a class="btn btn-outline-primary btn-square border-2 me-2" href="#!"><i
                            class="fab fa-facebook-f"></i></a>
                    <a class="btn btn-outline-primary btn-square border-2 me-2" href="#!"><i
                            class="fab fa-twitter"></i></a>
                    <a class="btn btn-outline-primary btn-square border-2 me-2" href="#!"><i
                            class="fab fa-instagram"></i></a>
                    <a class="btn btn-outline-primary btn-square border-2" href="#!"><i
                            class="fab fa-linkedin-in"></i></a>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- About End -->


<%--    <!-- Feature Start -->--%>
<%--    <div class="container-fluid py-5">--%>
<%--        <div class="container">--%>
<%--            <div class="text-center wow fadeIn" data-wow-delay="0.1s">--%>
<%--                <h1 class="mb-5">Why People <span class="text-uppercase text-primary bg-light px-2">Choose Us</span>--%>
<%--                </h1>--%>
<%--            </div>--%>
<%--            <div class="row g-5 align-items-center text-center">--%>
<%--                <div class="col-md-6 col-lg-4 wow fadeIn" data-wow-delay="0.1s">--%>
<%--                    <i class="fa fa-calendar-alt fa-5x text-primary mb-4"></i>--%>
<%--                    <h4>25+ Years Experience</h4>--%>
<%--                    <p class="mb-0">Clita erat ipsum et lorem et sit, sed stet no labore lorem sit. Sanctus clita duo--%>
<%--                        justo et tempor eirmod magna dolore erat amet</p>--%>
<%--                </div>--%>
<%--                <div class="col-md-6 col-lg-4 wow fadeIn" data-wow-delay="0.3s">--%>
<%--                    <i class="fa fa-tasks fa-5x text-primary mb-4"></i>--%>
<%--                    <h4>Best Interior Design</h4>--%>
<%--                    <p class="mb-0">Clita erat ipsum et lorem et sit, sed stet no labore lorem sit. Sanctus clita duo--%>
<%--                        justo et tempor eirmod magna dolore erat amet</p>--%>
<%--                </div>--%>
<%--                <div class="col-md-6 col-lg-4 wow fadeIn" data-wow-delay="0.5s">--%>
<%--                    <i class="fa fa-pencil-ruler fa-5x text-primary mb-4"></i>--%>
<%--                    <h4>Innovative Architects</h4>--%>
<%--                    <p class="mb-0">Clita erat ipsum et lorem et sit, sed stet no labore lorem sit. Sanctus clita duo--%>
<%--                        justo et tempor eirmod magna dolore erat amet</p>--%>
<%--                </div>--%>
<%--                <div class="col-md-6 col-lg-4 wow fadeIn" data-wow-delay="0.1s">--%>
<%--                    <i class="fa fa-user fa-5x text-primary mb-4"></i>--%>
<%--                    <h4>Customer Satisfaction</h4>--%>
<%--                    <p class="mb-0">Clita erat ipsum et lorem et sit, sed stet no labore lorem sit. Sanctus clita duo--%>
<%--                        justo et tempor eirmod magna dolore erat amet</p>--%>
<%--                </div>--%>
<%--                <div class="col-md-6 col-lg-4 wow fadeIn" data-wow-delay="0.3s">--%>
<%--                    <i class="fa fa-hand-holding-usd fa-5x text-primary mb-4"></i>--%>
<%--                    <h4>Budget Friendly</h4>--%>
<%--                    <p class="mb-0">Clita erat ipsum et lorem et sit, sed stet no labore lorem sit. Sanctus clita duo--%>
<%--                        justo et tempor eirmod magna dolore erat amet</p>--%>
<%--                </div>--%>
<%--                <div class="col-md-6 col-lg-4 wow fadeIn" data-wow-delay="0.5s">--%>
<%--                    <i class="fa fa-check fa-5x text-primary mb-4"></i>--%>
<%--                    <h4>Sustainable Material</h4>--%>
<%--                    <p class="mb-0">Clita erat ipsum et lorem et sit, sed stet no labore lorem sit. Sanctus clita duo--%>
<%--                        justo et tempor eirmod magna dolore erat amet</p>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--    <!-- Feature End -->--%>


<%--    <!-- Project Start -->--%>
<%--    <div class="container-fluid mt-5">--%>
<%--        <div class="container mt-5">--%>
<%--            <div class="row g-0">--%>
<%--                <div class="col-lg-5 wow fadeIn" data-wow-delay="0.1s">--%>
<%--                    <div class="d-flex flex-column justify-content-center bg-primary h-100 p-5">--%>
<%--                        <h1 class="text-white mb-5">Our Latest <span--%>
<%--                                class="text-uppercase text-primary bg-light px-2">Projects</span></h1>--%>
<%--                        <h4 class="text-white mb-0"><span class="display-1">6</span> of our latest projects</h4>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--                <div class="col-lg-7">--%>
<%--                    <div class="row g-0">--%>
<%--                        <div class="col-md-6 col-lg-4 wow fadeIn" data-wow-delay="0.2s">--%>
<%--                            <div class="project-item position-relative overflow-hidden">--%>
<%--                                <img class="img-fluid w-100" src="img/project-1.jpg" alt="">--%>
<%--                                <a class="project-overlay text-decoration-none" href="#!">--%>
<%--                                    <h4 class="text-white">Kitchen</h4>--%>
<%--                                    <small class="text-white">72 Projects</small>--%>
<%--                                </a>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                        <div class="col-md-6 col-lg-4 wow fadeIn" data-wow-delay="0.3s">--%>
<%--                            <div class="project-item position-relative overflow-hidden">--%>
<%--                                <img class="img-fluid w-100" src="img/project-2.jpg" alt="">--%>
<%--                                <a class="project-overlay text-decoration-none" href="#!">--%>
<%--                                    <h4 class="text-white">Bathroom</h4>--%>
<%--                                    <small class="text-white">67 Projects</small>--%>
<%--                                </a>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                        <div class="col-md-6 col-lg-4 wow fadeIn" data-wow-delay="0.4s">--%>
<%--                            <div class="project-item position-relative overflow-hidden">--%>
<%--                                <img class="img-fluid w-100" src="img/project-3.jpg" alt="">--%>
<%--                                <a class="project-overlay text-decoration-none" href="#!">--%>
<%--                                    <h4 class="text-white">Bedroom</h4>--%>
<%--                                    <small class="text-white">53 Projects</small>--%>
<%--                                </a>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                        <div class="col-md-6 col-lg-4 wow fadeIn" data-wow-delay="0.5s">--%>
<%--                            <div class="project-item position-relative overflow-hidden">--%>
<%--                                <img class="img-fluid w-100" src="img/project-4.jpg" alt="">--%>
<%--                                <a class="project-overlay text-decoration-none" href="#!">--%>
<%--                                    <h4 class="text-white">Living Room</h4>--%>
<%--                                    <small class="text-white">33 Projects</small>--%>
<%--                                </a>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                        <div class="col-md-6 col-lg-4 wow fadeIn" data-wow-delay="0.6s">--%>
<%--                            <div class="project-item position-relative overflow-hidden">--%>
<%--                                <img class="img-fluid w-100" src="img/project-5.jpg" alt="">--%>
<%--                                <a class="project-overlay text-decoration-none" href="#!">--%>
<%--                                    <h4 class="text-white">Furniture</h4>--%>
<%--                                    <small class="text-white">87 Projects</small>--%>
<%--                                </a>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                        <div class="col-md-6 col-lg-4 wow fadeIn" data-wow-delay="0.7s">--%>
<%--                            <div class="project-item position-relative overflow-hidden">--%>
<%--                                <img class="img-fluid w-100" src="img/project-6.jpg" alt="">--%>
<%--                                <a class="project-overlay text-decoration-none" href="#!">--%>
<%--                                    <h4 class="text-white">Rennovation</h4>--%>
<%--                                    <small class="text-white">69 Projects</small>--%>
<%--                                </a>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--    <!-- Project End -->--%>


<%--    <!-- Service Start -->--%>
<%--    <div class="container-fluid py-5">--%>
<%--        <div class="container py-5">--%>
<%--            <div class="row g-5 align-items-center">--%>
<%--                <div class="col-lg-5 wow fadeIn" data-wow-delay="0.1s">--%>
<%--                    <h1 class="mb-5">Our Creative <span--%>
<%--                            class="text-uppercase text-primary bg-light px-2">Services</span></h1>--%>
<%--                    <p>Aliqu diam--%>
<%--                        amet diam et eos labore. Clita erat ipsum et lorem et sit, sed stet no labore lorem sit. Sanctus--%>
<%--                        clita duo justo et tempor eirmod magna dolore erat amet</p>--%>
<%--                    <p class="mb-5">Tempor erat elitr rebum at clita. Diam dolor diam ipsum et tempor sit. Aliqu diam--%>
<%--                        amet diam et eos labore. Clita erat ipsum et lorem et sit, sed stet no labore lorem sit. Sanctus--%>
<%--                        clita duo justo et tempor eirmod magna dolore erat amet</p>--%>
<%--                    <div class="d-flex align-items-center bg-light">--%>
<%--                        <div class="btn-square flex-shrink-0 bg-primary" style="width: 100px; height: 100px;">--%>
<%--                            <i class="fa fa-phone fa-2x text-white"></i>--%>
<%--                        </div>--%>
<%--                        <div class="px-3">--%>
<%--                            <h3>+0123456789</h3>--%>
<%--                            <span>Call us direct 24/7 for get a free consultation</span>--%>
<%--                        </div>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--                <div class="col-lg-7">--%>
<%--                    <div class="row g-0">--%>
<%--                        <div class="col-md-6 wow fadeIn" data-wow-delay="0.2s">--%>
<%--                            <div class="service-item h-100 d-flex flex-column justify-content-center bg-primary">--%>
<%--                                <a href="#!" class="service-img position-relative mb-4">--%>
<%--                                    <img class="img-fluid w-100" src="img/service-1.jpg" alt="">--%>
<%--                                    <h3>Interior Design</h3>--%>
<%--                                </a>--%>
<%--                                <p class="mb-0">Erat ipsum justo amet duo et elitr dolor, est duo duo eos lorem sed diam--%>
<%--                                    stet diam sed stet lorem.</p>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                        <div class="col-md-6 wow fadeIn" data-wow-delay="0.4s">--%>
<%--                            <div class="service-item h-100 d-flex flex-column justify-content-center bg-light">--%>
<%--                                <a href="#!" class="service-img position-relative mb-4">--%>
<%--                                    <img class="img-fluid w-100" src="img/service-2.jpg" alt="">--%>
<%--                                    <h3>Implement</h3>--%>
<%--                                </a>--%>
<%--                                <p class="mb-0">Erat ipsum justo amet duo et elitr dolor, est duo duo eos lorem sed diam--%>
<%--                                    stet diam sed stet lorem.</p>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                        <div class="col-md-6 wow fadeIn" data-wow-delay="0.6s">--%>
<%--                            <div class="service-item h-100 d-flex flex-column justify-content-center bg-light">--%>
<%--                                <a href="#!" class="service-img position-relative mb-4">--%>
<%--                                    <img class="img-fluid w-100" src="img/service-3.jpg" alt="">--%>
<%--                                    <h3>Renovation</h3>--%>
<%--                                </a>--%>
<%--                                <p class="mb-0">Erat ipsum justo amet duo et elitr dolor, est duo duo eos lorem sed diam--%>
<%--                                    stet diam sed stet lorem.</p>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                        <div class="col-md-6 wow fadeIn" data-wow-delay="0.8s">--%>
<%--                            <div class="service-item h-100 d-flex flex-column justify-content-center bg-primary">--%>
<%--                                <a href="#!" class="service-img position-relative mb-4">--%>
<%--                                    <img class="img-fluid w-100" src="img/service-4.jpg" alt="">--%>
<%--                                    <h3>Commercial</h3>--%>
<%--                                </a>--%>
<%--                                <p class="mb-0">Erat ipsum justo amet duo et elitr dolor, est duo duo eos lorem sed diam--%>
<%--                                    stet diam sed stet lorem.</p>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--    <!-- Service End -->--%>


<%--    <!-- Team Start -->--%>
<%--    <div class="container-fluid bg-light py-5">--%>
<%--        <div class="container py-5">--%>
<%--            <h1 class="mb-5">Our Professional <span class="text-uppercase text-primary bg-light px-2">Designers</span>--%>
<%--            </h1>--%>
<%--            <div class="row g-4">--%>
<%--                <div class="col-md-6 col-lg-3 wow fadeIn" data-wow-delay="0.1s">--%>
<%--                    <div class="team-item position-relative overflow-hidden">--%>
<%--                        <img class="img-fluid w-100" src="img/team-1.jpg" alt="">--%>
<%--                        <div class="team-overlay">--%>
<%--                            <small class="mb-2">Architect</small>--%>
<%--                            <h4 class="lh-base text-light">Boris Johnson</h4>--%>
<%--                            <div class="d-flex justify-content-center">--%>
<%--                                <a class="btn btn-outline-primary btn-sm-square border-2 me-2" href="#!">--%>
<%--                                    <i class="fab fa-facebook-f"></i>--%>
<%--                                </a>--%>
<%--                                <a class="btn btn-outline-primary btn-sm-square border-2 me-2" href="#!">--%>
<%--                                    <i class="fab fa-twitter"></i>--%>
<%--                                </a>--%>
<%--                                <a class="btn btn-outline-primary btn-sm-square border-2 me-2" href="#!">--%>
<%--                                    <i class="fab fa-instagram"></i>--%>
<%--                                </a>--%>
<%--                                <a class="btn btn-outline-primary btn-sm-square border-2 me-2" href="#!">--%>
<%--                                    <i class="fab fa-linkedin-in"></i>--%>
<%--                                </a>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--                <div class="col-md-6 col-lg-3 wow fadeIn" data-wow-delay="0.3s">--%>
<%--                    <div class="team-item position-relative overflow-hidden">--%>
<%--                        <img class="img-fluid w-100" src="img/team-2.jpg" alt="">--%>
<%--                        <div class="team-overlay">--%>
<%--                            <small class="mb-2">Architect</small>--%>
<%--                            <h4 class="lh-base text-light">Donald Pakura</h4>--%>
<%--                            <div class="d-flex justify-content-center">--%>
<%--                                <a class="btn btn-outline-primary btn-sm-square border-2 me-2" href="#!">--%>
<%--                                    <i class="fab fa-facebook-f"></i>--%>
<%--                                </a>--%>
<%--                                <a class="btn btn-outline-primary btn-sm-square border-2 me-2" href="#!">--%>
<%--                                    <i class="fab fa-twitter"></i>--%>
<%--                                </a>--%>
<%--                                <a class="btn btn-outline-primary btn-sm-square border-2 me-2" href="#!">--%>
<%--                                    <i class="fab fa-instagram"></i>--%>
<%--                                </a>--%>
<%--                                <a class="btn btn-outline-primary btn-sm-square border-2 me-2" href="#!">--%>
<%--                                    <i class="fab fa-linkedin-in"></i>--%>
<%--                                </a>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--                <div class="col-md-6 col-lg-3 wow fadeIn" data-wow-delay="0.5s">--%>
<%--                    <div class="team-item position-relative overflow-hidden">--%>
<%--                        <img class="img-fluid w-100" src="img/team-3.jpg" alt="">--%>
<%--                        <div class="team-overlay">--%>
<%--                            <small class="mb-2">Architect</small>--%>
<%--                            <h4 class="lh-base text-light">Bradley Gordon</h4>--%>
<%--                            <div class="d-flex justify-content-center">--%>
<%--                                <a class="btn btn-outline-primary btn-sm-square border-2 me-2" href="#!">--%>
<%--                                    <i class="fab fa-facebook-f"></i>--%>
<%--                                </a>--%>
<%--                                <a class="btn btn-outline-primary btn-sm-square border-2 me-2" href="#!">--%>
<%--                                    <i class="fab fa-twitter"></i>--%>
<%--                                </a>--%>
<%--                                <a class="btn btn-outline-primary btn-sm-square border-2 me-2" href="#!">--%>
<%--                                    <i class="fab fa-instagram"></i>--%>
<%--                                </a>--%>
<%--                                <a class="btn btn-outline-primary btn-sm-square border-2 me-2" href="#!">--%>
<%--                                    <i class="fab fa-linkedin-in"></i>--%>
<%--                                </a>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--                <div class="col-md-6 col-lg-3 wow fadeIn" data-wow-delay="0.7s">--%>
<%--                    <div class="team-item position-relative overflow-hidden">--%>
<%--                        <img class="img-fluid w-100" src="img/team-4.jpg" alt="">--%>
<%--                        <div class="team-overlay">--%>
<%--                            <small class="mb-2">Architect</small>--%>
<%--                            <h4 class="lh-base text-light">Alexander Bell</h4>--%>
<%--                            <div class="d-flex justify-content-center">--%>
<%--                                <a class="btn btn-outline-primary btn-sm-square border-2 me-2" href="#!">--%>
<%--                                    <i class="fab fa-facebook-f"></i>--%>
<%--                                </a>--%>
<%--                                <a class="btn btn-outline-primary btn-sm-square border-2 me-2" href="#!">--%>
<%--                                    <i class="fab fa-twitter"></i>--%>
<%--                                </a>--%>
<%--                                <a class="btn btn-outline-primary btn-sm-square border-2 me-2" href="#!">--%>
<%--                                    <i class="fab fa-instagram"></i>--%>
<%--                                </a>--%>
<%--                                <a class="btn btn-outline-primary btn-sm-square border-2 me-2" href="#!">--%>
<%--                                    <i class="fab fa-linkedin-in"></i>--%>
<%--                                </a>--%>
<%--                            </div>--%>
<%--                        </div>--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--    <!-- Team End -->--%>



<!-- Newsletter Start -->
<div class="container-fluid bg-primary newsletter p-0">
    <div class="container p-0">
        <div class="row g-0 align-items-center">
            <div class="col-md-5 ps-lg-0 text-start wow fadeIn" data-wow-delay="0.2s">
                <img class="img-fluid w-100" src="img/newsletter.jpg" alt="">
            </div>
            <div class="col-md-7 py-5 newsletter-text wow fadeIn" data-wow-delay="0.5s">
                <div class="p-5">
                    <h1 class="mb-5">Subscribe the <span
                            class="text-uppercase text-primary bg-white px-2">Newsletter</span></h1>
                    <div class="position-relative w-100 mb-2">
                        <input class="form-control border-0 w-100 ps-4 pe-5" type="text"
                               placeholder="Enter Your Email" style="height: 60px;">
                        <button type="button" class="btn shadow-none position-absolute top-0 end-0 mt-2 me-2"><i
                                class="fa fa-paper-plane text-primary fs-4"></i></button>
                    </div>
                    <p class="mb-0">Diam sed sed dolor stet amet eirmod</p>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Newsletter End -->


<!-- Footer Start -->
<%@ include file="footer.jsp" %>
<!-- Footer End -->


<!-- Back to Top -->
<a href="#!" class="btn btn-lg btn-primary btn-lg-square back-to-top"><i class="bi bi-arrow-up"></i></a>


<!-- JavaScript Libraries -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="lib/wow/wow.min.js"></script>
<script src="lib/easing/easing.min.js"></script>
<script src="lib/waypoints/waypoints.min.js"></script>
<script src="lib/owlcarousel/owl.carousel.min.js"></script>

<!-- Template Javascript -->
<script src="js/main.js"></script>
</body>

</html>

