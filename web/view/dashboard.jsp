<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard | Văn Phòng Phẩm</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

    <style>
        body { background-color: #f8f9fa; }

        /* Sidebar */
        .sidebar {
            position: fixed;
            top: 0; left: 0;
            height: 100vh;
            width: 250px;
            background-color: #343a40;
            color: white;
            padding-top: 1.5rem;
        }
        .sidebar .nav-link {
            color: #adb5bd;
            font-size: 1.1rem;
            padding: 0.75rem 1.5rem;
        }
        .sidebar .nav-link:hover, .sidebar .nav-link.active {
            color: #fff;
            background-color: #495057;
        }
        .sidebar .nav-link .bi { margin-right: 12px; }

        .main-content { margin-left: 250px; padding: 2rem; }

        .stat-card {
            border: none; border-radius: 0.75rem;
            transition: transform 0.2s ease-in-out;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 0.5rem 1rem rgba(0,0,0,.15)!important;
        }
        .stat-card .card-body {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .stat-card-icon { font-size: 3rem; opacity: 0.7; }

        .sidebar .bottom-buttons {
            margin-top: auto;
            padding: 1rem;
            text-align: center;
        }
        .sidebar .bottom-buttons a {
            display: block;
            margin-bottom: 0.5rem;
        }
    </style>
</head>
<body>

<!-- Sidebar -->
<div class="sidebar d-flex flex-column p-3">
    <h4 class="text-center mb-4">Admin Dashboard</h4>
    <hr class="text-secondary">
    <ul class="nav nav-pills flex-column mb-auto">
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin" class="nav-link active">
                <i class="bi bi-speedometer2"></i> Bảng điều khiển
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/san-pham" class="nav-link">
                <i class="bi bi-box-seam"></i> Quản lý sản phẩm
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/nguoi-dung" class="nav-link">
                <i class="bi bi-people"></i> Quản lý người dùng
            </a>
        </li>
        <li>
            <a href="${pageContext.request.contextPath}/admin/don-hang" class="nav-link">
                <i class="bi bi-receipt"></i> Quản lý đơn hàng
            </a>
        </li>
    </ul>

    <hr>
    <div class="bottom-buttons mt-auto">
        <a href="${pageContext.request.contextPath}/Home" class="btn btn-outline-light w-100 mb-2">
            <i class="bi bi-house-door"></i> Trang chủ
        </a>
        <a href="${pageContext.request.contextPath}/dang-xuat" class="btn btn-danger w-100">
            <i class="bi bi-box-arrow-right"></i> Đăng xuất
        </a>
        <div class="text-center text-muted small mt-3">
            Văn Phòng Phẩm 3AE
        </div>
    </div>
</div>

<!-- Main -->
<main class="main-content">
    <div class="container-fluid">
        <h2 class="mb-4 text-primary">Bảng điều khiển quản trị</h2>

        <!-- Thống kê nhanh -->
        <div class="row g-4 mb-5">
            <div class="col-lg-3 col-md-6">
                <div class="card stat-card shadow-sm bg-success text-white">
                    <div class="card-body">
                        <div>
                            <h5>Sản phẩm</h5>
                            <h2 class="fw-bold">${tongSP}</h2>
                        </div>
                        <i class="bi bi-box-seam stat-card-icon"></i>
                    </div>
                </div>
            </div>

            <div class="col-lg-3 col-md-6">
                <div class="card stat-card shadow-sm bg-info text-white">
                    <div class="card-body">
                        <div>
                            <h5>Khách hàng</h5>
                            <h2 class="fw-bold">${tongKH}</h2>
                        </div>
                        <i class="bi bi-people stat-card-icon"></i>
                    </div>
                </div>
            </div>

            <div class="col-lg-3 col-md-6">
                <div class="card stat-card shadow-sm bg-warning text-dark">
                    <div class="card-body">
                        <div>
                            <h5>Đơn hàng</h5>
                            <h2 class="fw-bold">${tongDH}</h2>
                        </div>
                        <i class="bi bi-cart-check stat-card-icon"></i>
                    </div>
                </div>
            </div>

            <div class="col-lg-3 col-md-6">
                <div class="card stat-card shadow-sm bg-danger text-white">
                    <div class="card-body">
                        <div>
                            <h5>Doanh thu</h5>
                            <h3 class="fw-bold">
                                <fmt:formatNumber value="${doanhThu}" type="number" groupingUsed="true"/> ₫
                            </h3>
                        </div>
                        <i class="bi bi-cash-coin stat-card-icon"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Biểu đồ & Top sản phẩm -->
        <div class="row">
            <!-- Biểu đồ -->
            <div class="col-md-8">
                <div class="card shadow-sm">
                    <div class="card-header bg-primary text-white fw-bold">
                        <i class="bi bi-bar-chart-line me-2"></i> Biểu đồ doanh thu theo tháng
                    </div>
                    <div class="card-body" style="height: 360px;">
                        <canvas id="chartDoanhThu"></canvas>
                    </div>
                </div>
            </div>

            <!-- Top 5 sản phẩm -->
            <div class="col-md-4">
                <div class="card shadow-sm">
                    <div class="card-header bg-success text-white fw-bold">
                        <i class="bi bi-trophy me-2"></i> Top 5 sản phẩm bán chạy
                    </div>
                    <div class="card-body">
                        <c:if test="${empty topSanPham}">
                            <p class="text-center text-muted">Chưa có dữ liệu thống kê.</p>
                        </c:if>
                        <c:if test="${not empty topSanPham}">
                            <table class="table table-sm table-bordered align-middle text-center">
                                <thead class="table-light">
                                    <tr>
                                        <th>#</th>
                                        <th>Tên sản phẩm</th>
                                        <th>Đã bán</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="sp" items="${topSanPham}" varStatus="loop">
                                        <tr>
                                            <td>${loop.index + 1}</td>
                                            <td>${sp.tenSanPham}</td>
                                            <td><span class="badge bg-primary">${sp.soLuongBan}</span></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.2.0"></script>
<script>
const ctx = document.getElementById('chartDoanhThu');
const labels = [<c:forEach var="k" items="${doanhThuThang.keySet()}">'${k}',</c:forEach>];
const values = [<c:forEach var="v" items="${doanhThuThang.values()}">${v},</c:forEach>];

// Gradient màu xanh
const gradient = ctx.getContext('2d').createLinearGradient(0, 0, 0, 400);
gradient.addColorStop(0, '#007bff');
gradient.addColorStop(1, '#80bdff');

new Chart(ctx, {
  type: 'bar',
  data: {
    labels: labels,
    datasets: [{
      label: 'Doanh thu (VNĐ)',
      data: values,
      backgroundColor: gradient,
      borderRadius: 10,
      hoverBackgroundColor: '#0056b3'
    }]
  },
  options: {
    responsive: true,
    plugins: {
      legend: { display: false },
      datalabels: {
        anchor: 'end', align: 'top', color: '#000',
        font: { weight: 'bold' },
        formatter: (v) => v.toLocaleString('vi-VN')
      }
    },
    scales: {
      y: {
        beginAtZero: true,
        ticks: {
          callback: (v) => v.toLocaleString('vi-VN') + ' ₫',
          color: '#555'
        },
        grid: { color: '#e9ecef' }
      },
      x: { grid: { display: false }, ticks: { color: '#333' } }
    }
  },
  plugins: [ChartDataLabels]
});
</script>
</body>
</html>
