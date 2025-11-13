package model;

import java.util.Date;

public class GioHang {
    private int gioHangId;
    private int khachHangId;
    private Date ngayTao;

    public GioHang() {}

    public GioHang(int gioHangId, int khachHangId, Date ngayTao) {
        this.gioHangId = gioHangId;
        this.khachHangId = khachHangId;
        this.ngayTao = ngayTao;
    }

    public int getGioHangId() { return gioHangId; }
    public void setGioHangId(int gioHangId) { this.gioHangId = gioHangId; }

    public int getKhachHangId() { return khachHangId; }
    public void setKhachHangId(int khachHangId) { this.khachHangId = khachHangId; }

    public Date getNgayTao() { return ngayTao; }
    public void setNgayTao(Date ngayTao) { this.ngayTao = ngayTao; }
}
