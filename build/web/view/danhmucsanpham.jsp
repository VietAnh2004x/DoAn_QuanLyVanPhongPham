<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page import="java.lang.Math" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>${tenDanhMuc} | Văn Phòng Phẩm 3AE</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/category-page.css">

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700&display=swap" rel="stylesheet">
    </head>
    <body>
        <jsp:include page="_header.jsp" />

        <div class="container category-container my-4">
            <nav aria-label="breadcrumb" class="mb-4">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/trang-chu">Trang chủ</a></li>
                    <li class="breadcrumb-item active" aria-current="page">${tenDanhMuc}</li>
                </ol>
            </nav>

            <div class="row">
                <div class="col-lg-3">
                    <div class="filter-sidebar">
                        <h5 class="filter-title">LỌC SẢN PHẨM</h5>
                        <%-- 
                          Kiểm tra xem đây là trang DANH MỤC hay trang TÌM KIẾM
                          để trỏ action của form cho đúng.
                        --%>
                        <c:set var="formAction" value="danh-muc" />
                        <c:if test="${not empty param.keyword}">
                            <c:set var="formAction" value="tim-kiem" />
                        </c:if>

                        <form action="${formAction}" method="GET">

                            <%-- Giữ lại tham số (loaiId HOẶC keyword) --%>
                            <c:if test="${not empty param.loaiId}">
                                <input type="hidden" name="loaiId" value="${param.loaiId}">
                            </c:if>
                            <c:if test="${not empty param.keyword}">
                                <input type="hidden" name="keyword" value="${param.keyword}">
                            </c:if>

                            <%-- Giữ lại sắp xếp (nếu có) --%>
                            <c:if test="${not empty param.sort}">
                                <input type="hidden" name="sort" value="${param.sort}">
                            </c:if>

                            <div class="filter-section">
                                <h6>Mức giá</h6>
                                <ul class="list-unstyled filter-list">
                                    <li>
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="priceRange" value="0-50000" id="priceRadio1"
                                                   <c:if test="${selectedPriceRange == '0-50000'}">checked</c:if> >
                                                   <label class="form-check-label" for="priceRadio1">Dưới 50.000đ</label>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="priceRange" value="50000-100000" id="priceRadio2"
                                                <c:if test="${selectedPriceRange == '50000-100000'}">checked</c:if> >
                                                <label class="form-check-label" for="priceRadio2">50.000đ - 100.000đ</label>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="priceRange" value="100000-200000" id="priceRadio3"
                                                <c:if test="${selectedPriceRange == '100000-200000'}">checked</c:if> >
                                                <label class="form-check-label" for="priceRadio3">100.000đ - 200.000đ</label>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="priceRange" value="200000-500000" id="priceRadio4"
                                                <c:if test="${selectedPriceRange == '200000-500000'}">checked</c:if> >
                                                <label class="form-check-label" for="priceRadio4">200.000đ - 500.000đ</label>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="form-check">
                                                <input class="form-check-input" type="radio" name="priceRange" value="500000-max" id="priceRadio5"
                                                <c:if test="${selectedPriceRange == '500000-max'}">checked</c:if> >
                                                <label class="form-check-label" for="priceRadio5">Trên 500.000đ</label>
                                            </div>
                                        </li>
                                    </ul>
                                </div>

                                <button type="submit" class="btn btn-primary w-100 mt-3">Áp dụng</button>
                            </form>
                        </div>
                    </div>

                    <div class="col-lg-9">

                    <c:if test="${not empty bannerFile}">
                        <img src="${pageContext.request.contextPath}/assets/image/banner/${bannerFile}"
                             class="img-fluid category-banner mb-4" alt="Banner ${tenDanhMuc}">
                    </c:if>

                    <h1 class="category-title">${tenDanhMuc}</h1>

                    <div class="sorting-options d-flex align-items-center mb-3">
                        <span>Sắp xếp:</span>
                        <%-- Tạo URL cơ sở (giữ lại loaiId HOẶC keyword) --%>
                        <c:set var="baseUrl" value="${formAction}?" />
                        <c:if test="${not empty param.loaiId}"><c:set var="baseUrl" value="${baseUrl}loaiId=${param.loaiId}&"/></c:if>
                        <c:if test="${not empty param.keyword}"><c:set var="baseUrl" value="${baseUrl}keyword=${param.keyword}&"/></c:if>

                        <%-- Giữ lại priceRange (nếu có) khi sắp xếp --%>
                        <c:if test="${not empty selectedPriceRange}">
                            <c:set var="baseUrl" value="${baseUrl}priceRange=${selectedPriceRange}&" />
                        </c:if>

                        <a href="${baseUrl}sort=popular" class="btn btn-sort ${sortMode == 'popular' ? 'active' : ''}">Phổ biến</a>
                        <a href="${baseUrl}sort=newest" class="btn btn-sort ${sortMode == 'newest' ? 'active' : ''}">Mới nhất</a>
                        <a href="${baseUrl}sort=price_asc" class="btn btn-sort ${sortMode == 'price_asc' ? 'active' : ''}">Giá tăng dần</a>
                        <a href="${baseUrl}sort=price_desc" class="btn btn-sort ${sortMode == 'price_desc' ? 'active' : ''}">Giá giảm dần</a>
                    </div>

                    <div class="row row-cols-2 row-cols-md-3 row-cols-lg-4 g-3">
                        <c:if test="${not empty listSanPhamTheoDanhMuc}">
                            <c:forEach var="sp" items="${listSanPhamTheoDanhMuc}">
                                <%-- (Code card sản phẩm của bạn...) --%>
                                <c:set var="giaMoi" value="${sp.giaKhuyenMai}" /> 
                                <c:set var="giaCu" value="${sp.giaBan}" />
                                <div class="col">
                                    <div class="card h-100 product-card-special"> 
                                        <div class="product-tags"></div>
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
                        <c:if test="${empty listSanPhamTheoDanhMuc}">
                            <div class="col-12">
                                <p class="text-center text-muted mt-4">Không tìm thấy sản phẩm nào khớp.</p>
                            </div>
                        </c:if>
                    </div>
                </div> 
            </div> 
        </div> 

        <jsp:include page="_footer.jsp" />  
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>