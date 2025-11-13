<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<html>
<head>
    <title>Chi tiết đơn hàng #${dh.donHangId}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
</head>

<body class="bg-light">
<div class="container mt-5 mb-5">

    <!-- Tiêu đề -->
    <div class="card shadow-sm border-0">
        <div class="card-header bg-primary text-white p-3">
            <h3 class="mb-0">
                <i class="fas fa-receipt me-2"></i>
                Chi tiết đơn hàng #${dh.donHangId}
            </h3>
        </div>

        <!-- Nội dung -->
        <div class="card-body p-4">

            <!-- Thông tin khách + đơn -->
            <div class="row">
                <div class="col-md-6 mb-3">
                    <h5 class="text-primary"><i class="fas fa-user me-2"></i>Thông tin khách hàng</h5>
                    <p><strong>Khách hàng:</strong> ${dh.hoTenKhach} (ID: ${dh.khachHangId})</p>
                    <p><strong>Địa chỉ giao:</strong> ${dh.diaChiGiao}</p>
                </div>

                <div class="col-md-6 mb-3">
                    <h5 class="text-primary"><i class="fas fa-box me-2"></i>Thông tin đơn hàng</h5>
                    <p><strong>Trạng thái:</strong>
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
                    <p><strong>Ngày đặt:</strong> 
                        <fmt:formatDate value="${dh.ngayDat}" pattern="HH:mm 'ngày' dd/MM/yyyy"/>
                    </p>
                    <p><strong>Phí vận chuyển:</strong> 
                        <fmt:formatNumber value="${dh.phiVanChuyen}" type="number" pattern="#,##0 ₫"/>
                    </p>
                    <p><strong>Tổng tiền:</strong> 
                        <span class="fw-bold text-danger">
                            <fmt:formatNumber value="${dh.tongTien}" type="number" pattern="#,##0 ₫"/>
                        </span>
                    </p>
                </div>
            </div>

            <hr>

            <!-- Danh sách sản phẩm -->
            <h5 class="text-primary"><i class="fas fa-list-ul me-2"></i>Danh sách sản phẩm</h5>

            <div class="table-responsive mt-3">
                <table class="table table-bordered table-striped align-middle">
                    <thead class="table-light">
                        <tr class="text-center text-uppercase">
                            <th style="width: 10%">ID SP</th>
                            <th>Tên sản phẩm</th>
                            <th style="width: 10%">Số lượng</th>
                            <th style="width: 15%">Đơn giá</th>
                            <th style="width: 15%">Thành tiền</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${empty listSanPham}">
                            <tr>
                                <td colspan="5" class="text-center text-muted py-3">
                                    Không có sản phẩm nào trong đơn hàng này.
                                </td>
                            </tr>
                        </c:if>

                        <c:forEach var="item" items="${listSanPham}">
                            <tr>
                                <td class="text-center">${item.SanPhamId}</td>
                                <td>${item.TenSanPham}</td>
                                <td class="text-center">${item.SoLuong}</td>
                                <td class="text-end">
                                    <fmt:formatNumber value="${item.GiaBan}" type="number" pattern="#,##0 ₫"/>
                                </td>
                                <td class="text-end fw-bold text-danger">
                                    <fmt:formatNumber value="${item.SoLuong * item.GiaBan}" type="number" pattern="#,##0 ₫"/>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Nút quay lại -->
            <div class="mt-4">
                <a href="${pageContext.request.contextPath}/admin/don-hang" class="btn btn-secondary">
                    <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
                </a>
            </div>

        </div>
    </div>
</div>
</body>
</html>
