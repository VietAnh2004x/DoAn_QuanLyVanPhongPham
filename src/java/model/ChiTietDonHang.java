package model;

// Đây là lớp Model để chứa thông tin chi tiết SẼ HIỂN THỊ
public class ChiTietDonHang {
    
    private String tenSanPham;
    private String hinhAnh;
    private int soLuong;
    private double donGia; // Giá tại thời điểm mua (hoặc giá hiện tại)

    public ChiTietDonHang() {
    }

    // Getters and Setters
    public String getTenSanPham() { return tenSanPham; }
    public void setTenSanPham(String tenSanPham) { this.tenSanPham = tenSanPham; }

    public String getHinhAnh() { return hinhAnh; }
    public void setHinhAnh(String hinhAnh) { this.hinhAnh = hinhAnh; }

    public int getSoLuong() { return soLuong; }
    public void setSoLuong(int soLuong) { this.soLuong = soLuong; }

    public double getDonGia() { return donGia; }
    public void setDonGia(double donGia) { this.donGia = donGia; }
}