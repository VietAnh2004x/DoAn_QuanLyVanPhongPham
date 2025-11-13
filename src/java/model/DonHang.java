package model;

import java.util.Date;

public class DonHang {
    private int donHangId;
    private int khachHangId;
    private int nhanVienId;
    private String danhSachSanPham;
    private double tongTien;
    private Date ngayDat;
    private String diaChiGiao;
    private double phiVanChuyen;
    private String trangThai;

    // ✅ THÊM DÒNG NÀY - chỉ để hiển thị tên khách
    private String hoTenKhach;

    public DonHang() {}

    public DonHang(int donHangId, int khachHangId, int nhanVienId, String danhSachSanPham,
                   double tongTien, Date ngayDat, String diaChiGiao,
                   double phiVanChuyen, String trangThai) {
        this.donHangId = donHangId;
        this.khachHangId = khachHangId;
        this.nhanVienId = nhanVienId;
        this.danhSachSanPham = danhSachSanPham;
        this.tongTien = tongTien;
        this.ngayDat = ngayDat;
        this.diaChiGiao = diaChiGiao;
        this.phiVanChuyen = phiVanChuyen;
        this.trangThai = trangThai;
    }

    public int getDonHangId() { return donHangId; }
    public void setDonHangId(int donHangId) { this.donHangId = donHangId; }

    public int getKhachHangId() { return khachHangId; }
    public void setKhachHangId(int khachHangId) { this.khachHangId = khachHangId; }

    public int getNhanVienId() { return nhanVienId; }
    public void setNhanVienId(int nhanVienId) { this.nhanVienId = nhanVienId; }

    public String getDanhSachSanPham() { return danhSachSanPham; }
    public void setDanhSachSanPham(String danhSachSanPham) { this.danhSachSanPham = danhSachSanPham; }

    public double getTongTien() { return tongTien; }
    public void setTongTien(double tongTien) { this.tongTien = tongTien; }

    public Date getNgayDat() { return ngayDat; }
    public void setNgayDat(Date ngayDat) { this.ngayDat = ngayDat; }

    public String getDiaChiGiao() { return diaChiGiao; }
    public void setDiaChiGiao(String diaChiGiao) { this.diaChiGiao = diaChiGiao; }

    public double getPhiVanChuyen() { return phiVanChuyen; }
    public void setPhiVanChuyen(double phiVanChuyen) { this.phiVanChuyen = phiVanChuyen; }

    public String getTrangThai() { return trangThai; }
    public void setTrangThai(String trangThai) { this.trangThai = trangThai; }

    // ✅ Thêm getter/setter cho biến tạm này
    public String getHoTenKhach() { return hoTenKhach; }
    public void setHoTenKhach(String hoTenKhach) { this.hoTenKhach = hoTenKhach; }
}
