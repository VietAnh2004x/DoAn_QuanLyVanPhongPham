<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<link rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
<link rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

<style>
    body {
        margin: 0;
        font-family: "Inter", system-ui, sans-serif;
        background: #f3f4f6;
    }

    /* ===== SIDEBAR ===== */
    .sidebar {
        position: fixed;
        top: 0;
        left: 0;
        width: 220px;
        height: 100vh;
        background: linear-gradient(180deg, #0f172a, #020617);
        color: #e5e7eb;
        padding: 0.9rem 0.7rem;
        display: flex;
        flex-direction: column;
        z-index: 1000;
        box-shadow: 4px 0 14px rgba(0,0,0,0.25);
    }

    .sidebar-brand {
        text-align: center;
        margin-bottom: 0.8rem;
    }

    .sidebar-brand i {
        font-size: 1.7rem;
        color: #38bdf8;
    }

    .sidebar-brand h4 {
        margin-top: 0.35rem;
        font-size: 0.95rem;
        font-weight: 700;
        color: #e0f2fe;
    }

    .sidebar hr {
        border-color: #1e293b;
        margin: 0.65rem 0;
    }

    .sidebar .nav-link {
        color: #cbd5e1;
        font-size: 0.85rem;
        padding: 0.5rem 0.7rem;
        border-radius: 8px;
        display: flex;
        align-items: center;
        gap: 10px;
        transition: 0.2s;
    }

    .sidebar .nav-link:hover {
        background: rgba(56,189,248,0.12);
        color: #e0f2fe;
    }

    .sidebar .nav-link.active {
        background: linear-gradient(90deg, #0ea5e9, #38bdf8);
        color: white;
        font-weight: 600;
    }

    .bottom-buttons {
        margin-top: auto;
    }

    .bottom-buttons a {
        display: flex;
        justify-content: center;
        align-items: center;
        gap: 6px;
        font-size: 0.8rem;
        padding: 0.45rem;
        border-radius: 8px;
        font-weight: 600;
    }

    .btn-home {
        border: 1px solid #38bdf8;
        color: #38bdf8;
        background: transparent;
    }

    .btn-home:hover {
        background: #38bdf8;
        color: #020617;
    }

    .btn-logout {
        margin-top: 0.5rem;
        background: #ef4444;
        color: #fff;
        border: none;
    }

    .btn-logout:hover {
        background: #dc2626;
    }

    .sidebar-footer {
        margin-top: 0.6rem;
        text-align: center;
        font-size: 0.7rem;
        color: #94a3b8;
    }
</style>

<div class="sidebar">
    <div class="sidebar-brand">
        <i class="bi bi-shop-window"></i>
        <h4>Văn Phòng Phẩm 3AE</h4>
    </div>

    <hr>

    <ul class="nav flex-column">
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin"
               class="nav-link ${page eq 'dashboard' ? 'active' : ''}">
                <i class="bi bi-speedometer2"></i> Tổng quan
            </a>
        </li>

        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/san-pham"
               class="nav-link ${page eq 'sanpham' ? 'active' : ''}">
                <i class="bi bi-box-seam"></i> Sản phẩm
            </a>
        </li>

        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/danh-gia"
               class="nav-link ${page eq 'danhgia' ? 'active' : ''}">
                <i class="bi bi-star-fill"></i> Đánh giá
            </a>
        </li>

        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/nguoi-dung"
               class="nav-link ${page eq 'nguoidung' ? 'active' : ''}">
                <i class="bi bi-people"></i> Người dùng
            </a>
        </li>

        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/don-hang"
               class="nav-link ${page eq 'donhang' ? 'active' : ''}">
                <i class="bi bi-receipt"></i> Đơn hàng
            </a>
        </li>
    </ul>

    <hr>

    <div class="bottom-buttons">
        <a href="${pageContext.request.contextPath}/Home" class="btn btn-home">
            <i class="bi bi-house-door"></i> Về trang chủ
        </a>
        <a href="${pageContext.request.contextPath}/dang-xuat" class="btn btn-logout">
            <i class="bi bi-box-arrow-right"></i> Đăng xuất
        </a>
    </div>

    <div class="sidebar-footer">
        © 2025 Văn Phòng Phẩm 3AE
    </div>
</div>
