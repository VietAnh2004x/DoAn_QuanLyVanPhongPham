package model;

import java.util.Date;

public class ThanhToan {
    private int thanhToanId;
    private int donHangId;
    private String phuongThuc;
    private double soTien;
    private String maGiaoDich;
    private String trangThai;
    private Date ngayThanhToan;
    private String ghiChu;

    public ThanhToan() {}

    public ThanhToan(int thanhToanId, int donHangId, String phuongThuc, double soTien, String maGiaoDich, String trangThai, Date ngayThanhToan, String ghiChu) {
        this.thanhToanId = thanhToanId;
        this.donHangId = donHangId;
        this.phuongThuc = phuongThuc;
        this.soTien = soTien;
        this.maGiaoDich = maGiaoDich;
        this.trangThai = trangThai;
        this.ngayThanhToan = ngayThanhToan;
        this.ghiChu = ghiChu;
    }

    public int getThanhToanId() {
        return thanhToanId;
    }
    public void setThanhToanId(int thanhToanId) {
        this.thanhToanId = thanhToanId;
    }

    public int getDonHangId() {
        return donHangId;
    }
    public void setDonHangId(int donHangId) {
        this.donHangId = donHangId;
    }

    public String getPhuongThuc() {
        return phuongThuc;
    }
    public void setPhuongThuc(String phuongThuc) {
        this.phuongThuc = phuongThuc;
    }

    public double getSoTien() {
        return soTien;
    }
    public void setSoTien(double soTien) {
        this.soTien = soTien;
    }

    public String getMaGiaoDich() {
        return maGiaoDich;
    }
    public void setMaGiaoDich(String maGiaoDich) {
        this.maGiaoDich = maGiaoDich;
    }

    public String getTrangThai() {
        return trangThai;
    }
    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }

    public Date getNgayThanhToan() {
        return ngayThanhToan;
    }
    public void setNgayThanhToan(Date ngayThanhToan) {
        this.ngayThanhToan = ngayThanhToan;
    }

    public String getGhiChu() {
        return ghiChu;
    }
    public void setGhiChu(String ghiChu) {
        this.ghiChu = ghiChu;
    }
}
