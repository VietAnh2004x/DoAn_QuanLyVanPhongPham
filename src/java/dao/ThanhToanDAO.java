package dao;

import model.ThanhToan;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ThanhToanDAO {

    // Lấy toàn bộ thanh toán
    public List<ThanhToan> getAll() {
        List<ThanhToan> list = new ArrayList<>();
        String sql = "SELECT * FROM ThanhToan ORDER BY thanhToanId DESC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new ThanhToan(
                        rs.getInt("thanhToanId"),
                        rs.getInt("donHangId"),
                        rs.getString("phuongThuc"),
                        rs.getDouble("soTien"),
                        rs.getString("maGiaoDich"),
                        rs.getString("trangThai"),
                        rs.getDate("ngayThanhToan"),
                        rs.getString("ghiChu")
                ));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Lấy thanh toán theo đơn hàng
    public ThanhToan getByDonHangId(int donHangId) {
        String sql = "SELECT * FROM ThanhToan WHERE donHangId = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, donHangId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new ThanhToan(
                        rs.getInt("thanhToanId"),
                        rs.getInt("donHangId"),
                        rs.getString("phuongThuc"),
                        rs.getDouble("soTien"),
                        rs.getString("maGiaoDich"),
                        rs.getString("trangThai"),
                        rs.getDate("ngayThanhToan"),
                        rs.getString("ghiChu")
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean insert(ThanhToan t) {
        String sql = """
        INSERT INTO ThanhToan (donHangId, phuongThuc, soTien, maGiaoDich, trangThai, ngayThanhToan, ghiChu)
        VALUES (?, ?, ?, ?, ?, ?, ?)
    """;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, t.getDonHangId());
            ps.setString(2, t.getPhuongThuc());
            ps.setDouble(3, t.getSoTien());
            ps.setString(4, t.getMaGiaoDich());
            ps.setString(5, t.getTrangThai());
            ps.setTimestamp(6, new java.sql.Timestamp(t.getNgayThanhToan().getTime())); // ✅ MySQL cần Timestamp
            ps.setString(7, t.getGhiChu());

            int rows = ps.executeUpdate();
            System.out.println(">>> [DEBUG] insert ThanhToan rows = " + rows);

            return rows > 0;

        } catch (SQLException e) {
            System.err.println("❌ Lỗi SQL khi lưu ThanhToan:");
            e.printStackTrace();
        }
        return false;
    }





    public boolean capNhatTonKhoSauThanhToanTheoGioHang(int khachHangId) {
        String sqlSelect = """
        SELECT sp.sanPhamId, ct.soLuong
        FROM ChiTietGioHang ct
        JOIN GioHang gh ON ct.gioHangId = gh.gioHangId
        JOIN SanPham sp ON ct.sanPhamId = sp.sanPhamId
        WHERE gh.khachHangId = ?
    """;

        String sqlUpdate = "UPDATE SanPham SET tonKho = GREATEST(tonKho - ?, 0) WHERE sanPhamId = ?";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement psSelect = conn.prepareStatement(sqlSelect); PreparedStatement psUpdate = conn.prepareStatement(sqlUpdate)) {

                psSelect.setInt(1, khachHangId);
                ResultSet rs = psSelect.executeQuery();

                boolean hasProduct = false;
                while (rs.next()) {
                    hasProduct = true;
                    int sanPhamId = rs.getInt("sanPhamId");
                    int soLuong = rs.getInt("soLuong");

                    psUpdate.setInt(1, soLuong);
                    psUpdate.setInt(2, sanPhamId);
                    psUpdate.addBatch();

                    System.out.println("➡ Trừ " + soLuong + " sản phẩm #" + sanPhamId);
                }

                if (!hasProduct) {
                    System.out.println("⚠ Không tìm thấy sản phẩm trong giỏ hàng của khách #" + khachHangId);
                    conn.rollback();
                    return false;
                }

                psUpdate.executeBatch();
                conn.commit();
                System.out.println("✅ Đã cập nhật tồn kho thành công cho khách #" + khachHangId);
                return true;

            } catch (Exception e) {
                conn.rollback();
                e.printStackTrace();
            } finally {
                conn.setAutoCommit(true);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

}
