<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="utf-8">
    <title>Giới thiệu - LHQ-SEMINAR</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">

    <link href="img/favicon.ico" rel="icon">

    <!-- Google Web Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans&family=Space+Grotesk&display=swap" rel="stylesheet">

    <!-- Icon Font Stylesheet -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Libraries Stylesheet -->
    <link href="lib/animate/animate.min.css" rel="stylesheet>
    <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">

    <!-- Bootstrap -->
    <link href="css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom -->
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
<!-- Banner -->
<div class="container-fluid bg-dark text-light py-5 mb-5">
    <div class="container text-center py-5">
        <h1 class="display-3 text-light animated fadeInDown">Về chúng tôi</h1>
        <p class="lead mt-3 animated fadeInUp">
            LHQ SEMINAR – Kết nối tri thức, chia sẻ giá trị, thúc đẩy đổi mới sáng tạo.
        </p>
    </div>
</div>

<!-- Nội dung chính -->
<div class="container py-5">
    <!-- 1. Giới thiệu -->
    <div class="row g-5 mb-5">
        <div class="col-lg-6">
            <img src="img/logo10.png" class="img-fluid rounded shadow" alt="About Image">
        </div>
        <div class="col-lg-6">
            <h2 class="mb-4 text-primary text-uppercase">LHQ-SEMINAR</h2>
            <p style="text-align:justify;">
                <strong>LHQ-SEMINAR</strong> là nền tảng quản lý và tổ chức hội thảo chuyên nghiệp
                dành cho doanh nghiệp, trường đại học, tổ chức nghiên cứu và cộng đồng công nghệ Việt Nam.
                Với sứ mệnh kết nối những cá nhân đam mê tri thức, chúng tôi tạo ra môi trường học tập,
                trao đổi chuyên môn và xây dựng mạng lưới chuyên gia chất lượng.
            </p>
            <p style="text-align:justify;">
                Chúng tôi không chỉ đem đến các hội thảo đa dạng về khoa học, công nghệ, kinh tế, môi trường…
                mà còn hỗ trợ quy trình quản lý, đăng ký tham gia, thống kê, báo cáo và truyền thông sự kiện.
            </p>
        </div>
    </div>

    <!-- 2. Tầm nhìn – Sứ mệnh – Giá trị -->
    <div class="row g-4 text-center mb-5">
        <h2 class="text-center mb-4 text-primary">Tầm Nhìn – Sứ Mệnh – Giá Trị Cốt Lõi</h2>

        <div class="col-md-4">
            <div class="p-4 border rounded shadow-sm h-100">
                <i class="bi bi-eye text-primary display-5"></i>
                <h4 class="mt-3">Tầm nhìn</h4>
                <p>Trở thành nền tảng hội thảo trực tuyến hàng đầu tại Việt Nam, kết nối tri thức cho cộng đồng.</p>
            </div>
        </div>

        <div class="col-md-4">
            <div class="p-4 border rounded shadow-sm h-100">
                <i class="bi bi-bullseye text-primary display-5"></i>
                <h4 class="mt-3">Sứ mệnh</h4>
                <p>Thúc đẩy học tập, nghiên cứu và chia sẻ giá trị thông qua các hội thảo chất lượng.</p>
            </div>
        </div>

        <div class="col-md-4">
            <div class="p-4 border rounded shadow-sm h-100">
                <i class="bi bi-heart text-primary display-5"></i>
                <h4 class="mt-3">Giá trị cốt lõi</h4>
                <p>Sáng tạo – Chuyên nghiệp – Kết nối – Phát triển bền vững.</p>
            </div>
        </div>
    </div>

    <!-- 3. Đội ngũ -->
    <h2 class="text-center text-primary mb-4">Đội Ngũ Phát Triển</h2>
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

<%@ include file="footer.jsp" %>

<a href="#!" class="btn btn-lg btn-primary btn-lg-square back-to-top"><i class="bi bi-arrow-up"></i></a>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="lib/wow/wow.min.js"></script>
<script src="js/main.js"></script>

</body>
</html>
