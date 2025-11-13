document.addEventListener('DOMContentLoaded', function () {

    // --- QR Thanh Toán ---
    const checkoutForm = document.querySelector('.shipping-info-wrapper form');
    const continueButton = checkoutForm?.querySelector('.btn-continue');
    const qrModalElement = document.getElementById('qrPaymentModal');
    const qrCanvas = document.getElementById('qrcodeCanvas');
    const qrAmountSpan = document.getElementById('qrAmount');
    const qrContentSpan = document.getElementById('qrContent');
    const btnPaid = qrModalElement ? qrModalElement.querySelector('.btn-success') : null;

    // Tạo đối tượng Modal của Bootstrap
    const qrModal = qrModalElement ? new bootstrap.Modal(qrModalElement) : null;

    if (continueButton && checkoutForm && qrModalElement && qrCanvas && qrAmountSpan && qrContentSpan) {

        // Khi nhấn nút "Tiếp tục đến phương thức thanh toán"
        continueButton.addEventListener('click', function (event) {
            event.preventDefault();

            // Kiểm tra form hợp lệ
            if (!checkoutForm.checkValidity()) {
                checkoutForm.reportValidity();
                return;
            }

            // Lấy tổng tiền (chỉ giữ số)
            const amountText = document.querySelector('.grand-total')
                    .textContent.replace(/[^0-9]/g, '');

            // Tạo mã đơn hàng
            const orderId = "DH" + new Date().getTime();

            // Cập nhật vào giao diện
            qrAmountSpan.textContent = parseInt(amountText).toLocaleString('vi-VN') + '₫';
            qrContentSpan.textContent = orderId;

            // Hiển thị modal
            qrModal.show();
        });

        qrModalElement.addEventListener('shown.bs.modal', function () {
            // --- Thông tin cố định ---
            const bankBin = "970436"; // Vietcombank
            const accountNumber = "1018386755";
            const accountName = "NGUYEN VIET ANH";

            // --- Lấy thông tin đơn hàng ---
            const amountText = document.querySelector('.grand-total')
                    .textContent.replace(/[^0-9]/g, '');
            const orderId = qrContentSpan.textContent;

            // --- Tạo timestamp để tránh cache ---
            const cacheBuster = new Date().getTime();

            // --- Tạo QR chính xác chuẩn VietQR ---
            const qrImageUrl = `https://img.vietqr.io/image/${bankBin}-${accountNumber}-print.png?amount=${amountText}&addInfo=${orderId}&accountName=${encodeURIComponent(accountName)}&t=${cacheBuster}`;

            // --- Gắn trực tiếp QR vào modal ---
            qrCanvas.innerHTML = `
                <div class="text-center">
                    <div class="bg-white p-3 rounded shadow-sm d-inline-block">
                        <img src="${qrImageUrl}" 
                             alt="VietQR" 
                             class="img-fluid" 
                             border-radius:10px;">
                    </div>
                </div>
            `;
        });

        
        if (btnPaid) {
            btnPaid.addEventListener('click', function () {
                const modalBody = qrModalElement.querySelector('.modal-body');

                // Xóa nội dung cũ (ẩn QR)
                modalBody.innerHTML = `
                <div class="text-center py-5">
                    <div class="alert alert-success d-inline-block" role="alert">
                        <i class="bi bi-check-circle-fill"></i>
                        <span class="ms-2">Thanh toán thành công! Cảm ơn bạn ❤️</span>
                    </div>
                </div>`;


                // Đợi 2 giây cho người dùng thấy thông báo
                setTimeout(() => {
                    const bsModal = bootstrap.Modal.getInstance(qrModalElement);
                    if (bsModal)
                        bsModal.hide();
                    
                    checkoutForm.submit();
                }, 2000);
            });
        }
    }
});
