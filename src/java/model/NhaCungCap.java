package model;

public class NhaCungCap {
    private int nhaCungCapId;
    private String tenNhaCungCap;
    private String diaChi;
    private String soDienThoai;
    private String email;

    public NhaCungCap() {}

    public NhaCungCap(int nhaCungCapId, String tenNhaCungCap, String diaChi, String soDienThoai, String email) {
        this.nhaCungCapId = nhaCungCapId;
        this.tenNhaCungCap = tenNhaCungCap;
        this.diaChi = diaChi;
        this.soDienThoai = soDienThoai;
        this.email = email;
    }

    public int getNhaCungCapId() { return nhaCungCapId; }
    public void setNhaCungCapId(int nhaCungCapId) { this.nhaCungCapId = nhaCungCapId; }

    public String getTenNhaCungCap() { return tenNhaCungCap; }
    public void setTenNhaCungCap(String tenNhaCungCap) { this.tenNhaCungCap = tenNhaCungCap; }

    public String getDiaChi() { return diaChi; }
    public void setDiaChi(String diaChi) { this.diaChi = diaChi; }

    public String getSoDienThoai() { return soDienThoai; }
    public void setSoDienThoai(String soDienThoai) { this.soDienThoai = soDienThoai; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
}
