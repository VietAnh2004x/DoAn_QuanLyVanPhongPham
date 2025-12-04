<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Admin | Quản lý sản phẩm</title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <style>
        body {
            margin: 0;
            font-family: "Inter", system-ui, sans-serif;
            background: #f3f4f6;
            font-size: 14px;
            color: #1f2937;
        }

        /* ===== MAIN CONTENT (KHỚP SIDEBAR 220px) ===== */
        .main-content {
            margin-left: 220px;
            padding: 1.5rem;
            max-width: calc(100vw - 220px);
        }

        .page-title {
            font-size: 20px;
            font-weight: 700;
            color: #2563eb;
        }

        /* ===== SEARCH ===== */
        .search-box {
            background: #fff;
            border-radius: 12px;
            padding: 14px 16px;
            border: 1px solid #e5e7eb;
            margin-bottom: 14px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.04);
        }

        /* ===== TABLE ===== */
        .table-wrapper {
            background: #fff;
            border-radius: 12px;
            padding: 14px;
            border: 1px solid #e5e7eb;
            box-shadow: 0 6px 14px rgba(0,0,0,0.04);
        }

        table {
            font-size: 13px;
            table-layout: fixed;          /* ✅ QUAN TRỌNG */
            width: 100%;
        }

        thead {
            background: #2563eb;
            color: #fff;
        }

        th, td {
            padding: 10px;
            vertical-align: middle;
            text-align: center;
        }

        tbody td.text-start {
            text-align: left;
        }

        tbody tr:hover {
            background: #eff6ff;
        }

        /* ===== IMAGE ===== */
        .sp-img {
            width: 48px;
            height: 48px;
            object-fit: cover;
            border-radius: 6px;
            border: 1px solid #e5e7eb;
        }

        /* ===== TEXT ELLIPSIS ===== */
        .text-ellipsis {
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        /* ===== STATUS ===== */
        .badge-status {
            font-size: 12px;
            padding: 4px 10px;
            border-radius: 12px;
            font-weight: 600;
            white-space: nowrap;
        }

        .bg-selling { background: #dcfce7; color: #15803d; }
        .bg-stop { background: #e5e7eb; color: #334155; }
        .bg-out { background: #fee2e2; color: #b91c1c; }

        /* ===== ACTION ===== */
        .btn-action {
            font-size: 12px;
            padding: 4px 8px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
            white-space: nowrap;
        }

        .btn-edit { background: #dbeafe; color: #1d4ed8; }
        .btn-delete { background: #fee2e2; color: #be123c; }
    </style>
</head>

<body>

<!-- SIDEBAR -->
<jsp:include page="/view/admin-layout.jsp"/>

<div class="main-content">

    <!-- HEADER -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="page-title">
            <i class="fa fa-box-open me-2"></i>Quản lý sản phẩm
        </h2>

        <a href="${pageContext.request.contextPath}/admin/san-pham?action=new"
           class="btn btn-primary btn-sm fw-bold">
            <i class="fas fa-plus"></i> Thêm
        </a>
    </div>

    <!-- SEARCH -->
    <form class="search-box row g-3"
          method="get"
          action="${pageContext.request.contextPath}/admin/san-pham">

        <div class="col-md-5">
            <input name="keyword" class="form-control"
                   placeholder="Nhập tên sản phẩm">
        </div>

        <div class="col-md-5">
            <select name="loaiId" class="form-select">
                <option value="0">Tất cả loại</option>
                <c:forEach var="loai" items="${dsLoai}">
                    <option value="${loai.loaiId}">${loai.tenLoai}</option>
                </c:forEach>
            </select>
        </div>

        <div class="col-md-2">
            <button class="btn btn-primary w-100">
                <i class="fas fa-search"></i> Tìm
            </button>
        </div>
    </form>

    <!-- TABLE -->
    <div class="table-wrapper">
        <div class="table-responsive">
            <table class="table table-bordered align-middle">
                <thead>
                <tr>
                    <th style="width:60px">ID</th>
                    <th style="width:70px">Ảnh</th>
                    <th>Tên sản phẩm</th>
                    <th style="width:120px">Giá</th>
                    <th style="width:80px">Tồn</th>
                    <th style="width:120px">Trạng thái</th>
                    <th style="width:130px">Thao tác</th>
                </tr>
                </thead>

                <tbody>
                <c:forEach var="sp" items="${list}">
                    <tr>
                        <td><strong>${sp.sanPhamId}</strong></td>

                        <td>
                            <img class="sp-img" src="${pageContext.request.contextPath}${sp.hinhAnh}">
                        </td>

                        <td class="text-start text-ellipsis" title="${sp.tenSanPham}">
                            ${sp.tenSanPham}
                        </td>

                        <td class="fw-bold text-primary">
                            <fmt:formatNumber value="${sp.giaBan}" groupingUsed="true"/> ₫
                        </td>

                        <td>${sp.tonKho}</td>

                        <td>
                            <span class="badge-status
                                ${sp.trangThai == 'Đang bán' ? 'bg-selling' :
                                  sp.trangThai == 'Ngừng bán' ? 'bg-stop' : 'bg-out'}">
                                ${sp.trangThai}
                            </span>
                        </td>

                        <td>
                            <a href="${pageContext.request.contextPath}/admin/san-pham?action=edit&id=${sp.sanPhamId}"
                               class="btn-action btn-edit">Sửa</a>
                            <a href="${pageContext.request.contextPath}/admin/san-pham?action=delete&sanPhamId=${sp.sanPhamId}"
                                onclick="return confirm('Bạn chắc chắn muốn xóa sản phẩm này?');"
                                class="btn-action btn-delete">
                                 Xóa
                             </a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>

            <c:if test="${empty list}">
                <div class="alert alert-info text-center mt-2">
                    Không có sản phẩm
                </div>
            </c:if>
        </div>
    </div>

</div>
</body>
</html>
