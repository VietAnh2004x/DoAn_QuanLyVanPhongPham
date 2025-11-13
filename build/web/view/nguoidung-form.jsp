<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
<title>Quản lý đơn hàng</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
</head>
<body>

<div class="container mt-4">
    <h3>Quản lý đơn hàng</h3>

    <table class="table table-bordered table-hover align-middle">
        <thead class="table-primary">
            <tr>
                <th>Mã đơn</th>
                <th>Khách hàng</th>
                <th>Ngày đặt</th>
                <th>Tổng tiền</th>
                <th>Trạng thái</th>
                <th>Chi tiết</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="dh" items="${list}">
                <tr>
                    <td>#${dh.donHangId}</td>
                    <td>${dh.khachHangId}</td>
                    <td><fmt:formatDate value="${dh.ngayDat}" pattern="dd/MM/yyyy HH:mm"/></td>
                    <td><fmt:formatNumber value="${dh.tongTien}" type="number" groupingUsed="true"/> ₫</td>
                    <td>
                        <c:choose>
                            <c:when test="${dh.trangThai eq 'Chờ xác nhận'}">
                                <span class="badge bg-warning text-dark">${dh.trangThai}</span>
                            </c:when>
                            <c:when test="${dh.trangThai eq 'Đã giao'}">
                                <span class="badge bg-success">${dh.trangThai}</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-secondary">${dh.trangThai}</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <button class="btn btn-sm btn-info" 
                            onclick="alert('Chi tiết sản phẩm: ${dh.danhSachSanPham}')">Xem</button>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

</body>
</html>
