<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết đơn hàng - VPP 3AE</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    </head>
    <body>

        <jsp:include page="_header.jsp" /> 

        <div class="container my-5" style="min-height: 60vh;">
            <div class="row justify-content-center">
                <div class="col-lg-10">
                    
                    <c:set var="dh" value="${donHang}" />
                    
                    <h2 class="text-center mb-4 text-primary fw-bold">Chi Tiết Đơn Hàng #${dh.donHangId}</h2>
                    
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger">${errorMessage}</div>
                    </c:if>
                    
                    <c:if test="${not empty dh}">
                        <div class="card shadow-sm border-0">
                            <div class="card-body p-4">

                                <h5 class="mb-3">Các sản phẩm đã mua</h5>
                                
                                <%-- === SỬA LỖI: Dùng c:forEach để lặp qua itemList === --%>
                                <c:forEach var="item" items="${itemList}">
                                    <div class="row align-items-center g-3 py-3 border-bottom">
                                        <div class="col-2 col-md-1">
                                            <img src="${pageContext.request.contextPath}${item.hinhAnh}" class="img-fluid rounded" alt="${item.tenSanPham}">
                                        </div>
                                        <div class="col-10 col-md-5">
                                            <h6 class="mb-0">${item.tenSanPham}</h6>
                                        </div>
                                        <div class="col-4 col-md-2 text-md-center">
                                            <fmt:formatNumber value="${item.donGia}" type="currency" currencySymbol="" minFractionDigits="0"/>₫
                                        </div>
                                        <div class="col-4 col-md-2 text-md-center">
                                            <span class="border px-3 py-2 rounded">
                                                x ${item.soLuong}
                                            </span>
                                        </div>
                                        <div class="col-4 col-md-2 text-end fw-bold">
                                            <fmt:formatNumber value="${item.donGia * item.soLuong}" type="currency" currencySymbol="" minFractionDigits="0"/>₫
                                        </div>
                                    </div> </c:forEach>
                                <%-- === KẾT THÚC SỬA LỖI === --%>
                                
                                <hr class="my-4">
                                
                                <%-- Thông tin tổng kết (Lấy từ object DonHang) --%>
                                <div class="row">
                                    <div class="col-md-6">
                                        <h5 class="mb-3">Thông tin giao hàng</h5>
                                        <p class="mb-1"><strong>Người nhận:</strong> ${sessionScope.authUser.hoTen}</p>
                                        <p class="mb-1"><strong>Địa chỉ:</strong> ${dh.diaChiGiao}</p>
                                        <p class="mb-1"><strong>Ngày đặt:</strong> <fmt:formatDate value="${dh.ngayDat}" pattern="dd/MM/yyyy HH:mm"/></p>
                                    </div>
                                    <div class="col-md-6">
                                        <h5 class="mb-3">Tổng cộng</h5>
                                        <ul class="list-group list-group-flush">
                                            <li class="list-group-item d-flex justify-content-between align-items-center px-0">
                                                Phí vận chuyển
                                                <span><fmt:formatNumber value="${dh.phiVanChuyen}" type="currency" currencySymbol="" minFractionDigits="0"/>₫</span>
                                            </li>
            <li class="list-group-item d-flex justify-content-between align-items-center px-0 fw-bold fs-5">
                                                Tổng tiền
                                                <span class="text-primary">
                                                    <fmt:formatNumber value="${dh.tongTien}" type="currency" currencySymbol="" minFractionDigits="0"/>₫
                                                </span>
                                            </li>
                                            <li class="list-group-item d-flex justify-content-between align-items-center px-0">
                                                Trạng thái
                                                <span class="badge bg-success fs-6">${dh.trangThai}</span>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                                
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <jsp:include page="_footer.jsp" />

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>