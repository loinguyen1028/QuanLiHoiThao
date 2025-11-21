<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập hệ thống</title>

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
          crossorigin="anonymous">

    <!-- Font Awesome (icon) -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"
          integrity="sha512-yH8huQwYyC1ZQTnKpD8+L+0s+0B2b2tN8u5+fZC9S0dflHhd5WgQ9QkR84t1zv4U6oQeQ3zYsjFvFZC3j6I5g=="
          crossorigin="anonymous" referrerpolicy="no-referrer" />

    <style>
        :root {
            --primary: #4e73df;
            --primary-light: #e3ecff;
        }

        body {
            min-height: 100vh;
            margin: 0;
            font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background:
                    radial-gradient(circle at top left, rgba(78,115,223,0.25), transparent 55%),
                    radial-gradient(circle at bottom right, rgba(28,200,138,0.2), transparent 55%),
                    #f8f9fc;
        }

        .auth-wrapper {
            min-height: 100vh;
        }

        .auth-card {
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 18px 45px rgba(0,0,0,0.08);
            border: none;
        }

        .auth-card-left {
            background: linear-gradient(135deg, #4e73df, #1cc88a);
            color: #fff;
        }

        .brand-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 56px;
            height: 56px;
            border-radius: 18px;
            background: rgba(255,255,255,0.15);
            margin-bottom: 1rem;
            font-size: 26px;
        }

        .auth-card-right {
            padding: 2.2rem 2.5rem;
        }

        .form-label {
            font-weight: 600;
            font-size: 0.9rem;
        }

        .form-control {
            border-radius: 12px;
        }

        .btn-primary {
            border-radius: 999px;
            font-weight: 600;
            letter-spacing: .03em;
            padding: 0.6rem 1rem;
        }

        .small-link {
            font-size: 0.85rem;
        }

        .alert {
            border-radius: 12px;
        }

        @media (max-width: 767.98px) {
            .auth-card-right {
                padding: 1.6rem 1.4rem;
            }
            .brand-badge {
                width: 48px;
                height: 48px;
                font-size: 22px;
            }
        }
    </style>
</head>
<body>
<%
    String err = (String) request.getAttribute("err");
    String username = request.getParameter("username") != null ? request.getParameter("username") : "";
%>

<div class="container auth-wrapper d-flex align-items-center justify-content-center">
    <div class="row w-100 justify-content-center">
        <div class="col-xl-6 col-lg-7 col-md-9">
            <div class="card auth-card">
                <div class="row g-0">
                    <!-- Khối trái: giới thiệu / thương hiệu -->
                    <div class="col-md-5 d-none d-md-flex flex-column justify-content-between auth-card-left p-4">
                        <div>
                            <div class="brand-badge">
                                <i class="fas fa-user-shield"></i>
                            </div>
                            <h4 class="fw-bold mb-2">LHQ Seminar Admin</h4>
                            <p class="mb-0 text-white-50 small">
                                Hệ thống quản lý hội thảo nội bộ. Vui lòng đăng nhập bằng tài khoản được cấp.
                            </p>
                        </div>
                        <div class="small text-white-50">
                            &copy; <%= java.time.Year.now() %> LHQ Seminar<br/>
                            <span class="opacity-75">Phiên bản quản trị viên</span>
                        </div>
                    </div>

                    <!-- Khối phải: form đăng nhập -->
                    <div class="col-md-7 bg-white">
                        <div class="auth-card-right">
                            <div class="mb-3 text-center d-md-none">
                                <div class="brand-badge">
                                    <i class="fas fa-chalkboard-teacher"></i>
                                </div>
                            </div>

                            <h5 class="fw-bold mb-1 text-center">Đăng nhập hệ thống</h5>
                            <p class="text-muted small text-center mb-4">
                                Nhập tên đăng nhập và mật khẩu để tiếp tục.
                            </p>

                            <% if(err != null){ %>
                            <div class="alert alert-danger d-flex align-items-center" role="alert">
                                <i class="fas fa-circle-exclamation me-2"></i>
                                <div><%= err %></div>
                            </div>
                            <% } %>

                            <form action="<%= request.getContextPath()%>/login" method="POST" novalidate>
                                <div class="mb-3">
                                    <label for="usernameInput" class="form-label">Tên đăng nhập</label>
                                    <input type="text"
                                           class="form-control"
                                           id="usernameInput"
                                           placeholder="Nhập username"
                                           name="username"
                                           value="<%= username %>">
                                </div>
                                <div class="mb-3">
                                    <label for="passwordInput" class="form-label">Mật khẩu</label>
                                    <input type="password"
                                           class="form-control"
                                           id="passwordInput"
                                           placeholder="Nhập mật khẩu"
                                           name="password">
                                </div>
                                <div class="mb-3 d-flex justify-content-between align-items-center">
                                    <div class="form-check">
                                        <input type="checkbox"
                                               class="form-check-input"
                                               id="rememberCheck"
                                               name="remember"
                                               value="Remember Me">
                                        <label class="form-check-label small" for="rememberCheck">
                                            Ghi nhớ đăng nhập
                                        </label>
                                    </div>
                                    <!-- Nếu sau này có quên mật khẩu thì bỏ comment -->
                                    <%-- <a href="#" class="small-link text-decoration-none">Quên mật khẩu?</a> --%>
                                </div>
                                <button type="submit" class="btn btn-primary w-100">
                                    <i class="fas fa-right-to-bracket me-1"></i> Đăng nhập
                                </button>
                            </form>

                            <div class="text-center mt-4 small text-muted">
                                Được bảo vệ cho quản trị viên nội bộ. Nếu bạn cần cấp lại tài khoản,
                                vui lòng liên hệ quản trị hệ thống.
                            </div>
                        </div>
                    </div>
                </div> <!-- /row -->
            </div> <!-- /card -->
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
</body>
</html>
