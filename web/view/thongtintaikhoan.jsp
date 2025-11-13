<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Thông tin tài khoản - VPP 3AE</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    </head>
    <body>

        <%-- Tải Header (Đã sửa ở lượt trước) --%>
        <jsp:include page="_header.jsp" /> 

        <div class="container my-5" style="min-height: 60vh;">
            <div class="row">
                <div class="col-md-8 offset-md-2">
                    <h2 class="text-center mb-4 text-primary fw-bold">Thông Tin Cá Nhân</h2>
                    
                    <c:if test="${sessionScope.authUser != null}">
                        <div class="card shadow-sm">
                            <div class="card-body p-4 p-md-5">
                                
                                <%-- === SỬA LỖI 1: Bọc form và thêm action === --%>
                                <form action="${pageContext.request.contextPath}/cap-nhat-thong-tin" method="POST" id="profileForm">
                                    <div class="mb-3">
                                        <label for="hoten" class="form-label fw-bold">Họ và Tên</label>
                                        <%-- Thêm id và class 'form-control-plaintext' --%>
                                        <input type="text" class="form-control" id="hoten" name="hoten" value="${sessionScope.authUser.hoTen}" readonly>
                                    </div>
                                    <div class="mb-3">
                                        <label for="email" class="form-label fw-bold">Email</label>
                                        <%-- Email không bao giờ được sửa --%>
                                        <input type="email" class="form-control-plaintext" id="email" name="email" value="${sessionScope.authUser.email}" readonly>
                                    </div>
                                    <div class="mb-3">
                                        <label for="sodienthoai" class="form-label fw-bold">Số điện thoại</label>
                                        <input type="tel" class="form-control" id="sodienthoai" name="sodienthoai" value="${sessionScope.authUser.soDienThoai}" readonly>
                                    </div>
                                    <div class="mb-3">
                                        <label for="diachi" class="form-label fw-bold">Địa chỉ</label>
                                        <input type="text" class="form-control" id="diachi" name="diachi" value="${sessionScope.authUser.diaChi}" readonly>
                                    </div>
                                    
                                    <%-- === SỬA LỖI 2: Thêm các nút điều khiển === --%>
                                    <div class="text-center mt-4">
                                        <button type="button" class="btn btn-primary" id="btn-edit" onclick="enableEdit()">Chỉnh sửa thông tin</button>
                                        
                                        <%-- Các nút này ban đầu bị ẩn --%>
                                        <button type="submit" class="btn btn-success" id="btn-save" style="display:none;">Lưu thay đổi</button>
                                        <button type="button" class="btn btn-secondary" id="btn-cancel" style="display:none;" onclick="disableEdit()">Hủy</button>
                                    </div>
                                </form>
                                
                            </div>
                        </div>
                    </c:if>

                    <c:if test="${sessionScope.authUser == null}">
                         <div class="alert alert-danger" role="alert">
                             Bạn cần <a href="${pageContext.request.contextPath}/view/dangnhap.jsp">đăng nhập</a> để xem thông tin này.
                         </div>
                    </c:if>
                </div>
            </div>
        </div>

        <%-- Tải Footer (Đã sửa ở lượt trước) --%>
        <jsp:include page="_footer.jsp" />

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        
        <%-- === SỬA LỖI 3: Thêm JavaScript để bật/tắt form === --%>
        <script>
            // Lấy các trường input
            const hoTenInput = document.getElementById('hoten');
            const sdtInput = document.getElementById('sodienthoai');
            const diaChiInput = document.getElementById('diachi');
            
            // Lấy các nút
            const btnEdit = document.getElementById('btn-edit');
            const btnSave = document.getElementById('btn-save');
            const btnCancel = document.getElementById('btn-cancel');

            // Lưu giá trị gốc
            const originalValues = {
                hoten: hoTenInput.value,
                sodienthoai: sdtInput.value,
                diachi: diaChiInput.value
            };

            function enableEdit() {
                // Cho phép sửa
                hoTenInput.readOnly = false;
                sdtInput.readOnly = false;
                diaChiInput.readOnly = false;
                
                // Đổi class để input có viền
                hoTenInput.classList.remove('form-control-plaintext');
                hoTenInput.classList.add('form-control');
                sdtInput.classList.remove('form-control-plaintext');
                sdtInput.classList.add('form-control');
                diaChiInput.classList.remove('form-control-plaintext');
                diaChiInput.classList.add('form-control');

                // Ẩn/Hiện nút
                btnEdit.style.display = 'none';
                btnSave.style.display = 'inline-block';
                btnCancel.style.display = 'inline-block';
            }

            function disableEdit() {
                // Tắt sửa
                hoTenInput.readOnly = true;
                sdtInput.readOnly = true;
                diaChiInput.readOnly = true;
                
                // Trả về giá trị gốc (nếu người dùng đã gõ bậy)
                hoTenInput.value = originalValues.hoten;
                sdtInput.value = originalValues.sodienthoai;
                diaChiInput.value = originalValues.diachi;
                
                // Đổi class về dạng "chỉ đọc"
                hoTenInput.classList.add('form-control-plaintext');
                hoTenInput.classList.remove('form-control');
                sdtInput.classList.add('form-control-plaintext');
                sdtInput.classList.remove('form-control');
                diaChiInput.classList.add('form-control-plaintext');
                diaChiInput.classList.remove('form-control');

                // Ẩn/Hiện nút
                btnEdit.style.display = 'inline-block';
                btnSave.style.display = 'none';
                btnCancel.style.display = 'none';
            }
        </script>
    </body>
</html>