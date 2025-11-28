<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- ======================== ADMIN SIDEBAR LAYOUT ========================= -->

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

<style>
    /* Sidebar */
    .sidebar {
        position: fixed;
        top: 0; left: 0;
        width: 250px;
        height: 100vh;
        background-color: #343a40;
        color: white;
        padding: 1.5rem 1rem;
        display: flex;
        flex-direction: column;
        z-index: 1000;
    }

    .sidebar h4 {
        text-align: center;
        font-weight: 600;
    }

    .sidebar hr {
        border-color: #565e64;
    }

    .sidebar .nav-link {
        color: #adb5bd;
        font-size: 1.1rem;
        padding: 0.75rem 1rem;
        border-radius: 8px;
        transition: 0.2s;
    }

    .sidebar .nav-link:hover {
        background-color: #495057;
        color: #fff;
    }

    .sidebar .nav-link.active {
        background-color: #495057;
        color: #fff;
        font-weight: 600;
    }

    .sidebar .bi {
        margin-right: 12px;
        font-size: 1.2rem;
    }

    /* Buttons */
    .sidebar .bottom-buttons a {
        display: block;
        width: 100%;
        margin-bottom: 0.75rem;
    }

    .sidebar-footer {
        margin-top: auto;
        text-align: center;
        color: #adb5bd;
        font-size: 0.85rem;
    }

    /* Main content offset */
    .main-content {
        margin-left: 250px;
        padding: 2rem;
    }
</style>

<!-- SIDEBAR -->
<div class="sidebar">
    <h4 class="mb-3">Admin Dashboard</h4>
    <hr>

    <ul class="nav flex-column mb-4">
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin"
               class="nav-link ${page eq 'dashboard' ? 'active' : ''}">
                <i class="bi bi-speedometer2"></i> Bảng điều khiển
            </a>
        </li>

        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/san-pham"
               class="nav-link ${page eq 'sanpham' ? 'active' : ''}">
                <i class="bi bi-box-seam"></i> Quản lý sản phẩm
            </a>
        </li>

        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/nguoi-dung"
               class="nav-link ${page eq 'nguoidung' ? 'active' : ''}">
                <i class="bi bi-people"></i> Quản lý người dùng
            </a>
        </li>

        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/don-hang"
               class="nav-link ${page eq 'donhang' ? 'active' : ''}">
                <i class="bi bi-receipt"></i> Quản lý đơn hàng
            </a>
        </li>
    </ul>

    <hr>

    <div class="bottom-buttons">
        <a href="${pageContext.request.contextPath}/Home" class="btn btn-outline-light">
            <i class="bi bi-house-door"></i> Trang chủ
        </a>

        <a href="${pageContext.request.contextPath}/dang-xuat" class="btn btn-danger">
            <i class="bi bi-box-arrow-right"></i> Đăng xuất
        </a>
    </div>

    <div class="sidebar-footer mt-3">
        © Văn Phòng Phẩm 3AE
    </div>
</div>
