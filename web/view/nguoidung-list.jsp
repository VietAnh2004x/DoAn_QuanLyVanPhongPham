<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html>
    <head>
        <title>Quản lý người dùng</title>

        <!-- Bootstrap -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">

        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

        <style>
            body {
                background: #f3f4f6;
                font-family: "Inter", sans-serif;
            }

            /* MAIN CONTENT (lệch sidebar) */
            .main-content {
                margin-left: 250px;
                padding: 2rem;
            }

            /* TITLE */
            .page-title {
                font-size: 26px;
                font-weight: 700;
                color: #2563eb;
            }

            /* SEARCH BOX */
            .search-box {
                background: white;
                padding: 20px;
                border-radius: 16px;
                border: 1px solid #e5e7eb;
                box-shadow: 0 5px 20px rgba(0,0,0,0.05);
                margin-bottom: 20px;
            }

            .search-box input {
                border-radius: 10px;
                border: 1px solid #cbd5e1;
            }

            .search-box button {
                border-radius: 10px;
                background: #2563eb;
                border: none;
                padding: 12px 20px;
                font-weight: 600;
                color: white;
            }
            .search-box button:hover {
                background: #1d4ed8;
            }

            /* TABLE */
            table thead {
                background: #2563eb;
                color: white;
            }
            table tbody tr:hover {
                background: #eff6ff;
            }

            /* BADGES */
            .badge-admin {
                background: #fee2e2;
                color: #b91c1c;
                padding: 8px 14px;
                border-radius: 12px;
                font-weight: 600;
            }
            .badge-user {
                background: #dcfce7;
                color: #16a34a;
                padding: 8px 14px;
                border-radius: 12px;
                font-weight: 600;
            }

            /* SECTION WRAPPER */
            .section-wrapper {
                background: white;
                border-radius: 16px;
                padding: 22px 26px;
                border: 1px solid #e5e7eb;
                box-shadow: 0 8px 18px rgba(0,0,0,0.05);
            }

        </style>
    </head>

    <body>

        <!-- 🌟 GỌI ADMIN LAYOUT -->
        <jsp:include page="/view/admin-layout.jsp"/>

        <!-- 🌟 MAIN CONTENT -->
        <div class="main-content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="page-title m-0">
                    <i class="fas fa-receipt me-2"></i> Danh sách đơn hàng
                </h2>  

                <a href="${pageContext.request.contextPath}/export-excel?type=user" 
                   class="btn btn-success fw-bold px-3 py-2"
                   style="border-radius: 10px;">
                    <i class="fa fa-file-excel-o me-1"></i> Xuất Excel
                </a>
            </div>


            <!-- SEARCH -->
            <form action="nguoi-dung" method="get" class="search-box">
                <div class="input-group">
                    <input type="text" name="keyword" class="form-control form-control-lg"
                           placeholder="Tìm theo tên, email, SĐT..."
                           value="${param.keyword}">

                    <button type="submit">
                        <i class="fas fa-search me-1"></i> Tìm
                    </button>
                </div>
            </form>

            <!-- USER TABLE -->
            <div class="section-wrapper">
                <div class="table-responsive">
                    <table class="table table-bordered table-hover align-middle">
                        <thead>
                            <tr class="text-center text-uppercase">
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
                                        Không tìm thấy người dùng nào.
                                    </td>
                                </tr>
                            </c:if>

                            <c:forEach var="u" items="${list}">
                                <tr>
                                    <td class="text-center fw-bold">${u.nguoiDungId}</td>
                                    <td>${u.hoTen}</td>
                                    <td>${u.email}</td>
                                    <td>${u.soDienThoai}</td>
                                    <td>${u.diaChi}</td>
                                    <td class="text-center">
                                        <fmt:formatDate value="${u.ngayDangKy}" pattern="dd/MM/yyyy"/>
                                    </td>

                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${u.roleId == 1}">
                                                <span class="badge-admin">
                                                    <i class="fas fa-user-shield me-1"></i> Admin
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-user">
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
            </div>
        </div>
    </body>
</html>
