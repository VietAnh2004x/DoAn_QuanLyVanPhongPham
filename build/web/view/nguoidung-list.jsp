<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Admin | Quản lý người dùng</title>

    <!-- Bootstrap -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <style>
        body {
            margin: 0;
            font-family: "Inter", system-ui, sans-serif;
            background: #f3f4f6;
            color: #1f2937;
            font-size: 13px;
        }

        /* ===== MAIN (KHỚP SIDEBAR 220px) ===== */
        .main-content {
            margin-left: 220px;
            padding: 18px 22px;
            max-width: calc(100vw - 220px);
        }

        .page-title {
            font-size: 20px;
            font-weight: 700;
            color: #2563eb;
        }

        /* ===== SEARCH ===== */
        .search-box {
            background: #fff;
            padding: 12px 14px;
            border-radius: 12px;
            border: 1px solid #e5e7eb;
            margin-bottom: 14px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.04);
        }

        /* ===== TABLE WRAPPER ===== */
        .section-wrapper {
            background: #fff;
            border-radius: 14px;
            padding: 14px 16px;
            border: 1px solid #e5e7eb;
            box-shadow: 0 6px 14px rgba(0,0,0,0.04);
        }

        /* ===== TABLE ===== */
        table {
            width: 100%;
            table-layout: fixed;
            border-collapse: collapse;
            font-size: 12.5px;
        }

        thead th {
            background: #2563eb;
            color: #fff;
            padding: 8px;
            font-weight: 600;
            text-align: center;
            border-right: 1px solid rgba(255,255,255,0.25);
        }

        thead th:last-child {
            border-right: none;
        }

        tbody td {
            padding: 8px 10px;
            border-bottom: 1px solid #e5e7eb;
            border-right: 1px solid #e5e7eb;
            vertical-align: top;
            line-height: 1.45;
        }

        tbody td:last-child {
            border-right: none;
        }

        tbody tr:hover {
            background: #f8fafc;
        }

        /* ===== TEXT HANDLE ===== */
        td.email,
        td.address {
            white-space: normal;
            word-break: break-word;
        }

        td.center {
            text-align: center;
            white-space: nowrap;
        }

        /* ===== ROLE ===== */
        .badge-admin,
        .badge-user {
            font-size: 11.5px;
            padding: 4px 10px;
            border-radius: 14px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            white-space: nowrap;
        }

        .badge-admin {
            background: #fee2e2;
            color: #b91c1c;
        }

        .badge-user {
            background: #dcfce7;
            color: #166534;
        }
    </style>
</head>

<body>

<!-- SIDEBAR -->
<jsp:include page="/view/admin-layout.jsp"/>

<!-- MAIN -->
<div class="main-content">

    <!-- HEADER -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="page-title">
            <i class="fas fa-users me-2"></i>Quản lý người dùng
        </h2>

        <a href="${pageContext.request.contextPath}/export-excel?type=user"
           class="btn btn-success btn-sm fw-bold">
            <i class="fas fa-file-excel"></i> Xuất Excel
        </a>
    </div>

    <!-- SEARCH -->
    <form action="nguoi-dung" method="get" class="search-box">
        <div class="input-group input-group-sm">
            <input type="text"
                   name="keyword"
                   class="form-control"
                   placeholder="Tìm theo tên, email, SĐT..."
                   value="${param.keyword}">
            <button class="btn btn-primary">
                <i class="fas fa-search"></i> Tìm
            </button>
        </div>
    </form>

    <!-- TABLE -->
    <div class="section-wrapper">
        <div class="table-responsive">
            <table>
                <thead>
                <tr>
                    <th style="width:50px">ID</th>
                    <th style="width:150px">Họ tên</th>
                    <th style="width:210px">Email</th>
                    <th style="width:115px">Điện thoại</th>
                    <th>Địa chỉ</th>
                    <th style="width:105px">Ngày ĐK</th>
                    <th style="width:95px">Vai trò</th>
                </tr>
                </thead>

                <tbody>
                <c:if test="${empty list}">
                    <tr>
                        <td colspan="7" class="text-center text-muted py-3">
                            Không có người dùng nào
                        </td>
                    </tr>
                </c:if>

                <c:forEach var="u" items="${list}">
                    <tr>
                        <td class="center fw-bold">${u.nguoiDungId}</td>
                        <td>${u.hoTen}</td>
                        <td class="email">${u.email}</td>
                        <td class="center">${u.soDienThoai}</td>
                        <td class="address">${u.diaChi}</td>
                        <td class="center">
                            <fmt:formatDate value="${u.ngayDangKy}" pattern="dd/MM/yyyy"/>
                        </td>
                        <td class="center">
                            <c:choose>
                                <c:when test="${u.roleId == 1}">
                                    <span class="badge-admin">
                                        <i class="fas fa-user-shield"></i> Admin
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge-user">
                                        <i class="fas fa-user"></i> Khách
                                    </span>
                                </c:otherwise>
                            </c:choose>
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
