<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <title>ESD 2025</title>
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
<%--<div class="container-fluid pb-5 bg-primary hero-header">--%>
<%--    <div class="container py-5">--%>
<%--        <div class="row g-3 align-items-center">--%>
<%--            <div class="col-lg-6 text-center text-lg-start">--%>
<%--                <h1 class="display-1 mb-0 animated slideInLeft">404 Error</h1>--%>
<%--            </div>--%>
<%--            <div class="col-lg-6 animated slideInRight">--%>
<%--                <nav aria-label="breadcrumb">--%>
<%--                    <ol class="breadcrumb justify-content-center justify-content-lg-end mb-0">--%>
<%--                        <li class="breadcrumb-item"><a class="text-primary" href="#!">Home</a></li>--%>
<%--                        <li class="breadcrumb-item"><a class="text-primary" href="#!">Pages</a></li>--%>
<%--                        <li class="breadcrumb-item text-secondary active" aria-current="page">404 Error</li>--%>
<%--                    </ol>--%>
<%--                </nav>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--</div>--%>
<!-- Hero End -->


<!-- 404 Start -->
<div class="container-fluid py-5 wow fadeIn" data-wow-delay="0.1s">
    <div class="container text-center py-5">
        <div class="row justify-content-center">
            <div class="col-lg-6">
                <i class="bi bi-check-circle-fill display-1 text-success"></i>
                <h1 class="display-1 text-success">SUCCESS</h1>
<%--                <h1 class="mb-4">ĐĂNG KÝ THÀNH CÔNG</h1>--%>
                <p class="mb-4">
                    Cảm ơn bạn đã đăng ký tham dự <strong>Hội thảo Môi Trường và Phát Triển Bền Vững (ESD 2025)</strong>.<br>
                    Chúng tôi sẽ liên hệ với bạn qua email trong thời gian sớm nhất.
                </p>
                <a class="btn btn-primary py-3 px-5" href="home.jsp">Quay lại trang chủ</a>
            </div>
        </div>
    </div>
</div>
<!-- 404 End -->


<!-- Newsletter Start -->
<%--<div class="container-fluid bg-primary newsletter p-0">--%>
<%--    <div class="container p-0">--%>
<%--        <div class="row g-0 align-items-center">--%>
<%--            <div class="col-md-5 ps-lg-0 text-start wow fadeIn" data-wow-delay="0.2s">--%>
<%--                <img class="img-fluid w-100" src="img/newsletter.jpg" alt="">--%>
<%--            </div>--%>
<%--            <div class="col-md-7 py-5 newsletter-text wow fadeIn" data-wow-delay="0.5s">--%>
<%--                <div class="p-5">--%>
<%--                    <h1 class="mb-5">Subscribe the <span--%>
<%--                            class="text-uppercase text-primary bg-white px-2">Newsletter</span></h1>--%>
<%--                    <div class="position-relative w-100 mb-2">--%>
<%--                        <input class="form-control border-0 w-100 ps-4 pe-5" type="text"--%>
<%--                               placeholder="Enter Your Email" style="height: 60px;">--%>
<%--                        <button type="button" class="btn shadow-none position-absolute top-0 end-0 mt-2 me-2"><i--%>
<%--                                class="fa fa-paper-plane text-primary fs-4"></i></button>--%>
<%--                    </div>--%>
<%--                    <p class="mb-0">Diam sed sed dolor stet amet eirmod</p>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--</div>--%>
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