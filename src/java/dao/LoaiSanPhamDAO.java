package dao;

import model.LoaiSanPham;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LoaiSanPhamDAO {

    // Lấy danh sách loại sản phẩm
    public List<LoaiSanPham> getAll() {
        List<LoaiSanPham> list = new ArrayList<>();
        // Tên bảng là LoaiSanPham (đúng theo DB của bạn)
        String sql = "SELECT * FROM LoaiSanPham ORDER BY TenLoai ASC"; // Sắp xếp theo tên

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                // Giả sử Model LoaiSanPham của bạn có constructor (int, String, String)
                list.add(new LoaiSanPham(
                        // ⭐️ SỬA LẠI TÊN CỘT (viết hoa chữ cái đầu)
                        rs.getInt("LoaiId"),
                        rs.getString("TenLoai"),
                        rs.getString("MoTa")
                ));
            }

        } catch (Exception e) {
            e.printStackTrace(); // ⭐️ Hiển thị lỗi nếu có
        }

        return list;
    }

    // Thêm loại sản phẩm
    public boolean insert(LoaiSanPham lsp) {
        // ⭐️ SỬA LẠI TÊN CỘT (viết hoa)
        String sql = "INSERT INTO LoaiSanPham (TenLoai, MoTa) VALUES (?, ?)";

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, lsp.getTenLoai());
            ps.setString(2, lsp.getMoTa());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Sửa loại sản phẩm
    public boolean update(LoaiSanPham lsp) {
        // ⭐️ SỬA LẠI TÊN CỘT (viết hoa)
        String sql = "UPDATE LoaiSanPham SET TenLoai = ?, MoTa = ? WHERE LoaiId = ?";

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, lsp.getTenLoai());
            ps.setString(2, lsp.getMoTa());
            ps.setInt(3, lsp.getLoaiId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Xóa loại sản phẩm
    public boolean delete(int id) {
        // ⭐️ SỬA LẠI TÊN CỘT (viết hoa)
        String sql = "DELETE FROM LoaiSanPham WHERE LoaiId = ?";

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // Lấy thông tin Loại Sản Phẩm dựa theo Id
    public LoaiSanPham getLoaiSanPhamById(int loaiId) {
        // ⭐️ SỬA LẠI TÊN CỘT (viết hoa)
        String sql = "SELECT * FROM LoaiSanPham WHERE LoaiId = ?";
        LoaiSanPham loai = null;

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, loaiId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                loai = new LoaiSanPham(
                        // ⭐️ SỬA LẠI TÊN CỘT (viết hoa)
                        rs.getInt("LoaiId"),
                        rs.getString("TenLoai"),
                        rs.getString("MoTa")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return loai;
    }

    // Tìm kiếm loại sản phẩm theo tên
    public List<LoaiSanPham> search(String keyword) {
        List<LoaiSanPham> list = new ArrayList<>();
        // ⭐️ SỬA LẠI TÊN CỘT (viết hoa)
        String sql = "SELECT * FROM LoaiSanPham WHERE TenLoai LIKE ?";

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(new LoaiSanPham(
                        rs.getInt("LoaiId"),
                        rs.getString("TenLoai"),
                        rs.getString("MoTa")
                ));
            }

        } catch (Exception e) { 
            e.printStackTrace();
        }
        return list;
    }
}