document.addEventListener("DOMContentLoaded", function () {
    const provinceSelect = document.querySelector("#provinceSelect");
    const districtSelect = document.querySelector("#districtSelect");
    const wardSelect = document.querySelector("#wardSelect");

    let provincesData = [];

    // Load dữ liệu từ JSON nội bộ
    fetch(`${window.location.origin}${window.location.pathname.split('/')[1] ? '/' + window.location.pathname.split('/')[1] : ''}/assets/data/provinces.json`)
        .then(res => res.json())
        .then(data => {
            provincesData = data;
            provinceSelect.innerHTML = '<option value="" disabled selected>Tỉnh / thành</option>';
            data.forEach(province => {
                const option = document.createElement("option");
                option.value = province.code;
                option.textContent = province.name;
                provinceSelect.appendChild(option);
            });
        })
        .catch(err => console.error("Lỗi khi load file JSON:", err));

    // Khi chọn Tỉnh -> hiển thị Huyện
    provinceSelect.addEventListener("change", function () {
        const provinceCode = parseInt(this.value);
        districtSelect.innerHTML = '<option selected disabled>Quận / huyện</option>';
        wardSelect.innerHTML = '<option selected disabled>Phường / xã</option>';

        const selectedProvince = provincesData.find(p => p.code === provinceCode);
        if (selectedProvince) {
            selectedProvince.districts.forEach(d => {
                const option = document.createElement("option");
                option.value = d.code;
                option.textContent = d.name;
                districtSelect.appendChild(option);
            });
        }
    });

    // Khi chọn Huyện -> hiển thị Xã
    districtSelect.addEventListener("change", function () {
        const districtCode = parseInt(this.value);
        wardSelect.innerHTML = '<option selected disabled>Phường / xã</option>';

        // Tìm huyện trong toàn bộ dữ liệu
        provincesData.forEach(p => {
            p.districts.forEach(d => {
                if (d.code === districtCode) {
                    d.wards.forEach(w => {
                        const option = document.createElement("option");
                        option.value = w.code;
                        option.textContent = w.name;
                        wardSelect.appendChild(option);
                    });
                }
            });
        });
    });
});
