document.addEventListener("DOMContentLoaded", function () {

    const provinceSelect = document.querySelector("#provinceSelect");
    const districtSelect = document.querySelector("#districtSelect");
    const wardSelect = document.querySelector("#wardSelect");

    let provincesData = [];

    // ===== LOAD 63 TỈNH =====
    fetch(`${location.origin}/${location.pathname.split('/')[1]}/assets/data/provinces.json`)
        .then(res => res.json())
        .then(data => {
            provincesData = data;

            provinceSelect.innerHTML = `<option value="" disabled selected>Tỉnh / thành</option>`;
            data.forEach(p => {
                provinceSelect.innerHTML += `<option value="${p.name}">${p.name}</option>`;
            });
        });

    // ===== CHỌN TỈNH → HUYỆN =====
    provinceSelect.addEventListener("change", function () {

        const provinceName = this.value;
        districtSelect.innerHTML = `<option value="" disabled selected>Quận / huyện</option>`;
        wardSelect.innerHTML = `<option value="" disabled selected>Phường / xã</option>`;

        const province = provincesData.find(p => p.name === provinceName);
        if (!province) return;

        province.districts.forEach(d => {
            districtSelect.innerHTML += `<option value="${d.name}">${d.name}</option>`;
        });
    });

    // ===== CHỌN HUYỆN → XÃ =====
    districtSelect.addEventListener("change", function () {

        const districtName = this.value;
        wardSelect.innerHTML = `<option value="" disabled selected>Phường / xã</option>`;

        let selectedDistrict = null;

        for (const p of provincesData) {
            selectedDistrict = p.districts.find(d => d.name === districtName);
            if (selectedDistrict) break;
        }

        if (!selectedDistrict) return;

        selectedDistrict.wards.forEach(w => {
            wardSelect.innerHTML += `<option value="${w.name}">${w.name}</option>`;
        });
    });

});
