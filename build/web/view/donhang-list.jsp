<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Admin | Quản lý đơn hàng</title>

    <!-- Bootstrap -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <style>
        body {
            background: #f3f4f6;
            font-family: Inter, system-ui, sans-serif;
            font-size: 13px;
            color: #1f2937;
            margin: 0;
        }

        /* ✅ KHỚP VỚI SIDEBAR 220px */
        .content-wrapper {
            margin-left: 220px;
            padding: 20px 24px;
            max-width: calc(100vw - 220px);
        }

        .page-title {
            font-size: 20px;
            font-weight: 700;
            color: #2563eb;
        }

        /* SEARCH */
        .search-box {
            background: #fff;
            padding: 14px;
            border-radius: 12px;
            border: 1px solid #e5e7eb;
            box-shadow: 0 4px 12px rgba(0,0,0,.04);
            margin-bottom: 16px;
        }

        /* TABLE WRAPPER */
        .section-wrapper {
            background: #fff;
            padding: 16px;
            border-radius: 14px;
            border: 1px solid #e5e7eb;
            box-shadow: 0 6px 16px rgba(0,0,0,.05);
        }

        table {
            font-size: 12.5px;
            table-layout: fixed;
        }

        table thead {
            background: #2563eb;
            color: #fff;
        }

        table th, table td {
            padding: 8px;
            vertical-align: middle;
        }

        table tbody tr:hover {
            background: #eff6ff;
        }

        /* TEXT */
        td.address {
            white-space: normal;
            word-break: break-word;
        }

        /* STATUS */
        .status-select {
            font-size: 12px;
            border-radius: 8px;
            font-weight: 600;
        }

        /* VIEW BTN */
        .btn-view {
            background: #3b82f6;
            color: #fff;
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 12px;
            text-decoration: none;
        }

        .btn-view:hover {
            background: #1d4ed8;
            color: #fff;
        }
    </style>
</head>

<body>

<!-- SIDEBAR -->
<jsp:include page="/view/admin-layout.jsp"/>

<!-- CONTENT -->
<div class="content-wrapper">

    <!-- HEADER -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="page-title">
            <i class="fas fa-receipt me-2"></i>Quản lý đơn hàng
        </h2>

        <a href="${pageContext.request.contextPath}/export-excel?type=order"
           class="btn btn-success btn-sm fw-bold">
            <i class="fas fa-file-excel"></i> Xuất Excel
        </a>
    </div>

    <!-- SEARCH -->
    <form method="get"
          action="${pageContext.request.contextPath}/admin/don-hang"
          class="search-box">

        <div class="row g-2">
            <div class="col-md-9">
                <input type="text"
                       name="keyword"
                       class="form-control form-control-sm"
                       placeholder="Tìm theo ID, khách hàng, trạng thái..."
                       value="${param.keyword}">
            </div>

            <div class="col-md-2">
                <button class="btn btn-primary btn-sm w-100 fw-bold">
                    <i class="fas fa-search"></i> Tìm
                </button>
            </div>

            <div class="col-md-1">
                <a href="${pageContext.request.contextPath}/admin/don-hang"
                   class="btn btn-secondary btn-sm w-100">
                    ⟳
                </a>
            </div>
        </div>
    </form>

    <!-- TABLE -->
    <div class="section-wrapper">
        <div class="table-responsive">
            <table class="table table-bordered table-hover align-middle">
                <thead class="text-center">
                <tr>
                    <th style="width:65px">ID</th>
                    <th style="width:150px">Khách</th>
                    <th style="width:120px">Ngày đặt</th>
                    <th>Địa chỉ giao</th>
                    <th style="width:90px">Phí VC</th>
                    <th style="width:110px">Tổng tiền</th>
                    <th style="width:115px">Trạng thái</th>
                    <th style="width:90px">Thao tác</th>
                </tr>
                </thead>

                <tbody>
                <c:if test="${empty list}">
                    <tr>
                        <td colspan="8" class="text-center text-muted py-3">
                            Không có đơn hàng
                        </td>
                    </tr>
                </c:if>

                <c:forEach var="dh" items="${list}">
                    <tr>
                        <td class="text-center fw-bold">${dh.donHangId}</td>
                        <td>${dh.hoTenKhach}</td>
                        <td class="text-center">
                            <fmt:formatDate value="${dh.ngayDat}" pattern="dd/MM/yyyy HH:mm"/>
                        </td>
                        <td class="address">${dh.diaChiGiao}</td>
                        <td class="text-end">
                            <fmt:formatNumber value="${dh.phiVanChuyen}" groupingUsed="true"/> ₫
                        </td>
                        <td class="text-end fw-bold text-danger">
                            <fmt:formatNumber value="${dh.tongTien}" groupingUsed="true"/> ₫
                        </td>
                        <td class="text-center">
                            <form method="post">
                                <input type="hidden" name="donHangId" value="${dh.donHangId}">
                                <select name="trangThai"
                                        class="form-select form-select-sm status-select"
                                        onchange="this.form.submit()">
                                    <option value="Chờ xử lý" ${dh.trangThai=='Chờ xử lý'?'selected':''}>🕒Chờ xử lý</option>
                                    <option value="Đang giao" ${dh.trangThai=='Đang giao'?'selected':''}>🚚Đang giao</option>
                                    <option value="Hoàn tất" ${dh.trangThai=='Hoàn tất'?'selected':''}>✅Hoàn tất</option>
                                    <option value="Đã hủy" ${dh.trangThai=='Đã hủy'?'selected':''}>❌Hủy</option>
                                </select>
                            </form>
                        </td>
                        <td class="text-center">
                            <a class="btn-view"
                               href="${pageContext.request.contextPath}/admin/don-hang?action=view&id=${dh.donHangId}">
                                <i class="fas fa-eye"></i>
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
