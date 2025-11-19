<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <style>
        /* Tạo background đơn giản, hiện đại */
        body {
            background-color: #f8f9fa; /* Màu nền nhẹ */
        }
        .login-card {
            margin-top: 10vh; /* Đẩy form xuống giữa trang */
            box-shadow: 0 4px 8px rgba(0,0,0,0.1); /* Thêm đổ bóng nhẹ */
        }
    </style>
</head>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-lg-4 col-md-6">
            <div class="card login-card">
                <div class="card-header bg-primary text-white text-center">
                    <h3 class="card-title mb-0">Please Sign In</h3>
                </div>
                <div class="card-body">
                    <%
                        // Lỗi được truyền qua request attribute [cite: 37, 38]
                        String err = (String) request.getAttribute("err");
                        if(err != null){
                    %>
                    <div class="alert alert-danger" role="alert"><%=err%></div>
                    <%
                        }
                    %>
                    <form action="<%= request.getContextPath()%>/login" method="POST">
                        <div class="mb-3">
                            <label for="usernameInput" class="form-label">Username</label>
                            <input type="text" class="form-control" id="usernameInput" placeholder="Enter username" name="username">
                        </div>
                        <div class="mb-3">
                            <label for="passwordInput" class="form-label">Password</label>
                            <input type="password" class="form-control" id="passwordInput" placeholder="Password" name="password">
                        </div>
                        <div class="mb-3 form-check">
                            <input type="checkbox" class="form-check-input" id="rememberCheck" name="remember" value="Remember Me">
                            <label class="form-check-label" for="rememberCheck">Remember Me</label>
                        </div>
                        <button type="submit" class="btn btn-primary w-100">Login</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>