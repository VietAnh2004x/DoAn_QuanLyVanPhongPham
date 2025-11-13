<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng ký - Văn Phòng Phẩm 3AE</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="<%= request.getContextPath() %>/assets/css/register-login.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>

        <div class="container auth-container">
            <div class="row justify-content-center">
                <div class="col-md-8 col-lg-6">
                    <div class="card shadow-sm">
                        <div class="card-body p-4 p-md-5">
                            <div class="text-center mb-4">
                                <h2 class="auth-title">Tạo Tài Khoản Mới</h2>
                                <p class="text-muted">Tham gia cùng chúng tôi ngay hôm nay!</p>
                            </div>

                            <form action="${pageContext.request.contextPath}/dang-ky" method="POST">
                                <%
                                    String message = (String) request.getAttribute("message");
                                    if (message != null) {
                                %>
                                <div class="alert alert-warning" role="alert">
                                    <%= message%>
                                </div>
                                <% }%>

                                <div class="mb-3">
                                    <label for="hoten" class="form-label">Họ và Tên</label>
                                    <input type="text" class="form-control" id="hoten" name="hoten" required placeholder="Nguyễn Văn A">
                                </div>

                                <div class="mb-3">
                                    <label for="email" class="form-label">Email</label>
                                    <input type="email" class="form-control" id="email" name="email" required placeholder="vidu@gmail.com">
                                </div>

                                <div class="mb-3">
                                    <label for="sodienthoai" class="form-label">Số điện thoại</label>
                                    <input type="tel" class="form-control" id="sodienthoai" name="sodienthoai" placeholder="09xxxxxxx">
                                </div>

                                <div class="mb-3">
                                    <label for="diachi" class="form-label">Địa chỉ</label>
                                    <input type="text" class="form-control" id="diachi" name="diachi" placeholder="Số nhà, đường, phường/xã...">
                                </div>

                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="matkhau" class="form-label">Mật khẩu</label>
                                        <input type="password" class="form-control" id="matkhau" name="matkhau" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="nhaplaimatkhau" class="form-label">Nhập lại mật khẩu</label>
                                        <input type="password" class="form-control" id="nhaplaimatkhau" name="nhaplaimatkhau" required>
                                    </div>
                                </div>

                                <div class="d-grid">
                                    <button type="submit" class="btn btn-primary btn-block">Đăng Ký</button>
                                </div>
                            </form>

                            <hr class="my-4">

                            <div class="text-center">
                                <p class="small">Đã có tài khoản? 
                                    <a href="${pageContext.request.contextPath}/view/dangnhap.jsp" class="text-decoration-none fw-bold">Đăng nhập ngay</a>
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