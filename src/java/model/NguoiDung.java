package model;

import dao.NguoiDungDAO;
import java.util.Date;
import java.util.List;

public class NguoiDung {
    private int nguoiDungId;
    private String hoTen;
    private String email;
    private String matKhau;
    private String soDienThoai;
    private String diaChi;
    private Date ngayDangKy;
    private int roleId;

    public NguoiDung() {}

    public NguoiDung(int nguoiDungId, String hoTen, String email, String matKhau, String soDienThoai, String diaChi, Date ngayDangKy, int roleId) {
        this.nguoiDungId = nguoiDungId;
        this.hoTen = hoTen;
        this.email = email;
        this.matKhau = matKhau;
        this.soDienThoai = soDienThoai;
        this.diaChi = diaChi;
        this.ngayDangKy = ngayDangKy;
        this.roleId = roleId;
    }

    public int getNguoiDungId() { return nguoiDungId; }
    public void setNguoiDungId(int nguoiDungId) { this.nguoiDungId = nguoiDungId; }

    public String getHoTen() { return hoTen; }
    public void setHoTen(String hoTen) { this.hoTen = hoTen; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getMatKhau() { return matKhau; }
    public void setMatKhau(String matKhau) { this.matKhau = matKhau; }

    public String getSoDienThoai() { return soDienThoai; }
    public void setSoDienThoai(String soDienThoai) { this.soDienThoai = soDienThoai; }

    public String getDiaChi() { return diaChi; }
    public void setDiaChi(String diaChi) { this.diaChi = diaChi; }

    public Date getNgayDangKy() { return ngayDangKy; }
    public void setNgayDangKy(Date ngayDangKy) { this.ngayDangKy = ngayDangKy; }

    public int getRoleId() { return roleId; }
    public void setRoleId(int roleId) { this.roleId = roleId; }
    
    public int getTongSanPhamTrongGioHang() {
        NguoiDungDAO dao = new NguoiDungDAO();
        return dao.getTongSanPham(this.nguoiDungId);
    }

    public List<SanPham> getDanhSachSanPhamTrongGioHang() {
        NguoiDungDAO dao = new NguoiDungDAO();
        return dao.getDanhSachSanPhamTrongGio(this.nguoiDungId);
    }
}
