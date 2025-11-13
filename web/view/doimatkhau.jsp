<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- Dùng JSTL URI cũ cho khớp với project của bạn --%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Đổi mật khẩu - VPP 3AE</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    </head>
    <body>

        <%-- Tải Header (dùng đường dẫn tương đối từ 'view/') --%>
        <jsp:include page="_header.jsp" /> 

        <div class="container my-5" style="min-height: 60vh;">
            <div class="row">
                <div class="col-md-6 offset-md-3">
                    <h2 class="text-center mb-4 text-primary fw-bold">Đổi Mật Khẩu</h2>
                    
                    <c:if test="${sessionScope.authUser != null}">
                        <div class="card shadow-sm">
                            <div class="card-body p-4 p-md-5">
                                
                                <form action="${pageContext.request.contextPath}/doi-mat-khau" method="POST">
                                    
                                    <%-- Hiển thị thông báo (nếu có) --%>
                                    <c:if test="${not empty successMessage}">
                                        <div class="alert alert-success" role="alert">
                                            ${successMessage}
                                        </div>
                                    </c:if>
                                    <c:if test="${not empty errorMessage}">
                                        <div class="alert alert-danger" role="alert">
                                            ${errorMessage}
                                        </div>
                                    </c:if>

                                    <div class="mb-3">
                                        <label for="matkhaucu" class="form-label fw-bold">Mật khẩu cũ</label>
                                        <input type="password" class="form-control" id="matkhaucu" name="matkhaucu" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="matkhaumoi" class="form-label fw-bold">Mật khẩu mới</label>
                                        <input type="password" class="form-control" id="matkhaumoi" name="matkhaumoi" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="xacnhanmatkhau" class="form-label fw-bold">Xác nhận mật khẩu mới</label>
                                        <input type="password" class="form-control" id="xacnhanmatkhau" name="xacnhanmatkhau" required>
                                    </div>
                                    
                                    <div class="text-center mt-4">
                                        <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                                    </div>
                                </form>
                                
                            </div>
                        </div>
                    </c:if>

                    <c:if test="${sessionScope.authUser == null}">
                         <div class="alert alert-danger" role="alert">
                             Bạn cần <a href="${pageContext.request.contextPath}/view/dangnhap.jsp">đăng nhập</a> để xem thông tin này.
                         </div>
                    </c:if>
                </div>
            </div>
        </div>

        <%-- Tải Footer (dùng đường dẫn tương đối từ 'view/') --%>
        <jsp:include page="_footer.jsp" />

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>