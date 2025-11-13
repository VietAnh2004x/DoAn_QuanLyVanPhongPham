package dao;

import model.NhaCungCap;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NhaCungCapDAO {
    
    // Lấy toàn bộ nhà cung cấp
    public List<NhaCungCap> getAll() {
        List<NhaCungCap> list = new ArrayList<>();
        String sql = "SELECT * FROM NhaCungCap";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new NhaCungCap(
                        rs.getInt("nhaCungCapId"),
                        rs.getString("tenNhaCungCap"),
                        rs.getString("diaChi"),
                        rs.getString("soDienThoai"),
                        rs.getString("email")
                ));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Thêm nhà cung cấp
    public boolean insert(NhaCungCap ncc) {
        String sql = "INSERT INTO NhaCungCap(tenNhaCungCap, diaChi, soDienThoai, email) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, ncc.getTenNhaCungCap());
            ps.setString(2, ncc.getDiaChi());
            ps.setString(3, ncc.getSoDienThoai());
            ps.setString(4, ncc.getEmail());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Sửa nhà cung cấp
    public boolean update(NhaCungCap ncc) {
        String sql = "UPDATE NhaCungCap SET tenNhaCungCap=?, diaChi=?, soDienThoai=?, email=? WHERE nhaCungCapId=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, ncc.getTenNhaCungCap());
            ps.setString(2, ncc.getDiaChi());
            ps.setString(3, ncc.getSoDienThoai());
            ps.setString(4, ncc.getEmail());
            ps.setInt(5, ncc.getNhaCungCapId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa nhà cung cấp
    public boolean delete(int id) {
        String sql = "DELETE FROM NhaCungCap WHERE nhaCungCapId=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Tìm kiếm theo tên hoặc địa chỉ
    public List<NhaCungCap> search(String keyword) {
        List<NhaCungCap> list = new ArrayList<>();
        String sql = "SELECT * FROM NhaCungCap WHERE tenNhaCungCap LIKE ? OR diaChi LIKE ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(new NhaCungCap(
                        rs.getInt("nhaCungCapId"),
                        rs.getString("tenNhaCungCap"),
                        rs.getString("diaChi"),
                        rs.getString("soDienThoai"),
                        rs.getString("email")
                ));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
