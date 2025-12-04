<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đơn hàng ${dh.donHangId}</title>

    <!-- Bootstrap -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">

    <!-- Font Awesome -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <style>
        body {
            background: #ffffff;
            font-family: "Inter", Arial, sans-serif;
            font-size: 14px;
            color: #000;
        }

        .order-wrapper {
            max-width: 900px;
            margin: 30px auto;
            border: 1px solid #000;
            padding: 24px;
        }

        .order-header {
            border-bottom: 2px solid #000;
            padding-bottom: 12px;
            margin-bottom: 20px;
        }

        .brand {
            font-weight: 900;
            font-size: 18px;
        }

        .order-title {
            font-size: 24px;
            font-weight: 800;
        }

        .customer-box {
            border: 1px solid #000;
            padding: 12px 16px;
            margin-bottom: 20px;
            background: #fafafa;
        }

        .customer-box div {
            line-height: 1.6;
        }

        table th, table td {
            border: 1px solid #000 !important;
            padding: 10px;
            font-size: 13px;
        }

        table th {
            background: #f0f0f0;
            text-align: center;
        }

        .total-box {
            border-top: 2px solid #000;
            padding-top: 12px;
            margin-top: 16px;
        }

        .total-line {
            display: flex;
            justify-content: space-between;
            margin-bottom: 6px;
        }

        .total-final {
            font-size: 18px;
            font-weight: 800;
        }

        .action-bar {
            margin-top: 24px;
            display: flex;
            justify-content: space-between;
        }

        @media print {
            .action-bar {
                display: none;
            }
            .order-wrapper {
                border: none;
                margin: 0;
            }
        }
    </style>
</head>

<body>

<!-- ===== TẠO MÃ ĐƠN HÀNG ===== -->
<c:set var="orderDate">
    <fmt:formatDate value="${dh.ngayDat}" pattern="yyMMdd"/>
</c:set>
<c:set var="orderCode"
       value="3AE-${orderDate}-${fn:substring('000000', 0, 6 - dh.donHangId.toString().length())}${dh.donHangId}"/>

<div class="order-wrapper">

    <!-- ===== HEADER ===== -->
    <div class="order-header d-flex justify-content-between">
        <div>
            <div class="brand">VĂN PHÒNG PHẨM 3AE</div>
            <div>Phiếu đơn hàng</div>
        </div>
        <div class="text-end">
            <div class="order-title">ĐƠN HÀNG</div>
            <strong>Mã đơn:</strong> ${orderCode}<br>
            <strong>Ngày đặt:</strong>
            <fmt:formatDate value="${dh.ngayDat}" pattern="dd/MM/yyyy HH:mm"/>
        </div>
    </div>

    <!-- ===== THÔNG TIN KHÁCH ===== -->
    <div class="customer-box">
        <div class="row">
            <div class="col-md-6">
                <strong>Khách hàng:</strong> ${dh.hoTenKhach}<br>
                <strong>SĐT:</strong> ${dh.soDienThoai}
            </div>

            <div class="col-md-6 text-end"></div>

            <div class="col-12 mt-2">
                <strong>Địa chỉ giao hàng:</strong> ${dh.diaChiGiao}
            </div>
        </div>
    </div>

    <!-- ===== DANH SÁCH SẢN PHẨM ===== -->
    <table class="table table-bordered align-middle">
        <thead>
        <tr>
            <th width="60">#</th>
            <th>Tên sản phẩm</th>
            <th width="100">Số lượng</th>
            <th width="130">Đơn giá</th>
            <th width="150">Thành tiền</th>
        </tr>
        </thead>
        <tbody>

        <c:set var="stt" value="1"/>
        <c:forEach var="item" items="${listSanPham}">
            <tr>
                <td class="text-center">${stt}</td>
                <td>${item.TenSanPham}</td>
                <td class="text-center">
                    <fmt:formatNumber value="${item.SoLuong}" maxFractionDigits="0"/>
                </td>
                <td class="text-end">
                    <fmt:formatNumber value="${item.GiaBan}" pattern="#,##0 ₫"/>
                </td>
                <td class="text-end fw-bold">
                    <fmt:formatNumber value="${item.SoLuong * item.GiaBan}" pattern="#,##0 ₫"/>
                </td>
            </tr>
            <c:set var="stt" value="${stt + 1}"/>
        </c:forEach>

        </tbody>
    </table>

    <!-- ===== TỔNG TIỀN ===== -->
    <div class="total-box">
        <div class="total-line">
            <span>Tổng tiền hàng</span>
            <span>
                <fmt:formatNumber value="${dh.tongTien - dh.phiVanChuyen}" pattern="#,##0 ₫"/>
            </span>
        </div>
        <div class="total-line">
            <span>Phí vận chuyển</span>
            <span>
                <fmt:formatNumber value="${dh.phiVanChuyen}" pattern="#,##0 ₫"/>
            </span>
        </div>
        <div class="total-line total-final">
            <span>TỔNG THANH TOÁN</span>
            <span>
                <fmt:formatNumber value="${dh.tongTien}" pattern="#,##0 ₫"/>
            </span>
        </div>
    </div>

    <!-- ===== ACTION ===== -->
    <div class="action-bar">
        <a href="${pageContext.request.contextPath}/admin/don-hang"
           class="btn btn-secondary">
            <i class="fas fa-arrow-left"></i> Quay lại
        </a>

        <button onclick="window.print()" class="btn btn-dark">
            <i class="fas fa-print"></i> In đơn hàng
        </button>
    </div>

</div>

</body>
</html>
