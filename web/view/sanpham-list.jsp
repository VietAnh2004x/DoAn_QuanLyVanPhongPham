<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>Quản lý sản phẩm</title>

    <!-- Bootstrap -->
    <link rel="stylesheet" 
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">

    <!-- Font Awesome -->
    <link rel="stylesheet" 
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <style>
        body {
            background: #f3f4f6;
            font-family: "Inter", sans-serif;
            color: #1f2937;
        }

        /* MAIN CONTENT OFFSET (để lệch sidebar) */
        .main-content {
            margin-left: 250px;
            padding: 2rem;
        }

        /* PAGE TITLE */
        .page-title {
            font-size: 26px;
            font-weight: 700;
            color: #2563eb;
        }

        /* ADD BUTTON */
        .btn-add {
            padding: 10px 18px;
            font-weight: 600;
            border-radius: 10px;
            background: #2563eb;
            border: none;
            color: white;
            transition: .25s;
        }
        .btn-add:hover {
            background: #1d4ed8;
            transform: translateY(-2px);
        }

        /* SECTION WRAPPER */
        .section-wrapper {
            background: white;
            border-radius: 16px;
            padding: 22px 26px;
            border: 1px solid #e5e7eb;
            box-shadow: 0 8px 18px rgba(0,0,0,0.05);
        }

        /* SEARCH BOX */
        .search-box {
            background: white;
            padding: 20px;
            border-radius: 16px;
            border: 1px solid #e5e7eb;
            margin-bottom: 20px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.04);
        }
        .search-box label {
            font-weight: 600;
            color: #1e40af;
        }
        .search-box input,
        .search-box select {
            border-radius: 10px;
            border: 1px solid #cbd5e1;
        }

        /* TABLE */
        table thead {
            background: #2563eb;
            color: white;
        }
        table tbody tr:hover {
            background: #eff6ff;
        }
        table img {
            border-radius: 10px;
            border: 1px solid #e5e7eb;
        }

        /* BADGES */
        .badge-status {
            padding: 6px 14px;
            border-radius: 20px;
            font-weight: 600;
            font-size: .82rem;
        }
        .bg-selling { background: #dcfce7; color: #16a34a; }
        .bg-stop { background: #e5e7eb; color: #475569; }
        .bg-out { background: #fee2e2; color: #dc2626; }

        /* ACTION BUTTONS */
        .btn-action {
            border-radius: 8px;
            padding: 6px 12px;
            border: none;
            transition: .25s;
            font-size: .85rem;
        }
        .btn-edit {
            background: #dbeafe;
            color: #1d4ed8;
        }
        .btn-edit:hover {
            background: #bfdbfe;
        }
        .btn-delete {
            background: #fee2e2;
            color: #be123c;
        }
        .btn-delete:hover {
            background: #fecdd3;
        }

    </style>
</head>

<body>

<!-- ============= GỌI ADMIN LAYOUT ============= -->
<jsp:include page="/view/admin-layout.jsp" />

<!-- MAIN CONTENT -->
<div class="main-content">

    <!-- TITLE -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="page-title">
            <i class="fa fa-box-open me-2"></i>Quản lý sản phẩm
        </h2>

        <a href="${pageContext.request.contextPath}/admin/san-pham?action=new"
           class="btn-add">
            <i class="fas fa-plus me-1"></i> Thêm sản phẩm mới
        </a>
    </div>

    <!-- SEARCH -->
    <form action="${pageContext.request.contextPath}/admin/san-pham" method="get" class="search-box">
        <div class="row g-3">

            <div class="col-md-5">
                <label class="form-label">Tên sản phẩm</label>
                <input type="text" name="keyword" class="form-control"
                       placeholder="Nhập tên sản phẩm..."
                       value="${param.keyword}">
            </div>

            <div class="col-md-5">
                <label class="form-label">Loại sản phẩm</label>
                <select name="loaiId" class="form-select">
                    <option value="0">Tất cả</option>
                    <c:forEach var="loai" items="${dsLoai}">
                        <option value="${loai.loaiId}"
                                <c:if test="${param.loaiId == loai.loaiId}">selected</c:if>>
                            ${loai.tenLoai}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="col-md-2">
                <button class="btn-add w-100">
                    <i class="fas fa-search me-1"></i> Tìm
                </button>
            </div>

        </div>
    </form>

    <!-- TABLE -->
    <div class="section-wrapper mt-3">
        <div class="table-responsive">
            <table class="table align-middle">
                <thead class="text-center">
                <tr>
                    <th>ID</th>
                    <th>Hình ảnh</th>
                    <th>Tên sản phẩm</th>
                    <th>Giá bán</th>
                    <th>Tồn kho</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
                </thead>

                <tbody>
                <c:forEach var="sp" items="${list}">
                    <tr>
                        <td class="text-center fw-bold">${sp.sanPhamId}</td>

                        <td class="text-center">
                            <c:choose>
                                <c:when test="${not empty sp.hinhAnh}">
                                    <img src="${pageContext.request.contextPath}${sp.hinhAnh}"
                                         style="width:70px;height:70px;object-fit:cover;">
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted">Không có</span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td class="fw-semibold">${sp.tenSanPham}</td>

                        <td class="text-end fw-bold" style="color:#2563eb;">
                            <fmt:formatNumber value="${sp.giaBan}" type="number" groupingUsed="true"/> ₫
                        </td>

                        <td class="text-center">
                            <span class="badge-status bg-selling">${sp.tonKho}</span>
                        </td>

                        <td class="text-center">
                            <c:choose>
                                <c:when test="${sp.trangThai == 'Đang bán'}">
                                    <span class="badge-status bg-selling">${sp.trangThai}</span>
                                </c:when>
                                <c:when test="${sp.trangThai == 'Ngừng bán'}">
                                    <span class="badge-status bg-stop">${sp.trangThai}</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge-status bg-out">${sp.trangThai}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td class="text-center">
                            <a href="${pageContext.request.contextPath}/admin/san-pham?action=edit&id=${sp.sanPhamId}"
                               class="btn-action btn-edit me-1">
                                Sửa
                            </a>

                            <a href="${pageContext.request.contextPath}/admin/san-pham?action=delete&id=${sp.sanPhamId}"
                               onclick="return confirm('Bạn có chắc muốn xóa sản phẩm này?')"
                               class="btn-action btn-delete">
                                Xóa
                            </a>
                        </td>

                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <c:if test="${empty list}">
            <div class="alert alert-warning text-center mt-3">
                Không có sản phẩm nào.
            </div>
        </c:if>

    </div>
</div>

</body>
</html>
