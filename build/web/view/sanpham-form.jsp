<%@page contentType="text/html;charset=UTF-8" language="java"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<html>
<head>
    <title><c:choose>
        <c:when test="${sp != null}">Cập nhật sản phẩm</c:when>
        <c:otherwise>Thêm sản phẩm mới</c:otherwise>
    </c:choose></title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="p-4 bg-light">
<div class="container mt-4">
    <h3 class="fw-bold mb-4">
        <c:choose>
            <c:when test="${sp != null}">Cập nhật sản phẩm</c:when>
            <c:otherwise>Thêm sản phẩm mới</c:otherwise>
        </c:choose>
    </h3>

    <form action="${pageContext.request.contextPath}/admin/san-pham"
          method="post" enctype="multipart/form-data"
          class="border rounded shadow-sm bg-white p-4">

        <input type="hidden" name="sanPhamId" value="${sp.sanPhamId}" />

        <!-- Tên sản phẩm -->
        <div class="mb-3">
            <label class="form-label fw-bold">Tên sản phẩm</label>
            <input name="tenSanPham" value="${sp.tenSanPham}" required class="form-control" />
        </div>

        <!-- Giá nhập -->
        <div class="mb-3">
            <label class="form-label fw-bold">Giá nhập</label>
            <input name="giaNhap" value="${sp.giaNhap}" required type="number" step="100" class="form-control" />
        </div>

        <!-- Giá bán -->
        <div class="mb-3">
            <label class="form-label fw-bold">Giá bán</label>
            <input name="giaBan" value="${sp.giaBan}" required type="number" step="100" class="form-control" />
        </div>

        <!-- Tồn kho -->
        <div class="mb-3">
            <label class="form-label fw-bold">Tồn kho</label>
            <input name="tonKho" value="${sp.tonKho}" required type="number" class="form-control" />
        </div>

        <!-- Loại sản phẩm -->
        <div class="mb-3">
            <label class="form-label fw-bold">Loại sản phẩm</label>
            <select name="loaiId" class="form-select" required>
                <option value="">-- Chọn loại --</option>
                <c:forEach var="l" items="${dsLoai}">
                    <option value="${l.loaiId}"
                        <c:if test="${sp != null && sp.loaiId == l.loaiId}">selected</c:if>>
                        ${l.tenLoai}
                    </option>
                </c:forEach>
            </select>
        </div>

        <!-- Nhà cung cấp -->
        <div class="mb-3">
            <label class="form-label fw-bold">Nhà cung cấp</label>
            <select name="nhaCungCapId" class="form-select" required>
                <option value="">-- Chọn nhà cung cấp --</option>
                <c:forEach var="n" items="${dsNCC}">
                    <option value="${n.nhaCungCapId}"
                        <c:if test="${sp != null && sp.nhaCungCapId == n.nhaCungCapId}">selected</c:if>>
                        ${n.tenNhaCungCap}
                    </option>
                </c:forEach>
            </select>
        </div>

        <!-- Hình ảnh -->
        <div class="mb-3">
            <label class="form-label fw-bold">Hình ảnh sản phẩm</label>
            <input type="file" name="hinhAnhFile" class="form-control" accept="image/*" />
            <c:if test="${sp != null && sp.hinhAnh != null}">
                <div class="mt-2">
                    <img src="${pageContext.request.contextPath}${sp.hinhAnh}" 
                         alt="Ảnh sản phẩm" style="max-width: 150px; border-radius: 6px;">
                </div>
            </c:if>
        </div>

        <!-- Mô tả -->
        <div class="mb-3">
            <label class="form-label fw-bold">Mô tả</label>
            <textarea name="moTa" class="form-control" rows="3">${sp.moTa}</textarea>
        </div>

        <!-- Trạng thái -->
        <div class="mb-3">
            <label class="form-label fw-bold">Trạng thái</label>
            <select name="trangThai" class="form-select">
                <option value="Đang bán"
                    <c:if test="${sp != null && sp.trangThai == 'Đang bán'}">selected</c:if>>Đang bán</option>
                <option value="Ngừng bán"
                    <c:if test="${sp != null && sp.trangThai == 'Ngừng bán'}">selected</c:if>>Ngừng bán</option>
                <option value="Hết hàng"
                    <c:if test="${sp != null && sp.trangThai == 'Hết hàng'}">selected</c:if>>Hết hàng</option>
            </select>
        </div>

        <div class="d-flex justify-content-between mt-4">
            <button type="submit" class="btn btn-success px-4">Lưu</button>
            <a href="${pageContext.request.contextPath}/admin/san-pham" class="btn btn-secondary px-4">Hủy</a>
        </div>
    </form>
</div>
</body>
</html>
