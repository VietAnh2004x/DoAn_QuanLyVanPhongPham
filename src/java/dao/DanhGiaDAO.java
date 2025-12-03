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
    public List<DanhGiaSanPham> getAllDanhGia() {
        List<DanhGiaSanPham> list = new ArrayList<>();

        String sql = """
            SELECT 
                d.DanhGiaId,
                d.SanPhamId,
                d.KhachHangId,
                d.Diem,
                d.NoiDung,
                d.NgayDanhGia,
                n.HoTen AS TenKhachHang
            FROM DanhGiaSanPham d
            JOIN NguoiDung n ON d.KhachHangId = n.NguoiDungId
            ORDER BY d.NgayDanhGia DESC
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRow(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
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
    
    public List<DanhGiaSanPham> getDanhGiaBySanPhamId(int sanPhamId) {
        List<DanhGiaSanPham> list = new ArrayList<>();

        String sql = """
            SELECT 
                d.DanhGiaId,
                d.SanPhamId,
                d.KhachHangId,
                d.Diem,
                d.NoiDung,
                d.NgayDanhGia,
                n.HoTen AS TenKhachHang
            FROM DanhGiaSanPham d
            JOIN NguoiDung n ON d.KhachHangId = n.NguoiDungId
            WHERE d.SanPhamId = ?
            ORDER BY d.NgayDanhGia DESC
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, sanPhamId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(mapRow(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public List<DanhGiaSanPham> searchDanhGia(String keyword) {
        List<DanhGiaSanPham> list = new ArrayList<>();

        String sql = """
            SELECT 
                d.DanhGiaId,
                d.SanPhamId,
                d.KhachHangId,
                d.Diem,
                d.NoiDung,
                d.NgayDanhGia,
                n.HoTen AS TenKhachHang
            FROM DanhGiaSanPham d
            JOIN NguoiDung n ON d.KhachHangId = n.NguoiDungId
            WHERE n.HoTen LIKE ?
               OR d.NoiDung LIKE ?
            ORDER BY d.NgayDanhGia DESC
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public List<DanhGiaSanPham> searchDanhGiaBySanPham(int sanPhamId, String keyword) {
        List<DanhGiaSanPham> list = new ArrayList<>();

        String sql = """
            SELECT 
                d.DanhGiaId,
                d.SanPhamId,
                d.KhachHangId,
                d.Diem,
                d.NoiDung,
                d.NgayDanhGia,
                n.HoTen AS TenKhachHang
            FROM DanhGiaSanPham d
            JOIN NguoiDung n ON d.KhachHangId = n.NguoiDungId
            WHERE d.SanPhamId = ?
              AND (n.HoTen LIKE ? OR d.NoiDung LIKE ?)
            ORDER BY d.NgayDanhGia DESC
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, sanPhamId);
            ps.setString(2, "%" + keyword + "%");
            ps.setString(3, "%" + keyword + "%");

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public List<DanhGiaSanPham> filterDanhGiaBySao(Integer sanPhamId, int diem) {
        List<DanhGiaSanPham> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
        SELECT 
            d.DanhGiaId,
            d.SanPhamId,
            d.KhachHangId,
            d.Diem,
            d.NoiDung,
            d.NgayDanhGia,
            n.HoTen AS TenKhachHang
        FROM DanhGiaSanPham d
        JOIN NguoiDung n ON d.KhachHangId = n.NguoiDungId
        WHERE d.Diem = ?
    """);

        if (sanPhamId != null) {
            sql.append(" AND d.SanPhamId = ?");
        }

        sql.append(" ORDER BY d.NgayDanhGia DESC");

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            ps.setInt(1, diem);
            if (sanPhamId != null) {
                ps.setInt(2, sanPhamId);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    public List<DanhGiaSanPham> filterDanhGiaBySao(int diem) {
        return filterDanhGiaBySao(null, diem);
    }
    private DanhGiaSanPham mapRow(ResultSet rs) throws SQLException {
        return new DanhGiaSanPham(
                rs.getInt("DanhGiaId"),
                rs.getInt("SanPhamId"),
                rs.getInt("KhachHangId"),
                rs.getInt("Diem"),
                rs.getString("NoiDung"),
                rs.getTimestamp("NgayDanhGia"),
                rs.getString("TenKhachHang")
        );
    }
}