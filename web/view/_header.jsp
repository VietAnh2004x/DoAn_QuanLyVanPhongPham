<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<nav class="navbar navbar-expand-lg navbar-dark bg-primary sticky-top">
    <div class="container-fluid">
        <%-- Link về trang chủ (HomeServlet) --%>
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/trang-chu">
            <img src="${pageContext.request.contextPath}/assets/image/logo.png" alt="Logo"> 3AE
        </a>

        <%-- Form tìm kiếm (trỏ đến SearchServlet) --%>
        <form class="d-flex mx-auto w-50" action="tim-kiem" method="GET">
            <input class="form-control me-2" type="search" name="keyword" placeholder="Tìm kiếm sản phẩm...">
            <button class="btn btn-light" type="submit">
                <i class="bi bi-search"></i>
            </button>
        </form>

        <ul class="navbar-nav ms-auto">
            <c:if test="${sessionScope.authUser == null}">
                <%-- CHƯA ĐĂNG NHẬP --%>
                <li class="nav-item">
                    <a class="nav-link text-white" href="${pageContext.request.contextPath}/view/dangnhap.jsp">Đăng nhập</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link text-white" href="${pageContext.request.contextPath}/view/dangky.jsp">Đăng ký</a>
                </li>
            </c:if>

            <c:if test="${sessionScope.authUser != null}">
                <%-- ĐÃ ĐĂNG NHẬP --%>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle text-white" href="#" id="navbarUserDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="bi bi-person-circle"></i> Chào, ${sessionScope.authUser.hoTen}
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarUserDropdown">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/thong-tin-ca-nhan">Thông tin tài khoản</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/don-hang">Đơn hàng của tôi</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/doi-mat-khau">Đổi mật khẩu</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/dang-xuat">Đăng xuất</a></li>
                    </ul>
                </li>
            </c:if>

            <li class="nav-item">
                <a class="nav-link text-white" href="xem-gio-hang">
                    🛒 Giỏ hàng 
                    <span class="badge bg-danger" id="cartCount">
                        <%
                            model.NguoiDung authUser = (model.NguoiDung) session.getAttribute("authUser");
                            if (authUser != null) {
                                dao.NguoiDungDAO dao = new dao.NguoiDungDAO();
                                out.print(dao.getTongSanPham(authUser.getNguoiDungId()));
                            } else {
                                out.print(0);
                            }
                        %>
                    </span>
                </a>
            </li>
        </ul>
    </div>
</nav>

<nav class="navbar navbar-expand-lg bg-white shadow-sm category-nav-custom">
    <div class="container-fluid">
        <div class="collapse navbar-collapse justify-content-center" id="navbarNavDropdown">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" href="danh-muc?loaiId=1">
                        <i class="bi bi-pen-fill"></i> Bút - Viết
                    </a>
                </li>

                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownVoSach" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="bi bi-journal-bookmark-fill"></i> Sổ - Vở - Sách
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="navbarDropdownVoSach">
                        <li><a class="dropdown-item" href="danh-muc?loaiId=8">Sổ / Vở</a></li>
                        <li><a class="dropdown-item" href="danh-muc?loaiId=7">Sách</a></li>
                        <li><a class="dropdown-item" href="danh-muc?loaiId=6">Nhãn vở</a></li>
                    </ul>
                </li>

                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownHocTap" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="bi bi-rulers"></i> Dụng cụ học tập
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="navbarDropdownHocTap">
                        <li><a class="dropdown-item" href="danh-muc?loaiId=2">Dụng cụ học sinh</a></li>
                        <li><a class="dropdown-item" href="danh-muc?loaiId=5">Hộp bút / Ba lô</a></li>
                    </ul>
                </li>

                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownVanPhong" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="bi bi-folder-fill"></i> Văn phòng phẩm
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="navbarDropdownVanPhong">
                        <li><a class="dropdown-item" href="danh-muc?loaiId=2">Bìa hồ sơ / Bảng viết</a></li>
                        <li><a class="dropdown-item" href="danh-muc?loaiId=4">Giấy in</a></li>
                    </ul>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="danh-muc?loaiId=3">
                        <i class="bi bi-calculator-fill"></i> Máy tính
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>