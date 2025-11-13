<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng nhập - Văn Phòng Phẩm 3AE</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="<%= request.getContextPath() %>/assets/css/register-login.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>

        <div class="container auth-container">
            <div class="row justify-content-center">
                <div class="col-md-6 col-lg-5">
                    <div class="card shadow-sm">
                        <div class="card-body p-4 p-md-5">
                            <div class="text-center mb-4">
                                <h2 class="auth-title">Đăng Nhập</h2>
                                <p class="text-muted">Chào mừng trở lại!</p>
                            </div>

                            <form action="${pageContext.request.contextPath}/dang-nhap" method="POST">
                                <%
                                    String error = (String) request.getAttribute("error");
                                    if (error != null) {
                                %>
                                <div class="alert alert-danger" role="alert">
                                    <%= error%>
                                </div>
                                <% }%>

                                <div class="mb-3">
                                    <label for="email" class="form-label">Email</label>
                                    <input type="email" class="form-control" id="email" name="email" required placeholder="vidu@gmail.com">
                                </div>
                                <div class="mb-3">
                                    <label for="matkhau" class="form-label">Mật khẩu</label>
                                    <input type="password" class="form-control" id="matkhau" name="matkhau" required>
                                </div>
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" value="" id="rememberMe">
                                        <label class="form-check-label" for="rememberMe">
                                            Nhớ tôi
                                        </label>
                                    </div>
                                    <a href="#" class="small text-decoration-none" onclick="alert('Hãy liên hệ admin: 0123456789 để lấy lại mật khẩu'); return false;">Quên mật khẩu?</a>
                                </div>
                                <div class="d-grid">
                                    <button type="submit" class="btn btn-primary btn-block">Đăng Nhập</button>
                                </div>
                            </form>

                            <hr class="my-4">

                            <div class="text-center">
                                <p class="small">Chưa có tài khoản? 
                                    <a href="${pageContext.request.contextPath}/view/dangky.jsp" class="text-decoration-none fw-bold">Đăng ký ngay</a>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>