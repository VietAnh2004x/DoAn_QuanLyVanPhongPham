<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page import="java.lang.Math" %> <%-- BẮT BUỘC CÓ DÒNG NÀY --%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>${sanPham.tenSanPham} | Văn Phòng Phẩm 3AE</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/product-detail.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&display=swap" rel="stylesheet">
    </head>
    <body>
        <jsp:include page="_header.jsp" />

        <div class="container product-detail-container my-5">
            <c:if test="${not empty sanPham}">
                <div class="row">
                    <div class="col-lg-6">
                        <div class="main-image-wrapper mb-3">
                            <img src="${pageContext.request.contextPath}${sanPham.hinhAnh}"
                                 id="mainProductImage"
                                 class="img-fluid"
                                 alt="${sanPham.tenSanPham}">
                        </div>
                    </div>

                    <div class="col-lg-6">

                        <div class="product-meta-tags mb-2">
                            <span class="meta-tag">Thương hiệu: <a href="#">3 Anh Em</a></span>
                        </div>

                        <div class="product-meta-tags mb-2">
                            <span class="meta-tag">Mã sản phẩm: ${sanPham.sanPhamId}</span>
                            <c:if test="${sanPham.tonKho > 0}">
                                <span class="meta-tag text-success"><i class="bi bi-check-circle-fill"></i> Còn hàng</span>
                            </c:if>
                            <c:if test="${sanPham.tonKho <= 0}">
                                <span class="meta-tag text-danger"><i class="bi bi-x-circle-fill"></i> Hết hàng</span>
                            </c:if>
                        </div>

                        <h2 class="product-detail-title">${sanPham.tenSanPham}</h2>

                        <div class="product-review-summary mb-3">
                            <c:set var="diemTrungBinh" value="${sanPham.diemTrungBinh}" />
                            <c:set var="tongDanhGia" value="${sanPham.tongDanhGia}" />
                            <c:set var="diemTron" value="${Math.round(diemTrungBinh * 2) / 2.0}" />
                            <span class="rating-stars">
                                <c:forEach begin="1" end="5" var="i">
                                    <c:choose>
                                        <c:when test="${diemTron >= i}"><i class="bi bi-star-fill"></i></c:when>
                                        <c:when test="${diemTron >= (i - 0.5)}"><i class="bi bi-star-half"></i></c:when>
                                        <c:otherwise><i class="bi bi-star"></i></c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </span>
                            <span class="rating-score"><fmt:formatNumber value="${diemTrungBinh}" maxFractionDigits="1"/></span>

                            <a href="#reviews-tab" class="rating-count" id="scrollToReviews">(Xem ${tongDanhGia} đánh giá)</a>

                            <span class="divider">|</span>
                            <span class="sold-count">Đã bán 100+</span>
                        </div>

                        <div class="price-detail-box">
                            <c:set var="giaMoi" value="${sanPham.giaKhuyenMai}" /> 
                            <c:set var="giaCu" value="${sanPham.giaBan}" />

                            <span class="sale-price"><fmt:formatNumber value="${giaMoi}" type="currency" currencySymbol="" minFractionDigits="0"/>₫</span>
                            <span class="old-price"><fmt:formatNumber value="${giaCu}" type="currency" currencySymbol="" minFractionDigits="0"/>₫</span>

                            <c:set var="phanTram" value="${(giaCu - giaMoi) * 100 / giaCu}" />
                            <span class="discount-badge-detail">GIẢM <fmt:formatNumber value="${phanTram / 100}" type="percent" minIntegerDigits="0"/></span>
                        </div>

                        <div class="product-quantity mt-4">
                            <h6 class="option-title">Số lượng:</h6>
                            <div class="quantity-input">
                                <button class="btn btn-qty" id="btnQtyMinus"><i class="bi bi-dash"></i></button>
                                <input type="text" id="qtyInput" value="1" readonly>
                                <button class="btn btn-qty" id="btnQtyPlus"><i class="bi bi-plus"></i></button>
                            </div>
                            <span class="text-muted ms-3 small">(${sanPham.tonKho} sản phẩm có sẵn)</span>
                        </div>

                        <div class="action-buttons mt-4 d-flex gap-3">
                            <form id="formAddToCart" 
                                  action="${pageContext.request.contextPath}/them-gio-hang" 
                                  method="GET" 
                                  style="flex: 1;">
                                <input type="hidden" name="productId" value="${sanPham.sanPhamId}">
                                <input type="hidden" name="quantity" id="formQtyAdd" value="1">
                                <button type="submit" class="btn btn-add-to-cart w-100">
                                    <i class="bi bi-cart-plus-fill"></i> Thêm vào giỏ
                                </button>
                            </form>

                            <form action="thanh-toan" method="POST" style="flex: 1;">
                                <input type="hidden" name="action" value="buyNow">
                                <input type="hidden" name="productId" value="${sanPham.sanPhamId}">
                                <input type="hidden" name="quantity" id="formQtyBuy" value="1">
                                <button type="submit" class="btn btn-buy-now w-100">
                                    Mua ngay
                                </button>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="row mt-5">
                    <div class="col-12">
                        <div class="product-tabs">
                            <!-- Tabs -->
                            <ul class="nav nav-tabs" id="myTab" role="tablist">
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link active" id="description-tab" data-bs-toggle="tab" data-bs-target="#description" type="button" role="tab" aria-controls="description" aria-selected="true">
                                        Mô Tả Sản Phẩm
                                    </button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link" id="reviews-tab" data-bs-toggle="tab" data-bs-target="#reviews" type="button" role="tab" aria-controls="reviews" aria-selected="false">
                                        Đánh Giá (${sanPham.tongDanhGia})
                                    </button>
                                </li>
                            </ul>

                            <!-- Nội dung từng tab -->
                            <div class="tab-content" id="myTabContent">
                                <!-- TAB MÔ TẢ -->
                                <div class="tab-pane fade show active" id="description" role="tabpanel" aria-labelledby="description-tab">
                                    <div class="tab-pane-content">
                                        <p>${sanPham.moTa}</p>
                                    </div>
                                </div>

                                <!-- TAB ĐÁNH GIÁ -->
                                <div class="tab-pane fade" id="reviews" role="tabpanel" aria-labelledby="reviews-tab">
                                    <div class="tab-pane-content">

                                        <!-- DANH SÁCH ĐÁNH GIÁ -->
                                        <c:choose>
                                            <c:when test="${empty sanPham.listDanhGia}">
                                                <p class="text-center text-muted">Chưa có đánh giá nào cho sản phẩm này.</p>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="reviews-list mb-4">
                                                    <c:forEach var="dg" items="${sanPham.listDanhGia}">
                                                        <div class="review-item border-bottom pb-3 mb-3">
                                                            <div class="d-flex justify-content-between align-items-center">
                                                                <strong>Khách hàng #${dg.khachHangId}</strong>
                                                                <small class="text-muted">
                                                                    <fmt:formatDate value="${dg.ngayDanhGia}" pattern="dd-MM-yyyy HH:mm"/>
                                                                </small>
                                                            </div>
                                                            <div class="rating-stars my-1">
                                                                <c:forEach begin="1" end="5" var="i">
                                                                    <i class="bi ${i <= dg.diem ? 'bi-star-fill text-warning' : 'bi-star text-secondary'}"></i>
                                                                </c:forEach>
                                                            </div>
                                                            <p class="mb-0">${dg.noiDung}</p>
                                                        </div>
                                                    </c:forEach>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>

                                        <!-- FORM GỬI ĐÁNH GIÁ -->
                                        <div class="review-form-wrapper mt-4">
                                            <h5 class="mb-3">Gửi đánh giá của bạn</h5>

                                            <c:if test="${empty authUser}">
                                                <div class="alert alert-warning" role="alert">
                                                    Vui lòng <a href="dang-nhap?redirect=chi-tiet-san-pham?productId=${sanPham.sanPhamId}" class="alert-link">đăng nhập</a> để gửi đánh giá.
                                                </div>
                                            </c:if>

                                            <c:if test="${not empty authUser}">
                                                <form action="danh-gia" method="POST" class="p-3 border rounded bg-light">
                                                    <input type="hidden" name="productId" value="${sanPham.sanPhamId}">

                                                    <!-- Dòng sao -->
                                                    <div class="mb-3 d-flex align-items-center gap-2">
                                                        <label class="form-label mb-0">Đánh giá của bạn:</label>
                                                        <div class="rating-stars-input">
                                                            <input type="radio" id="star5" name="rating" value="5" required>
                                                            <label for="star5" title="5 sao"></label>

                                                            <input type="radio" id="star4" name="rating" value="4">
                                                            <label for="star4" title="4 sao"></label>

                                                            <input type="radio" id="star3" name="rating" value="3">
                                                            <label for="star3" title="3 sao"></label>

                                                            <input type="radio" id="star2" name="rating" value="2">
                                                            <label for="star2" title="2 sao"></label>

                                                            <input type="radio" id="star1" name="rating" value="1">
                                                            <label for="star1" title="1 sao"></label>
                                                        </div>
                                                    </div>

                                                    <!-- Nhận xét -->
                                                    <div class="mb-3">
                                                        <label for="comment" class="form-label">Nhận xét (tùy chọn):</label>
                                                        <textarea class="form-control" id="comment" name="comment" rows="4" placeholder="Sản phẩm dùng rất tốt..."></textarea>
                                                    </div>

                                                    <button type="submit" class="btn btn-primary">Gửi đánh giá</button>
                                                </form>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>
            <c:if test="${empty sanPham}">
                <div class="alert alert-danger" role="alert">
                    Không tìm thấy thông tin sản phẩm!
                </div>
            </c:if>
        </div>

        <jsp:include page="_footer.jsp" />          

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/product-detail.js"></script>
    </body>
</html>