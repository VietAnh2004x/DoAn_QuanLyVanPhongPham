document.addEventListener("DOMContentLoaded", function () {

    const btnPlus = document.getElementById("btnQtyPlus");
    const btnMinus = document.getElementById("btnQtyMinus");
    const qtyInput = document.getElementById("qtyInput");

    const formQtyAdd = document.getElementById("formQtyAdd");
    const formQtyBuy = document.getElementById("formQtyBuy");

    // Cập nhật giá trị quantity
    function updateFormQuantities(newValue) {
        if (formQtyAdd) formQtyAdd.value = newValue;
        if (formQtyBuy) formQtyBuy.value = newValue;
    }

    if (btnPlus) {
        btnPlus.addEventListener("click", function () {
            let val = parseInt(qtyInput.value) || 1;
            qtyInput.value = val + 1;
            updateFormQuantities(val + 1);
        });
    }

    if (btnMinus) {
        btnMinus.addEventListener("click", function () {
            let val = parseInt(qtyInput.value) || 1;
            qtyInput.value = val > 1 ? val - 1 : 1;
            updateFormQuantities(qtyInput.value);
        });
    }

    // Xử lý form Thêm vào giỏ hàng
    const addToCartForm = document.getElementById("formAddToCart");
    if (addToCartForm) {
        addToCartForm.addEventListener("submit", function (e) {
            e.preventDefault(); // Ngăn load lại trang

            const formData = new FormData(addToCartForm);
            const query = new URLSearchParams(formData).toString();
            const url = addToCartForm.action + "?" + query;

            fetch(url, { method: "GET" })
                .then(res => {
                    if (!res.ok) throw new Error("HTTP " + res.status);
                    return res.json();
                })
                .then(data => {
                    // Nếu chưa đăng nhập
                    if (data.requireLogin) {
                        showToast("Vui lòng đăng nhập để thêm sản phẩm!", "warning");
                        setTimeout(() => window.location.href = "dang-nhap", 1200);
                        return;
                    }

                    // Nếu thêm thành công
                    if (data.success) {
                        const cartBadge = document.getElementById("cartCount");
                        if (cartBadge) {
                            cartBadge.textContent = data.cartCount;
                            cartBadge.classList.add("cart-bump");
                            setTimeout(() => cartBadge.classList.remove("cart-bump"), 300);
                        }
                        showToast("Đã thêm sản phẩm vào giỏ hàng!", "success");
                    } else {
                        showToast("Không thể thêm sản phẩm!", "danger");
                    }
                })
                .catch(err => {
                    console.error("Fetch error:", err);
                    showToast("Lỗi hệ thống!", "danger");
                });
        });
    }

    // Hàm hiển thị toast nhỏ gọn
    function showToast(msg, type) {
        const colors = {
            success: "#28a745",
            warning: "#ffc107",
            danger: "#dc3545"
        };
        const toast = document.createElement("div");
        toast.textContent = msg;
        toast.style.position = "fixed";
        toast.style.bottom = "20px";
        toast.style.right = "20px";
        toast.style.background = colors[type] || "#28a745";
        toast.style.color = "#fff";
        toast.style.padding = "10px 18px";
        toast.style.borderRadius = "8px";
        toast.style.boxShadow = "0 2px 8px rgba(0,0,0,0.2)";
        toast.style.opacity = "0";
        toast.style.transition = "opacity .3s";
        toast.style.zIndex = "9999";
        document.body.appendChild(toast);
        setTimeout(() => toast.style.opacity = "1", 50);
        setTimeout(() => toast.style.opacity = "0", 2000);
        setTimeout(() => toast.remove(), 2500);
    }
});
