<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<html>
<head>
    <title>Quản lý đơn hàng</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: "Segoe UI", sans-serif;
        }
        h3 {
            letter-spacing: 0.5px;
        }
        .card-header {
            background: linear-gradient(90deg, #0d6efd, #007bff);
            color: white;
            border-bottom: none;
        }
        .search-box input {
            border-radius: 8px;
            border: 1px solid #ced4da;
            transition: 0.3s;
        }
        .search-box input:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, .25);
        }
        table th, table td {
            vertical-align: middle !important;
        }
        .badge {
            font-size: 0.9rem;
            padding: 0.5em 0.8em;
        }
        .btn-sm {
            padding: 4px 10px;
        }
        .table-hover tbody tr:hover {
            background-color: #f1f7ff;
        }
        .table-dark th {
            background-color: #0d6efd !important;
            color: #fff;
        }
    </style>
</head>

<body>
<div class="container mt-5 mb-4">

    <!-- Header -->
    <div class="card shadow-sm">
        <div class="card-header d-flex justify-content-between align-items-center">
            <div>
                <i class="fas fa-receipt me-2"></i>
                <span class="fw-bold fs-5">Danh sách đơn hàng</span>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/admin" class="btn btn-outline-light btn-sm">
                    <i class="fas fa-tachometer-alt me-1"></i> Về Dashboard
                </a>
            </div>
        </div>

        <div class="card-body">

            <!-- Form tìm kiếm -->
            <form action="${pageContext.request.contextPath}/admin/don-hang" method="get" class="d-flex mb-3 search-box">
                <input type="text" name="keyword" class="form-control me-2"
                       placeholder="🔍 Tìm theo ID, tên khách hoặc trạng thái..."
                       value="${keyword != null ? keyword : ''}">
                <button type="submit" class="btn btn-primary me-2">
                    <i class="fas fa-search"></i> Tìm
                </button>
                <a href="${pageContext.request.contextPath}/admin/don-hang" class="btn btn-secondary">
                    <i class="fas fa-sync"></i> Làm mới
                </a>
            </form>

            <!-- Thông báo lỗi -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <!-- Bảng danh sách đơn hàng -->
            <div class="table-responsive">
                <table class="table table-bordered table-hover align-middle shadow-sm bg-white">
                    <thead class="table-dark text-center">
                        <tr>
                            <th>ID</th>
                            <th>Khách hàng</th>
                            <th>Ngày đặt</th>
                            <th>Địa chỉ giao</th>
                            <th>Phí vận chuyển</th>
                            <th>Tổng tiền</th>
                            <th>Trạng thái</th>
                            <th style="width: 120px;">Thao tác</th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:forEach var="dh" items="${list}">
                            <tr>
                                <td class="text-center fw-bold">${dh.donHangId}</td>
                                <td>${dh.hoTenKhach}</td>
                                <td class="text-center">
                                    <fmt:formatDate value="${dh.ngayDat}" pattern="dd/MM/yyyy HH:mm"/>
                                </td>
                                <td>${dh.diaChiGiao}</td>
                                <td class="text-end text-secondary">
                                    <fmt:formatNumber value="${dh.phiVanChuyen}" type="number" pattern="#,##0 ₫"/>
                                </td>
                                <td class="text-end fw-bold text-danger">
                                    <fmt:formatNumber value="${dh.tongTien}" type="number" pattern="#,##0 ₫"/>
                                </td>

                                <!-- Cập nhật trạng thái -->
                                <td class="text-center">
                                    <form action="${pageContext.request.contextPath}/admin/don-hang" method="post" class="d-inline">
                                        <input type="hidden" name="donHangId" value="${dh.donHangId}">
                                        <select name="trangThai" class="form-select form-select-sm d-inline w-auto fw-semibold text-center"
                                                style="min-width:150px;"
                                                onchange="this.form.submit()">
                                            <option value="Chờ xử lý" ${dh.trangThai == 'Chờ xử lý' ? 'selected' : ''}>🕒 Chờ xử lý</option>
                                            <option value="Đang giao" ${dh.trangThai == 'Đang giao' ? 'selected' : ''}>🚚 Đang giao</option>
                                            <option value="Hoàn tất" ${dh.trangThai == 'Hoàn tất' ? 'selected' : ''}>✅ Hoàn tất</option>
                                            <option value="Đã hủy" ${dh.trangThai == 'Đã hủy' ? 'selected' : ''}>❌ Đã hủy</option>
                                        </select>
                                    </form>
                                </td>

                                <!-- Nút xem chi tiết -->
                                <td class="text-center">
                                    <a href="${pageContext.request.contextPath}/admin/don-hang?action=view&id=${dh.donHangId}" 
                                       class="btn btn-sm btn-primary">
                                        <i class="fas fa-eye"></i> Xem
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Khi không có đơn hàng -->
            <c:if test="${empty list}">
                <div class="alert alert-info text-center mt-3">
                    <i class="fas fa-info-circle me-1"></i> Chưa có đơn hàng nào trong hệ thống.
                </div>
            </c:if>
        </div>
    </div>
</div>

<!-- Toast thông báo -->
<script>
    if (window.location.href.includes("updated=true")) {
        const toast = document.createElement("div");
        toast.textContent = "✅ Cập nhật trạng thái thành công!";
        toast.style.position = "fixed";
        toast.style.bottom = "20px";
        toast.style.right = "20px";
        toast.style.background = "#198754";
        toast.style.color = "white";
        toast.style.padding = "10px 20px";
        toast.style.borderRadius = "8px";
        toast.style.zIndex = "9999";
        document.body.appendChild(toast);
        setTimeout(() => toast.remove(), 2500);
    }
</script>

</body>
</html>
