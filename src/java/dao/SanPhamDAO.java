package dao;

import model.SanPham;
import java.sql.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

public class SanPhamDAO {

    // Lấy danh sách tất cả sản phẩm
    public List<SanPham> getAll() {
        List<SanPham> list = new ArrayList<>();
        String sql = "SELECT * FROM SanPham";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                SanPham sp = new SanPham(
                        rs.getInt("sanPhamId"),
                        rs.getString("tenSanPham"),
                        rs.getInt("loaiId"),
                        rs.getInt("nhaCungCapId"),
                        rs.getString("moTa"),
                        rs.getDouble("giaNhap"),
                        rs.getDouble("giaBan"),
                        rs.getInt("tonKho"),
                        rs.getString("hinhAnh"),
                        rs.getString("trangThai")
                );
                list.add(sp);
            }

        } catch (Exception e) {
            e.printStackTrace(); // Thêm e.printStackTrace() để xem lỗi
        }
        return list;
    }

    // Thêm sản phẩm
    public boolean insert(SanPham sp) {
        String sql = "INSERT INTO SanPham(tenSanPham, loaiId, nhaCungCapId, moTa, giaNhap, giaBan, tonKho, hinhAnh, trangThai) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, sp.getTenSanPham());
            ps.setInt(2, sp.getLoaiId());
            ps.setInt(3, sp.getNhaCungCapId());
            ps.setString(4, sp.getMoTa());
            ps.setDouble(5, sp.getGiaNhap());
            ps.setDouble(6, sp.getGiaBan());
            ps.setInt(7, sp.getTonKho());
            ps.setString(8, sp.getHinhAnh());
            ps.setString(9, sp.getTrangThai());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Sửa sản phẩm
    public boolean update(SanPham sp) {
        String sql = "UPDATE SanPham SET tenSanPham=?, loaiId=?, nhaCungCapId=?, moTa=?, giaNhap=?, giaBan=?, tonKho=?, hinhAnh=?, trangThai=? "
                + "WHERE sanPhamId=?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, sp.getTenSanPham());
            ps.setInt(2, sp.getLoaiId());
            ps.setInt(3, sp.getNhaCungCapId());
            ps.setString(4, sp.getMoTa());
            ps.setDouble(5, sp.getGiaNhap());
            ps.setDouble(6, sp.getGiaBan());
            ps.setInt(7, sp.getTonKho());
            ps.setString(8, sp.getHinhAnh());
            ps.setString(9, sp.getTrangThai());
            ps.setInt(10, sp.getSanPhamId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xoá sản phẩm
    public boolean delete(int id) {
        String sql = "DELETE FROM SanPham WHERE sanPhamId=?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public SanPham getSanPhamById(int sanPhamId) {
        String sql = "SELECT * FROM SanPham WHERE sanPhamId = ?";
        SanPham sp = null;

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, sanPhamId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                sp = new SanPham(
                        rs.getInt("sanPhamId"),
                        rs.getString("tenSanPham"),
                        rs.getInt("loaiId"),
                        rs.getInt("nhaCungCapId"),
                        rs.getString("moTa"),
                        rs.getDouble("giaNhap"),
                        rs.getDouble("giaBan"),
                        rs.getInt("tonKho"),
                        rs.getString("hinhAnh"),
                        rs.getString("trangThai")
                );
            }
        } catch (Exception e) {
            e.printStackTrace(); // Sửa lại: thêm e.printStackTrace()
        }
        return sp;
    }
    
    // === ⭐️ HÀM MỚI ĐỂ TÌM KIẾM/LỌC TRONG ADMIN ⭐️ ===
    public List<SanPham> search(String keyword, int loaiId) {
        List<SanPham> list = new ArrayList<>();
        
        // Dùng "WHERE 1=1" là mẹo để dễ dàng nối các vế AND
        String sql = "SELECT * FROM SanPham WHERE 1=1";
        
        // 1. Thêm điều kiện Tên (LIKE) nếu có
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND tenSanPham LIKE ?";
        }
        
        // 2. Thêm điều kiện Lọc (loaiId) nếu có (loaiId = 0 là "Tất cả")
        if (loaiId > 0) { 
            sql += " AND loaiId = ?"; // Tên cột trong DB là loaiId
        }
        
        sql += " ORDER BY sanPhamId ASC"; // Sắp xếp

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            // 3. Set tham số theo đúng thứ tự đã thêm vào SQL
            int paramIndex = 1; // Biến đếm vị trí tham số
            
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(paramIndex, "%" + keyword + "%");
                paramIndex++; // Tăng biến đếm
            }
            
            if (loaiId > 0) {
                ps.setInt(paramIndex, loaiId);
            }

            // 4. Thực thi và Map kết quả
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                SanPham sp = new SanPham(
                        rs.getInt("sanPhamId"),
                        rs.getString("tenSanPham"),
                        rs.getInt("loaiId"),
                        rs.getInt("nhaCungCapId"),
                        rs.getString("moTa"),
                        rs.getDouble("giaNhap"),
                        rs.getDouble("giaBan"),
                        rs.getInt("tonKho"),
                        rs.getString("hinhAnh"),
                        rs.getString("trangThai")
                );
                list.add(sp);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return list;
    }
    // === ⭐️ KẾT THÚC HÀM MỚI ⭐️ ===


    // Lấy danh sách sản phẩm Flash Sale (ví dụ 5 sản phẩm)
    public ArrayList<SanPham> getSanPhamFlashSale(int soLuong) {
        ArrayList<SanPham> list = new ArrayList<>();
        // Giả sử Flash Sale là các sản phẩm có giá bán thấp hơn giá nhập hoặc tồn kho cao
        String sql = "SELECT * FROM SanPham WHERE tonKho > 0 ORDER BY sanPhamId DESC LIMIT " + soLuong;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(new SanPham(
                        rs.getInt("sanPhamId"),
                        rs.getString("tenSanPham"),
                        rs.getInt("loaiId"),
                        rs.getInt("nhaCungCapId"),
                        rs.getString("moTa"),
                        rs.getDouble("giaNhap"),
                        rs.getDouble("giaBan"),
                        rs.getInt("tonKho"),
                        rs.getString("hinhAnh"),
                        rs.getString("trangThai")
                ));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy danh sách sản phẩm đặc biệt (ví dụ 7 sản phẩm "Dành cho bạn")
    public ArrayList<SanPham> getSanPhamDacBiet(int soLuong) {
        ArrayList<SanPham> list = new ArrayList<>();
        // Giả sử "Dành cho bạn" là những sản phẩm giá cao nhất còn hàng
        String sql = "SELECT * FROM SanPham WHERE tonKho > 0 ORDER BY giaBan DESC LIMIT " + soLuong;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(new SanPham(
                        rs.getInt("sanPhamId"),
                        rs.getString("tenSanPham"),
                        rs.getInt("loaiId"),
                        rs.getInt("nhaCungCapId"),
                        rs.getString("moTa"),
                        rs.getDouble("giaNhap"),
                        rs.getDouble("giaBan"),
                        rs.getInt("tonKho"),
                        rs.getString("hinhAnh"),
                        rs.getString("trangThai")
                ));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public ArrayList<SanPham> searchAndFilter(String keyword, Double minGia, Double maxGia, String sortMode) {
        ArrayList<SanPham> list = new ArrayList<>();
        
        // 1. Xây dựng câu SQL động một cách AN TOÀN
        StringBuilder sql = new StringBuilder("SELECT * FROM SanPham WHERE tenSanPham LIKE ?");
        List<Object> params = new ArrayList<>(); // Danh sách để chứa các tham số ?
        params.add("%" + keyword + "%");

        // Lọc giá (lọc trên giaBan, là giá gốc/niêm yết)
        if (minGia != null) {
            sql.append(" AND giaBan >= ?");
            params.add(minGia);
        }
        if (maxGia != null) {
            sql.append(" AND giaBan <= ?");
            params.add(maxGia);
        }

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            // 2. Gán các tham số vào câu lệnh an toàn
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(new SanPham(
                        rs.getInt("sanPhamId"),
                        rs.getString("tenSanPham"),
                        rs.getInt("loaiId"),
                        rs.getInt("nhaCungCapId"),
                        rs.getString("moTa"),
                        rs.getDouble("giaNhap"),
                        rs.getDouble("giaBan"),
                        rs.getInt("tonKho"),
                        rs.getString("hinhAnh"),
                        rs.getString("trangThai")
                ));
            }

        } catch (Exception e) {
            e.printStackTrace(); // Sửa lại: thêm e.printStackTrace()
        }

        // 3. Sắp xếp danh sách trong JAVA (dùng sp.getGiaKhuyenMai())
        if (sortMode == null) {
            sortMode = "popular";
        }
        
        // (Sử dụng cú pháp lambda cho gọn)
        switch (sortMode) {
            case "price_asc": // Giá tăng dần (theo giá khuyến mãi)
                list.sort(Comparator.comparingDouble(SanPham::getGiaKhuyenMai));
                break;
            case "price_desc": // Giá giảm dần (theo giá khuyến mãi)
                list.sort(Comparator.comparingDouble(SanPham::getGiaKhuyenMai).reversed());
                break;
            case "newest": // Mới nhất (theo ID)
                list.sort(Comparator.comparingInt(SanPham::getSanPhamId).reversed());
                break;
            case "popular": // Phổ biến
            default:
                // (Bạn có thể đổi logic "popular" nếu muốn, ví dụ theo tồn kho)
                break;
        }

        return list;
    }

    public boolean updateTonKho(int sanPhamId, int tonKhoMoi) {
        String sql = "UPDATE SanPham SET TonKho = ? WHERE SanPhamId = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, tonKhoMoi);
            ps.setInt(2, sanPhamId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Lấy danh sách sản phẩm thuộc danh mục (loaiId) 
    public ArrayList<SanPham> getSanPhamByLoaiId(int loaiId) {
        ArrayList<model.SanPham> list = new ArrayList<>();
        String sql = "SELECT * FROM SanPham WHERE loaiId = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, loaiId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(new model.SanPham(
                        rs.getInt("sanPhamId"),
                        rs.getString("tenSanPham"),
                        rs.getInt("loaiId"),
                        rs.getInt("nhaCungCapId"),
                        rs.getString("moTa"),
                        rs.getDouble("giaNhap"),
                        rs.getDouble("giaBan"),
                        rs.getInt("tonKho"),
                        rs.getString("hinhAnh"),
                        rs.getString("trangThai")
                ));
            }

        } catch (Exception e) {
            e.printStackTrace(); // Sửa lại: thêm e.printStackTrace()
        }
        return list;
    }

    public ArrayList<SanPham> getSanPhamByFilterAndSort(Integer loaiId, Double minGia, Double maxGia, String sortMode) {
        ArrayList<SanPham> list = new ArrayList<>();

        // 1. Xây dựng câu SQL động một cách AN TOÀN
        StringBuilder sql = new StringBuilder("SELECT * FROM SanPham WHERE 1=1");
        List<Object> params = new ArrayList<>(); // Danh sách để chứa các tham số ?

        if (loaiId != null && loaiId > 0) {
            sql.append(" AND loaiId = ?");
            params.add(loaiId);
        }

        // LƯU Ý: Lọc theo GIÁ GỐC (sp.getGiaBan())
        // Nếu bạn muốn lọc theo GIÁ KHUYẾN MÃI (sp.getGiaKhuyenMai()),
        // logic này phải được thực hiện trong Java (sau khi lấy list)
        if (minGia != null) {
            sql.append(" AND giaBan >= ?");
            params.add(minGia);
        }
        if (maxGia != null) {
            sql.append(" AND giaBan <= ?");
            params.add(maxGia);
        }

        // (Tạm thời bỏ ORDER BY trong SQL để sắp xếp trong Java cho linh hoạt)
        // sql.append(" ORDER BY giaBan ASC");
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            // 2. Gán các tham số vào câu lệnh an toàn
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                // (Bạn phải đảm bảo constructor này đúng với Model SanPham của bạn)
                list.add(new SanPham(
                        rs.getInt("sanPhamId"),
                        rs.getString("tenSanPham"),
                        rs.getInt("loaiId"),
                        rs.getInt("nhaCungCapId"),
                        rs.getString("moTa"),
                        rs.getDouble("giaNhap"),
                        rs.getDouble("giaBan"),
                        rs.getInt("tonKho"),
                        rs.getString("hinhAnh"),
                        rs.getString("trangThai")
                ));
            }

        } catch (Exception e) {
            e.printStackTrace(); // Sửa lại: thêm e.printStackTrace()
        }

        // 3. (MỚI) Sắp xếp danh sách trong JAVA
        // (Sao chép logic từ DanhMucSanPham.java vào đây)
        if (sortMode == null) {
            sortMode = "popular";
        }

        switch (sortMode) {
            case "price_asc": // Giá tăng dần (theo giá khuyến mãi)
                Collections.sort(list, Comparator.comparingDouble(SanPham::getGiaKhuyenMai));
                break;
            case "price_desc": // Giá giảm dần (theo giá khuyến mãi)
                Collections.sort(list, Comparator.comparingDouble(SanPham::getGiaKhuyenMai).reversed());
                break;
            case "newest": // Mới nhất (theo ID)
                Collections.sort(list, Comparator.comparingInt(SanPham::getSanPhamId).reversed());
                break;
            case "popular": // Phổ biến (ví dụ: theo tồn kho)
            default:
                Collections.sort(list, Comparator.comparingInt(SanPham::getTonKho).reversed());
                break;
        }
        return list;
    }

    // (Bạn cũng cần hàm getSanPhamByLoaiId cho các link không có bộ lọc)
    public ArrayList<SanPham> getSanPhamByLoaiId1(int loaiId) {
        // Gọi hàm mới với các bộ lọc là null
        return getSanPhamByFilterAndSort(loaiId, null, null, "popular");
    }
}