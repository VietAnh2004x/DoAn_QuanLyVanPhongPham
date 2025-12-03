<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết đơn hàng #${dh.donHangId}</title>

    <!-- Bootstrap -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">

    <!-- Font Awesome -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <style>
        body {
            background: #f3f4f6;
            font-family: Inter, system-ui, sans-serif;
            font-size: 14px;
            color: #1f2937;
        }

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

        .breadcrumb-custom a {
            text-decoration: none;
            font-weight: 600;
            color: #2563eb;
        }

        .breadcrumb-custom span {
            color: #6b7280;
            font-weight: 600;
        }

        .card-wrapper {
            border-radius: 16px;
            border: 1px solid #e5e7eb;
            box-shadow: 0 8px 20px rgba(0,0,0,.04);
        }
    </style>
</head>

<body>

<!-- ✅ SIDEBAR ADMIN -->
<jsp:include page="/view/admin-layout.jsp"/>

<!-- ✅ MAIN CONTENT -->
<div class="main-content">

    <!-- ✅ HEADER: BREADCRUMB + BUTTON -->
    <div class="d-flex justify-content-between align-items-start mb-4">

        <!-- LEFT -->
        <div>
            <div class="breadcrumb-custom mb-1">
                <a href="${pageContext.request.contextPath}/admin/don-hang">
                    ← Quản lý đơn hàng
                </a>
                <span> / Chi tiết đơn hàng #${dh.donHangId}</span>
            </div>

            <h2 class="page-title mb-0">
                <i class="fas fa-receipt me-2"></i>
                Chi tiết đơn hàng #${dh.donHangId}
            </h2>
        </div>

        <!-- ✅ RIGHT: ACTIONS -->
        <div class="d-flex gap-2">
            <a target="_blank"
               href="${pageContext.request.contextPath}/admin/don-hang?action=print&id=${dh.donHangId}"
               class="btn btn-primary fw-semibold">
                <i class="fas fa-print me-1"></i> In hóa đơn
            </a>

        </div>

    </div>

    <!-- ✅ CARD -->
    <div class="card card-wrapper">
        <div class="card-body p-4">

            <!-- THÔNG TIN KHÁCH + ĐƠN -->
            <div class="row mb-4">

                <div class="col-md-6">
                    <h6 class="text-primary fw-bold mb-2">
                        <i class="fas fa-user me-1"></i> Thông tin khách hàng
                    </h6>
                    <p><strong>Khách hàng:</strong> ${dh.hoTenKhach} (ID: ${dh.khachHangId})</p>
                    <p><strong>Địa chỉ giao:</strong> ${dh.diaChiGiao}</p>
                </div>

                <div class="col-md-6">
                    <h6 class="text-primary fw-bold mb-2">
                        <i class="fas fa-box me-1"></i> Thông tin đơn hàng
                    </h6>

                    <p>
                        <strong>Trạng thái:</strong>
                        <c:choose>
                            <c:when test="${dh.trangThai == 'Hoàn tất'}">
                                <span class="badge bg-success">Hoàn tất</span>
                            </c:when>
                            <c:when test="${dh.trangThai == 'Đang giao'}">
                                <span class="badge bg-info text-dark">Đang giao</span>
                            </c:when>
                            <c:when test="${dh.trangThai == 'Chờ xác nhận'}">
                                <span class="badge bg-warning text-dark">Chờ xác nhận</span>
                            </c:when>
                            <c:when test="${dh.trangThai == 'Đã hủy'}">
                                <span class="badge bg-danger">Đã hủy</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary">${dh.trangThai}</span>
                            </c:otherwise>
                        </c:choose>
                    </p>

                    <p>
                        <strong>Ngày đặt:</strong>
                        <fmt:formatDate value="${dh.ngayDat}"
                                        pattern="HH:mm 'ngày' dd/MM/yyyy"/>
                    </p>

                    <p>
                        <strong>Phí vận chuyển:</strong>
                        <fmt:formatNumber value="${dh.phiVanChuyen}" pattern="#,##0 ₫"/>
                    </p>

                    <p>
                        <strong>Tổng tiền:</strong>
                        <span class="fw-bold text-danger">
                            <fmt:formatNumber value="${dh.tongTien}" pattern="#,##0 ₫"/>
                        </span>
                    </p>
                </div>
            </div>

            <hr>

            <!-- DANH SÁCH SẢN PHẨM -->
            <h6 class="text-primary fw-bold mb-3">
                <i class="fas fa-list-ul me-1"></i> Danh sách sản phẩm
            </h6>

            <div class="table-responsive">
                <table class="table table-bordered align-middle">
                    <thead class="table-light text-center">
                    <tr>
                        <th width="80">ID SP</th>
                        <th>Tên sản phẩm</th>
                        <th width="100">Số lượng</th>
                        <th width="130">Đơn giá</th>
                        <th width="150">Thành tiền</th>
                    </tr>
                    </thead>
                    <tbody>

                    <c:forEach var="item" items="${listSanPham}">
                        <tr>
                            <td class="text-center">
                                <fmt:formatNumber value="${item.SanPhamId}" maxFractionDigits="0"/>
                            </td>
                            <td>${item.TenSanPham}</td>
                            <td class="text-center">
                                <fmt:formatNumber value="${item.SoLuong}" maxFractionDigits="0"/>
                            </td>
                            <td class="text-end">
                                <fmt:formatNumber value="${item.GiaBan}" pattern="#,##0 ₫"/>
                            </td>
                            <td class="text-end fw-bold text-danger">
                                <fmt:formatNumber value="${item.SoLuong * item.GiaBan}" pattern="#,##0 ₫"/>
                            </td>
                        </tr>
                    </c:forEach>

                    </tbody>
                </table>
            </div>

            <!-- BACK -->
            <div class="mt-4">
                <a href="${pageContext.request.contextPath}/admin/don-hang"
                   class="btn btn-outline-primary fw-semibold">
                    <i class="fas fa-arrow-left me-1"></i> Quay lại danh sách
                </a>
            </div>

        </div>
    </div>
</div>
</body>
</html>
