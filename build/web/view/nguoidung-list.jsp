<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
<title>Quản lý người dùng</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

<style>
    /* Thêm một số style nhỏ để trang đẹp hơn */
    body {
        background-color: #f8f9fa; /* Nền xám nhạt */
    }
</style>
</head>
<body class="bg-light">

<div class="container mt-5 mb-5">
    <div class="card shadow-sm border-0">
        
        <div class="card-header bg-primary text-white p-3">
            <h3 class="mb-0">
                <i class="fas fa-users me-2"></i> Quản lý người dùng
            </h3>
        </div>
        
        <div class="card-body p-4">
            
            <form action="nguoi-dung" method="get" class="mb-4">
                <div class="input-group">
                    <input type="text" name="keyword" class="form-control form-control-lg" 
                           placeholder="Tìm kiếm theo tên, email, hoặc số điện thoại..." 
                           value="${param.keyword}">
                    <button class="btn btn-primary btn-lg" type="submit">
                        <i class="fas fa-search me-1"></i> Tìm
                    </button>
                </div>
            </form>

            <div class="table-responsive">
                <table class="table table-bordered table-striped table-hover align-middle">
                    <thead class="table-light">
                        <tr class="text-uppercase">
                            <th>ID</th>
                            <th>Họ tên</th>
                            <th>Email</th>
                            <th>Điện thoại</th>
                            <th>Địa chỉ</th>
                            <th>Ngày đăng ký</th>
                            <th>Vai trò</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${empty list}">
                            <tr>
                                <td colspan="7" class="text-center text-muted p-4">
                                    Không tìm thấy người dùng nào phù hợp.
                                </td>
                            </tr>
                        </c:if>

                        <c:forEach var="u" items="${list}">
                            <tr>
                                <td>${u.nguoiDungId}</td>
                                <td>${u.hoTen}</td>
                                <td>${u.email}</td>
                                <td>${u.soDienThoai}</td>
                                <td>${u.diaChi}</td>
                                <td><fmt:formatDate value="${u.ngayDangKy}" pattern="dd/MM/yyyy"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${u.roleId == 1}">
                                            <span class="badge bg-danger p-2">
                                                <i class="fas fa-user-shield me-1"></i> Admin
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-success p-2">
                                                <i class="fas fa-user me-1"></i> Khách hàng
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            
        </div> </div> </div> <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>