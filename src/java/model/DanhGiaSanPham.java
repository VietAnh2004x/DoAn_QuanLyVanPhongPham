package model;

import java.util.Date;

public class DanhGiaSanPham {
    private int danhGiaId;
    private int sanPhamId;
    private int khachHangId;
    private int diem;
    private String noiDung;
    private Date ngayDanhGia;
    private String tenKhachHang;

    public String getTenKhachHang() {
        return tenKhachHang;
    }

    public void setTenKhachHang(String tenKhachHang) {
        this.tenKhachHang = tenKhachHang;
    }

    public DanhGiaSanPham() {}

    public DanhGiaSanPham(int danhGiaId, int sanPhamId, int khachHangId, int diem, String noiDung, Date ngayDanhGia, String tenKhachHang) {
        this.danhGiaId = danhGiaId;
        this.sanPhamId = sanPhamId;
        this.khachHangId = khachHangId;
        this.diem = diem;
        this.noiDung = noiDung;
        this.ngayDanhGia = ngayDanhGia;
        this.tenKhachHang = tenKhachHang;
    }

    public int getDanhGiaId() {
        return danhGiaId;
    }
    public void setDanhGiaId(int danhGiaId) {
        this.danhGiaId = danhGiaId;
    }

    public int getSanPhamId() {
        return sanPhamId;
    }
    public void setSanPhamId(int sanPhamId) {
        this.sanPhamId = sanPhamId;
    }

    public int getKhachHangId() {
        return khachHangId;
    }
    public void setKhachHangId(int khachHangId) {
        this.khachHangId = khachHangId;
    }

    public int getDiem() {
        return diem;
    }
    public void setDiem(int diem) {
        this.diem = diem;
    }

    public String getNoiDung() {
        return noiDung;
    }
    public void setNoiDung(String noiDung) {
        this.noiDung = noiDung;
    }

    public Date getNgayDanhGia() {
        return ngayDanhGia;
    }
    public void setNgayDanhGia(Date ngayDanhGia) {
        this.ngayDanhGia = ngayDanhGia;
    }
}
