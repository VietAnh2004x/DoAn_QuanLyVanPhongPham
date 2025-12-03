<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>Quản lý đánh giá sản phẩm</title>

    <!-- Bootstrap -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">

    <!-- Font Awesome -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <style>
        body {
            background: #f4f6f9;
            font-family: "Inter", sans-serif;
            color: #1f2937;
        }

        .main-content {
            margin-left: 250px;
            padding: 32px;
        }

        .page-title {
            font-size: 28px;
            font-weight: 700;
            color: #2563eb;
        }

        /* ===== MINI FILTER ===== */
        .mini-filter {
            background: #ffffff;
            border-radius: 14px;
            padding: 14px 16px;
            box-shadow: 0 8px 18px rgba(0,0,0,0.06);
        }

        .mini-filter label {
            font-size: 0.85rem;
            font-weight: 600;
            margin-bottom: 4px;
        }

        .mini-filter .form-control,
        .mini-filter .form-select {
            height: 38px;
            font-size: 0.9rem;
        }

        .mini-filter button {
            height: 38px;
            font-size: 0.9rem;
            border-radius: 999px;
        }

        /* ===== TABLE ===== */
        .table-card {
            background: #ffffff;
            border-radius: 18px;
            padding: 24px;
            box-shadow: 0 12px 30px rgba(0,0,0,0.08);
        }

        table thead th {
            background: #f8fafc;
            color: #334155;
            font-weight: 600;
            text-align: center;
            border-bottom: 2px solid #e5e7eb;
        }

        table tbody tr:hover {
            background: #f1f5f9;
        }

        .star-filled { color: #facc15; }
        .star-empty { color: #d1d5db; }

        .review-date {
            font-size: .85rem;
            color: #6b7280;
            text-align: center;
        }

        .btn-delete {
            background: #fee2e2;
            color: #991b1b;
            border-radius: 999px;
            padding: 4px 14px;
            font-size: .8rem;
            border: none;
        }

        .btn-delete:hover {
            background: #fecaca;
        }
    </style>
</head>

<body>

<!-- SIDEBAR -->
<jsp:include page="/view/admin-layout.jsp"/>

<div class="main-content">

    <!-- TITLE -->
    <div class="mb-4">
        <h2 class="page-title">
            <i class="fa fa-star me-2"></i>Quản lý đánh giá sản phẩm
        </h2>
    </div>

    <!-- ===== FILTER ROW ===== -->
    <div class="row g-3 mb-4">

        <!-- 🔍 SEARCH -->
        <div class="col-md-6">
            <form method="get"
                  action="${pageContext.request.contextPath}/admin/danh-gia"
                  class="mini-filter">

                <label>Tìm kiếm</label>
                <div class="d-flex gap-2">
                    <input type="text"
                           name="keyword"
                           value="${param.keyword}"
                           class="form-control"
                           placeholder="Tên KH / nội dung">

                    <button class="btn btn-primary px-4">
                        <i class="fa fa-search"></i>
                    </button>
                </div>
            </form>
        </div>

        <!-- ⭐ FILTER STAR -->
        <div class="col-md-6">
            <form method="get"
                  action="${pageContext.request.contextPath}/admin/danh-gia"
                  class="mini-filter">

                <label>Lọc theo số sao</label>
                <div class="d-flex gap-2">
                    <select name="diem" class="form-select">
                        <option value="">Tất cả</option>
                        <option value="5" ${param.diem=='5'?'selected':''}>⭐⭐⭐⭐⭐</option>
                        <option value="4" ${param.diem=='4'?'selected':''}>⭐⭐⭐⭐</option>
                        <option value="3" ${param.diem=='3'?'selected':''}>⭐⭐⭐</option>
                        <option value="2" ${param.diem=='2'?'selected':''}>⭐⭐</option>
                        <option value="1" ${param.diem=='1'?'selected':''}>⭐</option>
                    </select>

                    <button class="btn btn-warning px-4">
                        <i class="fa fa-filter"></i>
                    </button>
                </div>
            </form>
        </div>

    </div>

    <!-- ===== TABLE ===== -->
    <div class="table-card">
        <table class="table align-middle">
            <thead>
            <tr>
                <th>Khách hàng</th>
                <th>Điểm</th>
                <th>Nội dung</th>
                <th>Ngày đánh giá</th>
                <th>Thao tác</th>
            </tr>
            </thead>

            <tbody>
            <c:forEach var="dg" items="${list}">
                <tr>
                    <td class="fw-semibold">${dg.tenKhachHang}</td>

                    <td>
                        <c:forEach begin="1" end="5" var="i">
                            <i class="fa fa-star ${i <= dg.diem ? 'star-filled' : 'star-empty'}"></i>
                        </c:forEach>
                    </td>

                    <td style="max-width:420px; line-height:1.5;">
                        ${dg.noiDung}
                    </td>

                    <td class="review-date">
                        <fmt:formatDate value="${dg.ngayDanhGia}" pattern="dd/MM/yyyy"/>
                    </td>

                    <td class="text-center">
                        <a href="${pageContext.request.contextPath}/admin/danh-gia/delete?id=${dg.danhGiaId}"
                           onclick="return confirm('Bạn chắc chắn muốn xóa đánh giá này?')"
                           class="btn-delete">
                            Xóa
                        </a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>

        <c:if test="${empty list}">
            <div class="alert alert-warning text-center mt-3">
                Không có đánh giá nào.
            </div>
        </c:if>
    </div>

</div>

</body>
</html>
