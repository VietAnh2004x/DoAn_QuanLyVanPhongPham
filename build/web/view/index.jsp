<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Trang chủ | Văn Phòng Phẩm 3AE</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    </head>
    <body>
        <jsp:include page="_header.jsp" />
        
        <div class="container mt-4">
            <div id="carouselExample" class="carousel slide" data-bs-ride="carousel">
                <div class="carousel-inner">
                    <div class="carousel-item active">
                        <img src="${pageContext.request.contextPath}/assets/image/banner/banner_tonghop.jpg" class="d-block w-100" alt="Banner tổng hợp">
                    </div>
                    <div class="carousel-item">
                        <img src="${pageContext.request.contextPath}/assets/image/banner/banner_tonghop2.jpg" class="d-block w-100" alt="Banner tổng hợp 2">
                    </div>
                    <div class="carousel-item">
                        <img src="${pageContext.request.contextPath}/assets/image/banner/banner_but.jpg" class="d-block w-100" alt="Banner bút">
                    </div>
                    <div class="carousel-item">
                        <img src="${pageContext.request.contextPath}/assets/image/banner/banner_giayin.jpg" class="d-block w-100" alt="Banner giấy in">
                    </div>
                    <div class="carousel-item">
                        <img src="${pageContext.request.contextPath}/assets/image/banner/banner_maytinh.jpg" class="d-block w-100" alt="Banner máy tính">
                    </div>
                    <div class="carousel-item">
                        <img src="${pageContext.request.contextPath}/assets/image/banner/butlong.jpg" class="d-block w-100" alt="Banner bút lông">
                    </div>
                </div>
                <button class="carousel-control-prev" type="button" data-bs-target="#carouselExample" data-bs-slide="prev">
                    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                </button>
                <button class="carousel-control-next" type="button" data-bs-target="#carouselExample" data-bs-slide="next">
                    <span class="carousel-control-next-icon" aria-hidden="true"></span>
                </button>
            </div>
        </div>

        <div class="container mt-4">
            <div class="flash-sale-banner">
                <i class="bi bi-lightning-fill"></i>
                <h2 class="flash-sale-title">FLASH SALE</h2>
                <i class="bi bi-lightning-fill"></i>
            </div>

            <div class="row row-cols-2 row-cols-md-3 row-cols-lg-5 g-3 flash-sale-grid">
                <c:if test="${not empty listFlashSale}">
                    <c:forEach var="sp" items="${listFlashSale}">
                        <c:set var="giaMoi" value="${sp.giaKhuyenMai}" /> 
                        <c:set var="giaCu" value="${sp.giaBan}" />

                        <div class="col">
                            <div class="card h-100 flash-sale-card">
                                <a href="chi-tiet-san-pham?productId=${sp.sanPhamId}">
                                    <img src="${pageContext.request.contextPath}${sp.hinhAnh}" class="card-img-top" alt="${sp.tenSanPham}">
                                </a>
                                <div class="card-body">
                                    <h6 class="card-title product-title">
                                        <a href="chi-tiet-san-pham?productId=${sp.sanPhamId}" class="text-decoration-none text-dark">
                                            ${sp.tenSanPham}
                                        </a>
                                    </h6>
                                    <div class="price-block mt-2">
                                        <span class="sale-price">
                                            <fmt:formatNumber value="${sp.giaKhuyenMai}" type="number" groupingUsed="true" minFractionDigits="0"/>₫
                                        </span>
                                        <span class="discount-badge">
                                            -<fmt:formatNumber value="${sp.phanTramDecimal}" type="percent" minFractionDigits="0"/>
                                        </span>
                                    </div>
                                    <span class="old-price">
                                        <fmt:formatNumber value="${sp.giaBan}" type="number" groupingUsed="true" minFractionDigits="0"/>₫
                                    </span>
                                    <div class="rating-stars mt-2">
                                        <%-- Lấy giá trị trực tiếp từ hàm của SanPham --%>
                                        <c:set var="diemTB" value="${sp.diemTrungBinh}" /> 
                                        <c:set var="tongDG" value="${sp.tongDanhGia}" />

                                        <c:set var="diemTron" value="${Math.round(diemTB * 2) / 2.0}" />

                                        <c:forEach begin="1" end="5" var="i">
                                            <c:choose>
                                                <c:when test="${diemTron >= i}"><i class="bi bi-star-fill"></i></c:when>
                                                <c:when test="${diemTron >= (i - 0.5)}"><i class="bi bi-star-half"></i></c:when>
                                                <c:otherwise><i class="bi bi-star"></i></c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                        <span class="rating-count">(${tongDG})</span>
                                    </div>
                                </div>
                                <div class="card-footer">
                                    <button 
                                        class="btn btn-add-cart w-100 add-to-cart-btn"
                                        data-product-id="${sp.sanPhamId}">
                                        <i class="bi bi-cart-plus"></i> THÊM VÀO GIỎ
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:if>
                <c:if test="${empty listFlashSale}">
                    <div class="col-12">
                        <p class="text-center text-muted">Chưa có sản phẩm Flash Sale nào.</p>
                    </div>
                </c:if>
            </div>
        </div>

        <div class="container mt-5">
            <h3 class="text-center mb-4 text-primary fw-bold">DÀNH CHO BẠN</h3>

            <div class="row row-cols-2 row-cols-md-3 row-cols-lg-5 g-3">
                <c:if test="${not empty listSpecialProducts}">
                    <c:forEach var="sp" items="${listSpecialProducts}">
                        <c:set var="giaMoi" value="${sp.giaKhuyenMai}" />
                        <c:set var="giaCu" value="${sp.giaBan}" />

                        <div class="col">
                            <div class="card h-100 product-card-special">
                                <div class="product-tags">
                                </div>
                                <a href="chi-tiet-san-pham?productId=${sp.sanPhamId}">
                                    <img src="${pageContext.request.contextPath}${sp.hinhAnh}" class="card-img-top" alt="${sp.tenSanPham}">
                                </a>
                                <div class="card-body">
                                    <h6 class="card-title product-title-special">
                                        <a href="chi-tiet-san-pham?productId=${sp.sanPhamId}" class="text-decoration-none text-dark">
                                            ${sp.tenSanPham}
                                        </a>
                                    </h6>
                                    <div class="rating-stars mt-2">
                                        <%-- Lấy giá trị trực tiếp từ hàm của SanPham --%>
                                        <c:set var="diemTB" value="${sp.diemTrungBinh}" /> 
                                        <c:set var="tongDG" value="${sp.tongDanhGia}" />

                                        <c:set var="diemTron" value="${Math.round(diemTB * 2) / 2.0}" />

                                        <c:forEach begin="1" end="5" var="i">
                                            <c:choose>
                                                <c:when test="${diemTron >= i}"><i class="bi bi-star-fill"></i></c:when>
                                                <c:when test="${diemTron >= (i - 0.5)}"><i class="bi bi-star-half"></i></c:when>
                                                <c:otherwise><i class="bi bi-star"></i></c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                        <span class="rating-count">(${tongDG})</span>
                                    </div>
                                    <div class="price-block-special mt-2">
                                        <span class="sale-price">
                                            <fmt:formatNumber value="${sp.giaKhuyenMai}" type="number" groupingUsed="true" minFractionDigits="0"/>₫
                                        </span>

                                        <span class="discount-badge">
                                            -<fmt:formatNumber value="${sp.phanTramDecimal}" type="percent" minFractionDigits="0"/>
                                        </span>
                                    </div>
                                    <div class="old-price-block">
                                        <span class="old-price"><fmt:formatNumber value="${sp.giaBan}" type="currency" currencySymbol="" minFractionDigits="0"/>₫</span>
                                    </div>
                                </div>
                                <div class="card-footer">
                                    <a href="chi-tiet-san-pham?productId=${sp.sanPhamId}" class="btn btn-quick-view w-100">
                                        <i class="bi bi-eye-fill"></i> XEM NHANH
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:if>
                <c:if test="${empty listSpecialProducts}">
                    <div class="col-12">
                        <p class="text-center text-muted">Chưa có sản phẩm nào trong mục này.</p>
                    </div>
                </c:if>
            </div>
        </div>
                    
        <jsp:include page="_footer.jsp" />
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/add-to-cart.css">
        <script src="${pageContext.request.contextPath}/assets/js/add-to-cart.js"></script>
    </body>
</html>