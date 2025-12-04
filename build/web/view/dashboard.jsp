<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Dashboard | Văn Phòng Phẩm 3AE</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

    <style>
        body {
            margin: 0;
            background: #f3f4f6;
            font-family: Inter, system-ui, sans-serif;
            font-size: 13px;
            color: #1f2937;
        }

        /* ✅ KHỚP SIDEBAR 220px */
        .main-content {
            margin-left: 220px;
            padding: 20px 24px;
            max-width: calc(100vw - 220px);
        }

        .page-title {
            font-size: 20px;
            font-weight: 700;
            color: #2563eb;
            margin-bottom: 20px;
        }

        /* STAT CARD */
        .stat-card {
            border-radius: 14px;
            border: none;
            transition: .25s;
        }

        .stat-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 25px rgba(0,0,0,.15);
        }

        .stat-card h6 {
            font-size: 13px;
            margin-bottom: 4px;
        }

        .stat-card h2,
        .stat-card h4 {
            margin: 0;
            font-weight: 700;
        }

        .stat-card-icon {
            font-size: 34px;
            opacity: .65;
        }

        /* CARD */
        .card {
            border-radius: 14px;
        }

        .card-header {
            font-size: 14px;
            font-weight: 700;
        }

        table {
            font-size: 12.5px;
        }
    </style>
</head>

<body>

<!-- SIDEBAR -->
<jsp:include page="/view/admin-layout.jsp"/>

<!-- DASHBOARD CONTENT -->
<div class="main-content">

    <h2 class="page-title">
        <i class="bi bi-speedometer2 me-2"></i>Bảng điều khiển quản trị
    </h2>

    <!-- STAT BOX -->
    <div class="row g-3 mb-4">

        <div class="col-xl-3 col-md-6">
            <div class="card stat-card bg-success text-white shadow-sm">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <div>
                        <h6>Sản phẩm</h6>
                        <h2>${tongSP}</h2>
                    </div>
                    <i class="bi bi-box-seam stat-card-icon"></i>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6">
            <div class="card stat-card bg-info text-white shadow-sm">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <div>
                        <h6>Khách hàng</h6>
                        <h2>${tongKH}</h2>
                    </div>
                    <i class="bi bi-people stat-card-icon"></i>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6">
            <div class="card stat-card bg-warning text-dark shadow-sm">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <div>
                        <h6>Đơn hàng</h6>
                        <h2>${tongDH}</h2>
                    </div>
                    <i class="bi bi-cart-check stat-card-icon"></i>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6">
            <div class="card stat-card bg-danger text-white shadow-sm">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <div>
                        <h6>Doanh thu</h6>
                        <h4>
                            <fmt:formatNumber value="${doanhThu}" groupingUsed="true"/> ₫
                        </h4>
                    </div>
                    <i class="bi bi-cash-coin stat-card-icon"></i>
                </div>
            </div>
        </div>

    </div>

    <!-- CHART + TOP -->
    <div class="row g-4">

        <!-- CHART -->
        <div class="col-lg-8">
            <div class="card shadow-sm h-100">
                <div class="card-header bg-primary text-white">
                    <i class="bi bi-bar-chart-line me-2"></i>Doanh thu theo tháng
                </div>
                <div class="card-body">
                    <canvas id="chartDoanhThu" height="120"></canvas>
                </div>
            </div>
        </div>

        <!-- TOP PRODUCT -->
        <div class="col-lg-4">
            <div class="card shadow-sm h-100">
                <div class="card-header bg-success text-white">
                    <i class="bi bi-trophy me-2"></i>Top 5 sản phẩm bán chạy
                </div>

                <div class="card-body p-2">
                    <c:if test="${empty topSanPham}">
                        <p class="text-center text-muted mt-3">Chưa có dữ liệu</p>
                    </c:if>

                    <c:if test="${not empty topSanPham}">
                        <table class="table table-sm table-bordered text-center align-middle">
                            <thead class="table-light">
                            <tr>
                                <th>#</th>
                                <th>Sản phẩm</th>
                                <th>Đã bán</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="sp" items="${topSanPham}" varStatus="i">
                                <tr>
                                    <td>${i.index + 1}</td>
                                    <td>${sp.tenSanPham}</td>
                                    <td>
                                        <span class="badge bg-primary">${sp.soLuongBan}</span>
                                    </td>
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.2.0"></script>

<script>
const ctx = document.getElementById('chartDoanhThu');
const labels = [<c:forEach var="k" items="${doanhThuThang.keySet()}">'${k}',</c:forEach>];
const values = [<c:forEach var="v" items="${doanhThuThang.values()}">${v},</c:forEach>];

new Chart(ctx, {
    type: 'bar',
    data: {
        labels: labels,
        datasets: [{
            data: values,
            backgroundColor: '#3b82f6',
            borderRadius: 8
        }]
    },
    options: {
        responsive: true,
        plugins: {
            legend: { display: false },
            datalabels: {
                anchor: 'end',
                align: 'top',
                formatter: v => v.toLocaleString('vi-VN')
            }
        },
        scales: {
            y: {
                beginAtZero: true,
                ticks: {
                    callback: v => v.toLocaleString('vi-VN') + ' ₫'
                }
            }
        }
    },
    plugins: [ChartDataLabels]
});
</script>
</body>
</html>
