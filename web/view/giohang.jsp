<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Giỏ hàng | Văn Phòng Phẩm 3AE</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cart-page.css">
</head>
<body>
    <jsp:include page="_header.jsp" />

    <div class="container cart-container my-5">
        <h1 class="cart-page-title mb-4">Giỏ hàng</h1>

        <div class="row">
            <!-- ==================== DANH SÁCH SẢN PHẨM ==================== -->
            <div class="col-lg-8">
                <div class="cart-items-wrapper">
                    <c:if test="${empty cartItems}">
                        <div class="alert alert-info text-center" role="alert">
                            Giỏ hàng của bạn đang trống!
                        </div>
                    </c:if>

                    <c:forEach var="item" items="${cartItems}">
                        <div class="cart-item border-bottom py-3">
                            <div class="row align-items-center">
                                <!-- Ảnh -->
                                <div class="col-2">
                                    <img src="${pageContext.request.contextPath}/${item.sanPham.hinhAnh}"
                                         class="img-fluid rounded cart-item-img"
                                         alt="${item.sanPham.tenSanPham}">
                                </div>

                                <!-- Tên sản phẩm -->
                                <div class="col-4">
                                    <h6 class="cart-item-title mb-0">${item.sanPham.tenSanPham}</h6>
                                </div>

                                <!-- Giá -->
                                <div class="col-2 text-end">
                                    <span class="cart-item-price text-primary fw-semibold">
                                        <fmt:formatNumber value="${item.sanPham.giaKhuyenMai}" type="number" groupingUsed="true"/>₫
                                    </span>
                                </div>

                                <!-- Số lượng -->
                                <div class="col-2 text-center">
                                    <div class="d-flex align-items-center justify-content-center">
                                        <button class="btn btn-qty btn-sm btn-minus border" data-itemid="${item.id}">
                                            <i class="bi bi-dash"></i>
                                        </button>
                                        <input type="text"
                                               class="qty-input text-center border-0 bg-transparent"
                                               value="${item.soLuong}"
                                               readonly
                                               data-itemid="${item.id}"
                                               style="width: 40px;">
                                        <button class="btn btn-qty btn-sm btn-plus border" data-itemid="${item.id}">
                                            <i class="bi bi-plus"></i>
                                        </button>
                                    </div>
                                </div>

                                <!-- Xóa -->
                                <div class="col-1 text-end">
                                    <button class="btn btn-remove-item text-danger" data-itemid="${item.id}">
                                        <i class="bi bi-x-lg"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- ==================== TỔNG TIỀN & ĐẶT HÀNG ==================== -->
            <div class="col-lg-4">
                <div class="summary-wrapper p-4 border rounded shadow-sm">
                    <h5 class="summary-title mb-3">Tổng tiền</h5>
                    <div class="summary-total d-flex justify-content-between mb-3">
                        <span>Tổng cộng:</span>
                        <span class="fw-bold text-danger fs-5">
                            <fmt:formatNumber value="${cartTotal}" type="number" groupingUsed="true"/>₫
                        </span>
                    </div>

                    <!-- VAT -->
                    <div class="vat-invoice-section">
                        <div class="form-check mb-3">
                            <input class="form-check-input" type="checkbox" id="vatCheckbox">
                            <label class="form-check-label fw-bold" for="vatCheckbox">
                                Xuất hoá đơn công ty
                            </label>
                        </div>

                        <div id="vatForm" class="vat-form" style="display:none;">
                            <div class="mb-2">
                                <label class="form-label small">Tên công ty:</label>
                                <input type="text" class="form-control form-control-sm">
                            </div>
                            <div class="mb-2">
                                <label class="form-label small">Mã số thuế:</label>
                                <input type="text" class="form-control form-control-sm">
                            </div>
                            <div class="mb-2">
                                <label class="form-label small">Địa chỉ công ty:</label>
                                <input type="text" class="form-control form-control-sm">
                            </div>
                            <div class="mb-2">
                                <label class="form-label small">Email công ty:</label>
                                <input type="email" class="form-control form-control-sm">
                            </div>
                            <p class="small text-danger mb-0">
                                *Vui lòng nhập đầy đủ và chính xác thông tin hóa đơn.
                            </p>
                        </div>
                    </div>

                    <!-- ✅ FORM GỬI ĐẾN THANHTOAN SERVLET (GET - checkout) -->
                    <form action="${pageContext.request.contextPath}/thanh-toan" method="get">
                        <input type="hidden" name="action" value="checkout">
                        <button type="submit" class="btn btn-primary btn-checkout w-100 mt-4">
                            Tiến hành đặt hàng
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="_footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/cart-page.js"></script>

    <script>
        // ✅ Hiển thị form VAT khi chọn
        const vatCheckbox = document.getElementById('vatCheckbox');
        const vatForm = document.getElementById('vatForm');
        if (vatCheckbox) {
            vatCheckbox.addEventListener('change', function() {
                vatForm.style.display = this.checked ? 'block' : 'none';
            });
        }
    </script>
</body>
</html>
