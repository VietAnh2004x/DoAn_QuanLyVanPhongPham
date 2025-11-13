<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Đơn hàng của tôi - VPP 3AE</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    </head>
    <body>

        <%-- Tải Header (dùng đường dẫn tương đối từ 'view/') --%>
        <jsp:include page="_header.jsp" /> 

        <div class="container my-5" style="min-height: 60vh;">
            <div class="row">
                <div class="col-lg-10 offset-lg-1">
                    <h2 class="text-center mb-4 text-primary fw-bold">Lịch Sử Đơn Hàng</h2>
                    
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger">${errorMessage}</div>
                    </c:if>

                    <c:if test="${sessionScope.authUser == null}">
                         <div class="alert alert-danger" role="alert">
                             Bạn cần <a href="${pageContext.request.contextPath}/view/dangnhap.jsp">đăng nhập</a> để xem thông tin này.
                         </div>
                    </c:if>
                    
                    <c:if test="${sessionScope.authUser != null}">
                        
                        <c:if test="${empty listDonHang}">
                            <div class="alert alert-info text-center">
                                Bạn chưa có đơn hàng nào.
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty listDonHang}">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Mã ĐH</th>
                                            <th>Ngày Đặt</th>
                                            <th>Địa chỉ giao</th>
                                            <th>Trạng Thái</th>
                                            <th class="text-end">Tổng Tiền</th>
                                            <th class="text-center">Chi Tiết</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="dh" items="${listDonHang}">
                                            <tr>
                                                <td class="fw-bold">#${dh.donHangId}</td>
                                                <td>
                                                    <fmt:formatDate value="${dh.ngayDat}" pattern="dd-MM-yyyy"/>
                                                </td>
                                                <td>
                                                    ${dh.diaChiGiao}
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${dh.trangThai == 'Đã giao'}">
                                                            <span class="badge bg-success">${dh.trangThai}</span>
                                                        </c:when>
                                                        <c:when test="${dh.trangThai == 'Đang xử lý'}">
                                                            <span class="badge bg-warning text-dark">${dh.trangThai}</span>
                                                        </c:when>
                                                        <c:when test="${dh.trangThai == 'Đã hủy'}">
                                                            <span class="badge bg-danger">${dh.trangThai}</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">${dh.trangThai}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-end">
                                                    <fmt:formatNumber value="${dh.tongTien}" type="currency" currencySymbol="" minFractionDigits="0"/>₫
                                                </td>
                                                <td class="text-center">
                                                    <a href="${pageContext.request.contextPath}/chi-tiet-don-hang?id=${dh.donHangId}" class="btn btn-sm btn-outline-primary">
                                                        <i class="bi bi-eye-fill"></i> Xem
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:if>
                    </c:if>
                </div>
            </div>
        </div>

        <%-- Tải Footer (dùng đường dẫn tương đối từ 'view/') --%>
        <jsp:include page="_footer.jsp" />

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>