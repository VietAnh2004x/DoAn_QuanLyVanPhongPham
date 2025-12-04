<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>
        <c:choose>
            <c:when test="${sp != null}">Cập nhật sản phẩm</c:when>
            <c:otherwise>Thêm sản phẩm mới</c:otherwise>
        </c:choose>
    </title>

    <!-- Bootstrap -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">

    <style>
        body {
            background: #f3f4f6;
            font-family: Inter, system-ui, sans-serif;
        }

        /* ✅ ĐỒNG BỘ SIDEBAR 220px */
        .main-content {
            margin-left: 220px;
            padding: 24px 28px;
            max-width: calc(100vw - 220px);
        }

        .page-title {
            font-size: 22px;
            font-weight: 700;
            color: #2563eb;
        }

        .card-form {
            border: 1px solid #e5e7eb;
            border-radius: 16px;
            box-shadow: 0 8px 20px rgba(0,0,0,.04);
        }
    </style>
</head>

<body>

<!-- ✅ SIDEBAR -->
<jsp:include page="/view/admin-layout.jsp"/>

<!-- ✅ MAIN -->
<div class="main-content">

    <!-- ✅ BREADCRUMB -->
    <nav class="mb-3">
        <a href="${pageContext.request.contextPath}/admin/san-pham"
           class="text-decoration-none text-primary fw-semibold">
            ← Quản lý sản phẩm
        </a>
        <span class="text-muted"> / </span>
        <span class="text-muted">
            <c:choose>
                <c:when test="${sp != null}">Cập nhật</c:when>
                <c:otherwise>Thêm mới</c:otherwise>
            </c:choose>
        </span>
    </nav>

    <!-- ✅ TITLE -->
    <h2 class="page-title mb-4">
        <c:choose>
            <c:when test="${sp != null}">✏️ Cập nhật sản phẩm</c:when>
            <c:otherwise>➕ Thêm sản phẩm mới</c:otherwise>
        </c:choose>
    </h2>

    <!-- ✅ FORM -->
    <div class="card card-form">
        <div class="card-body p-4">

            <form action="${pageContext.request.contextPath}/admin/san-pham"
                  method="post"
                  enctype="multipart/form-data">

                <input type="hidden" name="sanPhamId" value="${sp.sanPhamId}" />

                <div class="row g-3">

                    <!-- TÊN -->
                    <div class="col-md-12">
                        <label class="form-label fw-semibold">Tên sản phẩm</label>
                        <input name="tenSanPham"
                               value="${sp.tenSanPham}"
                               required
                               class="form-control">
                    </div>

                    <!-- GIÁ NHẬP -->
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Giá nhập</label>
                        <input name="giaNhap"
                               value="${sp.giaNhap}"
                               type="number"
                               step="100"
                               required
                               class="form-control">
                    </div>

                    <!-- GIÁ BÁN -->
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Giá bán</label>
                        <input name="giaBan"
                               value="${sp.giaBan}"
                               type="number"
                               step="100"
                               required
                               class="form-control">
                    </div>

                    <!-- TỒN -->
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Tồn kho</label>
                        <input name="tonKho"
                               value="${sp.tonKho}"
                               type="number"
                               required
                               class="form-control">
                    </div>

                    <!-- LOẠI -->
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Loại sản phẩm</label>
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

                    <!-- NCC -->
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Nhà cung cấp</label>
                        <select name="nhaCungCapId" class="form-select" required>
                            <option value="">-- Chọn NCC --</option>
                            <c:forEach var="n" items="${dsNCC}">
                                <option value="${n.nhaCungCapId}"
                                        <c:if test="${sp != null && sp.nhaCungCapId == n.nhaCungCapId}">selected</c:if>>
                                    ${n.tenNhaCungCap}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- HÌNH -->
                    <div class="col-md-12">
                        <label class="form-label fw-semibold">Hình ảnh</label>
                        <input type="file"
                               name="hinhAnhFile"
                               accept="image/*"
                               class="form-control">
                        <c:if test="${sp != null && sp.hinhAnh != null}">
                            <img src="${pageContext.request.contextPath}${sp.hinhAnh}"
                                 class="mt-2 rounded"
                                 style="max-width:140px">
                        </c:if>
                    </div>

                    <!-- MÔ TẢ -->
                    <div class="col-md-12">
                        <label class="form-label fw-semibold">Mô tả</label>
                        <textarea name="moTa"
                                  rows="3"
                                  class="form-control">${sp.moTa}</textarea>
                    </div>

                    <!-- TRẠNG THÁI -->
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Trạng thái</label>
                        <select name="trangThai" class="form-select">
                            <option value="Đang bán"
                                    <c:if test="${sp.trangThai=='Đang bán'}">selected</c:if>>Đang bán</option>
                            <option value="Ngừng bán"
                                    <c:if test="${sp.trangThai=='Ngừng bán'}">selected</c:if>>Ngừng bán</option>
                            <option value="Hết hàng"
                                    <c:if test="${sp.trangThai=='Hết hàng'}">selected</c:if>>Hết hàng</option>
                        </select>
                    </div>
                </div>

                <!-- ACTION -->
                <div class="d-flex justify-content-between mt-4">
                    <button type="submit" class="btn btn-success px-4 fw-semibold">
                        💾 Lưu
                    </button>

                    <!-- ✅ BACK CÁCH 1 -->
                    <a href="${pageContext.request.contextPath}/admin/san-pham"
                       class="btn btn-outline-secondary px-4">
                        ↩ Quay lại
                    </a>
                </div>
            </form>

        </div>
    </div>
</div>
</body>
</html>
