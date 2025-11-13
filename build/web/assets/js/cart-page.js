document.addEventListener('DOMContentLoaded', function () {

    // --- VAT Invoice Checkbox ---
    const vatCheckbox = document.getElementById('vatCheckbox');
    const vatForm = document.getElementById('vatForm');

    if (vatCheckbox && vatForm) {
        vatCheckbox.addEventListener('change', function () {
            vatForm.style.display = this.checked ? 'block' : 'none';
        });
    }

    // --- Quantity Buttons ---
    const quantityInputs = document.querySelectorAll('.qty-input');
    const plusButtons = document.querySelectorAll('.btn-plus');
    const minusButtons = document.querySelectorAll('.btn-minus');

    // 🧩 Hàm cập nhật số lượng lên server
    async function updateCartItemQuantity(itemId, newQuantity) {
        try {
            const res = await fetch('cap-nhat-so-luong', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: `id=${itemId}&soLuong=${newQuantity}`
            });
            const text = await res.text();
            console.log('Server response:', text);

            // Nếu thành công thì reload để cập nhật tổng tiền
            if (text.includes('success')) {
                location.reload();
            } else {
                alert('Cập nhật số lượng thất bại!');
            }
        } catch (err) {
            console.error('Lỗi khi gửi yêu cầu cập nhật:', err);
        }
    }

    // Nút "+"
    plusButtons.forEach(button => {
        button.addEventListener('click', function () {
            const itemId = this.dataset.itemid;
            const input = document.querySelector(`.qty-input[data-itemid="${itemId}"]`);
            if (input) {
                let currentValue = parseInt(input.value);
                if (isNaN(currentValue)) currentValue = 0;
                const newValue = currentValue + 1;
                input.value = newValue;

                // Gửi lên server
                updateCartItemQuantity(itemId, newValue);
            }
        });
    });

    // Nút "-"
    minusButtons.forEach(button => {
        button.addEventListener('click', function () {
            const itemId = this.dataset.itemid;
            const input = document.querySelector(`.qty-input[data-itemid="${itemId}"]`);
            if (input) {
                let currentValue = parseInt(input.value);
                if (isNaN(currentValue) || currentValue <= 1) {
                    input.value = 1;
                    return;
                }
                const newValue = currentValue - 1;
                input.value = newValue;

                // Gửi lên server
                updateCartItemQuantity(itemId, newValue);
            }
        });
    });

    // --- Remove Item Button ---
    const removeButtons = document.querySelectorAll('.btn-remove-item');
    removeButtons.forEach(button => {
        button.addEventListener('click', function () {
            const itemId = this.dataset.itemid;
            if (confirm('Bạn có chắc muốn xóa sản phẩm này khỏi giỏ hàng?')) {
                fetch('xoa-chi-tiet-gio-hang', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: `id=${itemId}`
                }).then(res => res.text())
                  .then(text => {
                      if (text.includes('success')) location.reload();
                      else alert('Xóa sản phẩm thất bại!');
                  });
            }
        });
    });
});
