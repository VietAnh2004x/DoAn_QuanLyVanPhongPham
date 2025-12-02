<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<html>
    <head>
        <title>Quản lý đơn hàng</title>

        <!-- Bootstrap -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">

        <!-- Icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

        <style>
            body {
                background: #f3f4f6;
                font-family: "Inter", sans-serif;
            }

            /* MAIN CONTENT SHIFT */
            .main-content {
                margin-left: 250px;
                padding: 2rem;
            }

            /* PAGE TITLE */
            .page-title {
                font-size: 26px;
                font-weight: 700;
                color: #2563eb;
            }

            /* SEARCH BOX */
            .search-box {
                background: white;
                padding: 20px;
                border-radius: 16px;
                border: 1px solid #e5e7eb;
                box-shadow: 0 6px 20px rgba(0,0,0,0.05);
                margin-bottom: 20px;
            }
            .search-box input {
                border-radius: 10px;
                border: 1px solid #cbd5e1;
            }
            .search-box button {
                border-radius: 10px;
                background: #2563eb;
                border: none;
                padding: 10px 18px;
                font-weight: 600;
                color: white;
            }
            .search-box button:hover {
                background: #1d4ed8;
            }

            .btn-refresh {
                border-radius: 10px;
                font-weight: 600;
                background: #6b7280;
                color: white;
                padding: 10px 18px;
            }
            .btn-refresh:hover {
                background: #4b5563;
            }

            /* WRAPPER */
            .section-wrapper {
                background: white;
                border-radius: 16px;
                padding: 24px;
                border: 1px solid #e5e7eb;
                box-shadow: 0 6px 20px rgba(0,0,0,0.06);
            }

            /* TABLE */
            table thead {
                background: #2563eb;
                color: white;
            }
            table tbody tr:hover {
                background: #eff6ff;
            }

            /* STATUS BADGES */
            .status-select {
                font-weight: 600;
                border-radius: 10px !important;
                text-align: center;
            }

            /* BUTTON VIEW */
            .btn-view {
                background: #3b82f6;
                border: none;
                padding: 6px 12px;
                color: white;
                border-radius: 8px;
                font-size: 0.85rem;
            }
            .btn-view:hover {
                background: #1d4ed8;
            }
        </style>
    </head>

    <body>

        <!-- SIDEBAR -->
        <jsp:include page="/view/admin-layout.jsp"/>

        <!-- MAIN -->
        <div class="main-content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="page-title m-0">
                    <i class="fas fa-receipt me-2"></i> Danh sách đơn hàng
                </h2>  

                <a href="${pageContext.request.contextPath}/export-excel?type=order" 
                   class="btn btn-success fw-bold px-3 py-2"
                   style="border-radius: 10px;">
                    <i class="fa fa-file-excel-o me-1"></i> Xuất Excel
                </a>
            </div>


            <!-- SEARCH BOX -->
            <form action="${pageContext.request.contextPath}/admin/don-hang"
                  method="get" class="search-box d-flex">

                <input type="text" name="keyword"
                       class="form-control me-3"
                       placeholder="🔍 Tìm theo ID, tên khách, trạng thái..."
                       value="${param.keyword}"/>

                <button type="submit">
                    <i class="fas fa-search me-1"></i> Tìm
                </button>

                <a href="${pageContext.request.contextPath}/admin/don-hang"
                   class="btn-refresh ms-2">
                    <i class="fas fa-sync-alt me-1"></i> Làm mới
                </a>
            </form>

            <!-- SECTION WRAPPER -->
            <div class="section-wrapper">

                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>

                <div class="table-responsive">
                    <table class="table table-bordered table-hover align-middle">
                        <thead class="text-center">
                            <tr>
                                <th>ID</th>
                                <th>Khách hàng</th>
                                <th>Ngày đặt</th>
                                <th>Địa chỉ giao</th>
                                <th>Phí vận chuyển</th>
                                <th>Tổng tiền</th>
                                <th>Trạng thái</th>
                                <th>Thao tác</th>
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
                                        <fmt:formatNumber value="${dh.phiVanChuyen}" type="number"/> ₫
                                    </td>

                                    <td class="text-end fw-bold text-danger">
                                        <fmt:formatNumber value="${dh.tongTien}" type="number"/> ₫
                                    </td>

                                    <td class="text-center">
                                        <form method="post">
                                            <input type="hidden" name="donHangId" value="${dh.donHangId}"/>

                                            <select name="trangThai"
                                                    class="form-select form-select-sm status-select"
                                                    onchange="this.form.submit()">

                                                <option value="Chờ xử lý" ${dh.trangThai == 'Chờ xử lý' ? 'selected' : ''}>🕒 Chờ xử lý</option>
                                                <option value="Đang giao" ${dh.trangThai == 'Đang giao' ? 'selected' : ''}>🚚 Đang giao</option>
                                                <option value="Hoàn tất" ${dh.trangThai == 'Hoàn tất' ? 'selected' : ''}>✅ Hoàn tất</option>
                                                <option value="Đã hủy" ${dh.trangThai == 'Đã hủy' ? 'selected' : ''}>❌ Đã hủy</option>

                                            </select>
                                        </form>
                                    </td>

                                    <td class="text-center">
                                        <a href="${pageContext.request.contextPath}/admin/don-hang?action=view&id=${dh.donHangId}"
                                           class="btn-view">
                                            <i class="fas fa-eye"></i> Xem
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <c:if test="${empty list}">
                    <div class="alert alert-info text-center mt-3">
                        Không có đơn hàng nào.
                    </div>
                </c:if>
            </div>
        </div>
    </body>
</html>
