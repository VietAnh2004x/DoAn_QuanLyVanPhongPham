package model;

public class LoaiSanPham {
    private int loaiId;
    private String tenLoai;
    private String moTa;

    public LoaiSanPham() {}
    public LoaiSanPham(int loaiId, String tenLoai, String moTa) {
        this.loaiId = loaiId;
        this.tenLoai = tenLoai;
        this.moTa = moTa;
    }

    public int getLoaiId() { return loaiId; }
    public void setLoaiId(int loaiId) { this.loaiId = loaiId; }

    public String getTenLoai() { return tenLoai; }
    public void setTenLoai(String tenLoai) { this.tenLoai = tenLoai; }

    public String getMoTa() { return moTa; }
    public void setMoTa(String moTa) { this.moTa = moTa; }
}
