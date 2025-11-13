<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
    <title>Quản lý sản phẩm</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body class="bg-light">
<div class="container mt-4">

    <!-- Tiêu đề và nút thêm mới -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3 class="fw-bold">Quản lý sản phẩm</h3>
        <a href="${pageContext.request.contextPath}/admin/san-pham?action=new" class="btn btn-primary">
            <i class="fas fa-plus me-1"></i> Thêm sản phẩm mới
        </a>
    </div>

    <!-- Form tìm kiếm -->
    <form action="${pageContext.request.contextPath}/admin/san-pham" method="get" 
          class="mb-4 p-3 border rounded bg-white shadow-sm">

        <div class="row g-3 align-items-end">
            <!-- Tìm theo tên -->
            <div class="col-md-5">
                <label for="keyword" class="form-label">Tên sản phẩm</label>
                <input type="text" name="keyword" id="keyword" class="form-control" 
                       placeholder="Nhập tên sản phẩm để tìm..." 
                       value="${param.keyword}">
            </div>

            <!-- Lọc theo loại sản phẩm -->
            <div class="col-md-5">
                <label for="loaiId" class="form-label">Loại sản phẩm</label>
                <select name="loaiId" id="loaiId" class="form-select">
                    <option value="0">Tất cả loại sản phẩm</option>
                    <c:forEach var="loai" items="${dsLoai}">
                        <option value="${loai.loaiId}" 
                            <c:if test="${param.loaiId == loai.loaiId}">selected</c:if>>
                            ${loai.tenLoai}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <!-- Nút tìm kiếm -->
            <div class="col-md-2">
                <button type="submit" class="btn btn-primary w-100">
                    <i class="fas fa-search me-1"></i> Tìm
                </button>
            </div>
        </div>
    </form>

    <!-- Hiển thị lỗi nếu có -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <!-- Bảng danh sách sản phẩm -->
    <table class="table table-bordered table-hover align-middle shadow-sm bg-white">
        <thead class="table-dark text-center">
            <tr>
                <th>ID</th>
                <th>Hình ảnh</th>
                <th>Tên sản phẩm</th>
                <th>Giá bán</th>
                <th>Tồn kho</th>
                <th>Trạng thái</th>
                <th style="width: 150px;">Thao tác</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="sp" items="${list}">
                <tr>
                    <td class="text-center">${sp.sanPhamId}</td>

                    <td class="text-center">
                        <c:choose>
                            <c:when test="${not empty sp.hinhAnh}">
                                <img src="${pageContext.request.contextPath}${sp.hinhAnh}" 
                                     alt="Ảnh sản phẩm" 
                                     style="width:70px; height:70px; object-fit:cover; border-radius:8px;">
                            </c:when>
                            <c:otherwise>
                                <span class="text-muted">Không có</span>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td>${sp.tenSanPham}</td>

                    <td class="text-end">
                        <fmt:formatNumber value="${sp.giaBan}" type="number" groupingUsed="true"/> ₫
                    </td>

                    <td class="text-center">${sp.tonKho}</td>

                    <td class="text-center">
                        <c:choose>
                            <c:when test="${sp.trangThai == 'Đang bán'}">
                                <span class="badge bg-success">${sp.trangThai}</span>
                            </c:when>
                            <c:when test="${sp.trangThai == 'Ngừng bán'}">
                                <span class="badge bg-secondary">${sp.trangThai}</span>
                            </c:when>
                            <c:when test="${sp.trangThai == 'Hết hàng'}">
                                <span class="badge bg-danger">${sp.trangThai}</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-warning text-dark">${sp.trangThai}</span>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <td class="text-center">
                        <a href="${pageContext.request.contextPath}/admin/san-pham?action=edit&id=${sp.sanPhamId}" 
                           class="btn btn-sm btn-warning">Sửa</a>
                        <a href="${pageContext.request.contextPath}/admin/san-pham?action=delete&id=${sp.sanPhamId}"
                           class="btn btn-sm btn-danger"
                           onclick="return confirm('Bạn có chắc muốn xóa sản phẩm này?')">Xóa</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <!-- Khi không có sản phẩm -->
    <c:if test="${empty list}">
        <div class="alert alert-info text-center mt-3">
            Không có sản phẩm nào trong hệ thống.
        </div>
    </c:if>
</div>
</body>
</html>
