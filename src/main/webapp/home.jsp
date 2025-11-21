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
    DataSource dsHome = DataSourceUtil.getDataSource();
    SeminarService seminarServiceHome = new SeminarServiceImpl(dsHome);

    String pageParam = request.getParameter("page");
    int currentPageIndex = 1;
    try {
        if (pageParam != null) {
            currentPageIndex = Integer.parseInt(pageParam);
        }
    } catch (NumberFormatException e) {
        currentPageIndex = 1;
    }

    int pageSize = 6;

    PageRequest prHome = new PageRequest(currentPageIndex, pageSize, "start_date", "desc", "");
    Page<Seminar> pageHome = seminarServiceHome.findAll(prHome);

    List<Seminar> latestSeminars = java.util.Collections.emptyList();
    int currentPage = 1;
    int totalPages = 0;

    if (pageHome != null) {
        if (pageHome.getData() != null) {
            latestSeminars = pageHome.getData();
        }
        currentPage = pageHome.getCurrentPage();
        totalPages = pageHome.getTotalPage();
    }
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
            color: #009966;
            transition: color 0.3s ease;
        }
        /* Khung ảnh đồng nhất */
        .testimonial-item .seminar-thumb {
            width: 100%;
            height: 180px;             /* chỉnh tùy ý: 150px, 200px */
            object-fit: cover;         /* không méo hình, auto crop */
            border-radius: 10px;
            transition: transform 0.4s ease, filter 0.4s ease;
        }

        /* Hiệu ứng hover (chỉ phóng nhẹ, không làm vỡ layout) */
        .testimonial-item:hover .seminar-thumb {
            transform: scale(1.03);
            filter: brightness(1.1);
        }
        .testimonial-item:hover {
            box-shadow: 0px 5px 18px rgba(0,0,0,0.13);
            background: #fff;
        }
        /* ===== Ảnh đồng nhất ===== */
        .testimonial-item .seminar-thumb {
            width: 100%;
            height: 180px;              /* bạn có thể chỉnh: 150/200/... */
            object-fit: cover;          /* không méo hình, crop đẹp */
            border-radius: 10px;
            transition: all 0.3s ease;
        }

        /* ===== CARD BÌNH THƯỜNG GIỐNG MÀU NỀN ===== */
        .testimonial-item {
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 15px;
            border-radius: 12px;
            background: transparent; /* CHỈNH TẠI ĐÂY */
            transition: all 0.35s ease;
            border: 1px solid rgba(0,0,0,0.03); /* giúp cân bằng bố cục nhẹ */
        }


        /* đảm bảo card không bị lệch giữa các col */
        .col-lg-6 > .testimonial-item {
            height: 100%;
        }

        /* ===== HIỆU ỨNG HOVER VẪN GIỮ ===== */
        .testimonial-item:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 28px rgba(0, 0, 0, 0.15);
            background: #ffffff;
        }

        /* Ảnh cũng có hiệu ứng nhưng không làm nhảy layout */
        .testimonial-item:hover .seminar-thumb {
            transform: scale(1.05);
            filter: brightness(1.08);
        }

        /* Tiêu đề đổi màu khi hover */
        .testimonial-item:hover h3 a {
            color: #009966;
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

<!-- Hội thảo-->
<div class="container-fluid py-5 bg-light" id="testimonial-section">
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
            %>

            <%  // Mỗi seminar là 1 col-lg-6, Bootstrap tự chia 2 cột / nhiều hàng
                for (Seminar s : latestSeminars) {
                    String img = (s.getImage() == null || s.getImage().isBlank())
                            ? "img/test1.png"
                            : s.getImage();

                    String rawDesc = s.getDescription() != null ? s.getDescription() : "";

                    // 1. Loại bỏ toàn bộ thẻ HTML (bao gồm <img>, <p>, <b>...) dùng Regex
                    String cleanDesc = rawDesc.replaceAll("\\<.*?\\>", "");

                    // 2. Giải mã ký tự đặc biệt nếu cần (ví dụ &nbsp; thành khoảng trắng)
                    // (Bước này tùy chọn, nhưng nên làm nếu text dính nhau)
                    cleanDesc = cleanDesc.replace("&nbsp;", " ");

                    // 3. Cắt chuỗi an toàn trên văn bản thuần
                    String descToDisplay = "";
                    if (cleanDesc.length() > 60) {
                        descToDisplay = cleanDesc.substring(0, 50) + "...";
                    } else {
                        descToDisplay = cleanDesc;
                    }
            %>

            <div class="col-lg-6">
                <div class="testimonial-item mb-5">
                    <div class="row g-4 align-items-stretch">

                    <div class="col-6">
                            <a href="<%= ctx %>/seminar_detail_user?id=<%= s.getId() %>">
                                <img class="img-fluid seminar-thumb" src="<%= img %>" alt="">
                            </a>
                        </div>
                        <div class="col-6">
                            <h3>
                                <a href="<%= ctx %>/seminar_detail_user?id=<%= s.getId() %>"
                                   style="text-decoration:none; color:#000;">
                                    <%= s.getName() %>
                                </a>
                            </h3>

                            <p><%= descToDisplay %></p>

                            <h5 class="mb-0">
                                <i class="bi bi-person-circle"></i>
                                <%= (s.getSpeaker() != null && !s.getSpeaker().isBlank())
                                        ? s.getSpeaker()
                                        : "Đang cập nhật" %>
                            </h5>
                        </div>
                    </div>
                </div>
            </div>

            <% } // end for %>

            <!-- PHÂN TRANG -->
            <%
                if (totalPages > 1) {
            %>
            <div class="col-12">
                <nav aria-label="Seminar pagination">
                    <ul class="pagination justify-content-center">

                        <!-- Previous -->
                        <li class="page-item <%= (currentPage <= 1 ? "disabled" : "") %>">
                            <a class="page-link"
                               href="<%= ctx %>/home.jsp?page=<%= (currentPage - 1) %>#testimonial-section">
                                <i class="bi bi-chevron-left"></i>
                            </a>
                        </li>

                        <!-- Page numbers -->
                        <%
                            for (int i = 1; i <= totalPages; i++) {
                        %>
                        <li class="page-item <%= (i == currentPage ? "active" : "") %>">
                            <a class="page-link"
                               href="<%= ctx %>/home.jsp?page=<%= i %>#testimonial-section"><%= i %></a>
                        </li>
                        <%
                            }
                        %>

                        <!-- Next -->
                        <li class="page-item <%= (currentPage >= totalPages ? "disabled" : "") %>">
                            <a class="page-link"
                               href="<%= ctx %>/home.jsp?page=<%= (currentPage + 1) %>#testimonial-section">
                                <i class="bi bi-chevron-right"></i>
                            </a>
                        </li>


                    </ul>
                </nav>
            </div>
            <%
                } // end if totalPages > 1
            %>

            <% } // end else có dữ liệu %>

        </div>
    </div>
</div>
<!-- Hội thảo -->

<!-- Team Start -->
<div class="container-fluid py-5">
    <div class="container py-5">
        <h1 class="mb-5"><span class="text-uppercase text-primary bg-light px-2">Founder</span>
        </h1>
        <div class="row g-4">

            <div class="col-md-4">
                <div class="team-item position-relative overflow-hidden">
                    <img class="img-fluid w-100" src="img/a5.png" alt="">
                    <div class="team-overlay">
                        <small>Function</small>
                        <h4 class="text-light">Huy Hoang</h4>
                        <div class="d-flex justify-content-center">
                            <a class="btn btn-outline-primary btn-sm-square border-2 me-2" href="#!">
                                <i class="fab fa-facebook-f"></i>
                            </a>
                            <a class="btn btn-outline-primary btn-sm-square border-2 me-2" href="#!">
                                <i class="fab fa-twitter"></i>
                            </a>
                            <a class="btn btn-outline-primary btn-sm-square border-2 me-2" href="#!">
                                <i class="fab fa-instagram"></i>
                            </a>
                            <a class="btn btn-outline-primary btn-sm-square border-2 me-2" href="#!">
                                <i class="fab fa-linkedin-in"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="team-item position-relative overflow-hidden">
                    <img class="img-fluid w-100" src="img/a2.png" alt="">
                    <div class="team-overlay">
                        <small>Front-End</small>
                        <h4 class="text-light">Phuoc Loi</h4>
                        <div class="d-flex justify-content-center">
                            <a class="btn btn-outline-primary btn-sm-square border-2 me-2" href="#!">
                                <i class="fab fa-facebook-f"></i>
                            </a>
                            <a class="btn btn-outline-primary btn-sm-square border-2 me-2" href="#!">
                                <i class="fab fa-twitter"></i>
                            </a>
                            <a class="btn btn-outline-primary btn-sm-square border-2 me-2" href="#!">
                                <i class="fab fa-instagram"></i>
                            </a>
                            <a class="btn btn-outline-primary btn-sm-square border-2 me-2" href="#!">
                                <i class="fab fa-linkedin-in"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="team-item position-relative overflow-hidden">
                    <img class="img-fluid w-100" src="img/a3.png" alt="">
                    <div class="team-overlay">
                        <small>Back-End</small>
                        <h4 class="text-light">Duc Quy</h4>
                        <div class="d-flex justify-content-center">
                            <a class="btn btn-outline-primary btn-sm-square border-2 me-2" href="#!">
                                <i class="fab fa-facebook-f"></i>
                            </a>
                            <a class="btn btn-outline-primary btn-sm-square border-2 me-2" href="#!">
                                <i class="fab fa-twitter"></i>
                            </a>
                            <a class="btn btn-outline-primary btn-sm-square border-2 me-2" href="#!">
                                <i class="fab fa-instagram"></i>
                            </a>
                            <a class="btn btn-outline-primary btn-sm-square border-2 me-2" href="#!">
                                <i class="fab fa-linkedin-in"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>
<!-- Team End -->




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
