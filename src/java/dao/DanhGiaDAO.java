package dao;

import java.sql.*;
import java.util.*;
import model.DanhGiaSanPham;

public class DanhGiaDAO {
    public boolean insert(DanhGiaSanPham dg) {
        String sql = "INSERT INTO DanhGiaSanPham (SanPhamId, KhachHangId, Diem, NoiDung, NgayDanhGia) VALUES (?, ?, ?, ?, NOW())";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, dg.getSanPhamId());
            ps.setInt(2, dg.getKhachHangId());
            ps.setInt(3, dg.getDiem());
            ps.setString(4, dg.getNoiDung());

            return ps.executeUpdate() > 0;
        } catch (Exception e) { }
        return false;
    }

    public List<DanhGiaSanPham> getBySanPhamId(int sanPhamId) {
        List<DanhGiaSanPham> list = new ArrayList<>();

        String sql = "SELECT d.*, n.hoTen "
                + "FROM DanhGiaSanPham d "
                + "JOIN NguoiDung n ON d.KhachHangId = n.NguoiDungId "
                + "WHERE d.SanPhamId = ? "
                + "ORDER BY d.NgayDanhGia DESC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, sanPhamId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                DanhGiaSanPham dg = new DanhGiaSanPham();
                dg.setDanhGiaId(rs.getInt("DanhGiaId"));
                dg.setSanPhamId(rs.getInt("SanPhamId"));
                dg.setKhachHangId(rs.getInt("KhachHangId"));
                dg.setDiem(rs.getInt("Diem"));
                dg.setNoiDung(rs.getString("NoiDung"));
                dg.setNgayDanhGia(rs.getTimestamp("NgayDanhGia"));
                dg.setTenKhachHang(rs.getString("hoTen"));
                list.add(dg);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ✅ Tính điểm trung bình sao
    public double getDiemTrungBinh(int sanPhamId) {
        String sql = "SELECT AVG(Diem) AS avgStar FROM DanhGiaSanPham WHERE SanPhamId = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, sanPhamId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("avgStar");
            }

        } catch (Exception e) { }
        return 0;
    }

    // ✅ Lấy tổng số lượt đánh giá
    public int getTongDanhGia(int sanPhamId) {
        String sql = "SELECT COUNT(*) AS total FROM DanhGiaSanPham WHERE SanPhamId = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, sanPhamId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }

        } catch (Exception e) { }
        return 0;
    }
}
