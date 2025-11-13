// ===============================
// JS THÊM SẢN PHẨM VÀO GIỎ HÀNG
// ===============================

document.addEventListener("DOMContentLoaded", function () {
    const addToCartButtons = document.querySelectorAll(".add-to-cart-btn");

    addToCartButtons.forEach(btn => {
        btn.addEventListener("click", function () {
            const productId = this.getAttribute("data-product-id");

            fetch("them-gio-hang?productId=" + productId + "&quantity=1", {
                method: "GET"
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // cập nhật số lượng trên badge
                    const badge = document.getElementById("cartCount");
                    if (badge) {
                        badge.textContent = data.cartCount;
                    }

                    // Hiển thị toast thông báo
                    showToast("✅ Đã thêm vào giỏ hàng!");
                } 
                else if (data.requireLogin) {
                    window.location.href = "view/dangnhap.jsp";
                } 
                else {
                    showToast("❌ " + (data.message || "Có lỗi xảy ra!"), true);
                }
            })
            .catch(err => console.error(err));
        });
    });
});

// ===============================
// Hàm tạo toast thông báo
// ===============================
function showToast(message, isError = false) {
    const toast = document.createElement("div");
    toast.className = "toast-msg";
    if (isError) toast.classList.add("toast-error");
    toast.innerHTML = message;
    document.body.appendChild(toast);
    setTimeout(() => toast.remove(), 2000);
}

