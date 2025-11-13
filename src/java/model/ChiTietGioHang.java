package model;

public class ChiTietGioHang {
    private int id;
    private int gioHangId;
    private int sanPhamId;
    private int soLuong;
    private SanPham sanPham;

    public ChiTietGioHang() {}

    public ChiTietGioHang(int id, int gioHangId, int sanPhamId, int soLuong) {
        this.id = id;
        this.gioHangId = gioHangId;
        this.sanPhamId = sanPhamId;
        this.soLuong = soLuong;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getGioHangId() { return gioHangId; }
    public void setGioHangId(int gioHangId) { this.gioHangId = gioHangId; }

    public int getSanPhamId() { return sanPhamId; }
    public void setSanPhamId(int sanPhamId) { this.sanPhamId = sanPhamId; }

    public int getSoLuong() { return soLuong; }
    public void setSoLuong(int soLuong) { this.soLuong = soLuong; }
    
    public SanPham getSanPham() { return sanPham; }
    public void setSanPham(SanPham sanPham) { this.sanPham = sanPham; }
}
