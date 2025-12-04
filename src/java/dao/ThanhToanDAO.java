package dao;

import model.ThanhToan;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.lang.reflect.Type;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class ThanhToanDAO {

    // =========================
    // LẤY DANH SÁCH THANH TOÁN
    // =========================
    public List<ThanhToan> getAll() {
        List<ThanhToan> list = new ArrayList<>();
        String sql = "SELECT * FROM ThanhToan ORDER BY thanhToanId DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(map(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public ThanhToan getByDonHangId(int donHangId) {
        String sql = "SELECT * FROM ThanhToan WHERE donHangId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, donHangId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // =========================
    // INSERT THANH TOÁN
    // =========================
    public boolean insert(ThanhToan t) {
        String sql = """
            INSERT INTO ThanhToan
            (donHangId, phuongThuc, soTien, maGiaoDich, trangThai, ngayThanhToan, ghiChu)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, t.getDonHangId());
            ps.setString(2, t.getPhuongThuc());
            ps.setDouble(3, t.getSoTien());
            ps.setString(4, t.getMaGiaoDich());
            ps.setString(5, t.getTrangThai());
            ps.setTimestamp(6, new Timestamp(t.getNgayThanhToan().getTime()));
            ps.setString(7, t.getGhiChu());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ======================================================
    // ✅ TRỪ TỒN KHO THEO JSON ĐƠN HÀNG (CHUẨN – KHUYÊN DÙNG)
    // ======================================================
    public boolean capNhatTonKhoTheoDonHang(int donHangId) {

        String sqlGetJson = "SELECT danhSachSanPham FROM DonHang WHERE donHangId = ?";
        String sqlCheckKho = "SELECT tonKho FROM SanPham WHERE sanPhamId = ?";
        String sqlUpdateKho = "UPDATE SanPham SET tonKho = tonKho - ? WHERE sanPhamId = ?";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            // 1️⃣ Lấy JSON đơn hàng
            String json = null;
            try (PreparedStatement ps = conn.prepareStatement(sqlGetJson)) {
                ps.setInt(1, donHangId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) json = rs.getString("danhSachSanPham");
            }

            if (json == null || json.isBlank()) {
                conn.rollback();
                return false;
            }

            // 2️⃣ Parse JSON
            Gson gson = new Gson();
            Type type = new TypeToken<List<Map<String, Object>>>() {}.getType();
            List<Map<String, Object>> listSP = gson.fromJson(json, type);

            // 3️⃣ Check tồn kho
            try (PreparedStatement psCheck = conn.prepareStatement(sqlCheckKho)) {
                for (Map<String, Object> sp : listSP) {
                    int sanPhamId = ((Number) sp.get("SanPhamId")).intValue();
                    int soLuong = ((Number) sp.get("SoLuong")).intValue();

                    psCheck.setInt(1, sanPhamId);
                    ResultSet rs = psCheck.executeQuery();

                    if (!rs.next() || rs.getInt("tonKho") < soLuong) {
                        conn.rollback();
                        System.err.println("❌ Không đủ tồn kho SP #" + sanPhamId);
                        return false;
                    }
                }
            }

            // 4️⃣ Trừ tồn kho
            try (PreparedStatement psUpdate = conn.prepareStatement(sqlUpdateKho)) {
                for (Map<String, Object> sp : listSP) {
                    int sanPhamId = ((Number) sp.get("SanPhamId")).intValue();
                    int soLuong = ((Number) sp.get("SoLuong")).intValue();

                    psUpdate.setInt(1, soLuong);
                    psUpdate.setInt(2, sanPhamId);
                    psUpdate.addBatch();

                    System.out.println("➡ Trừ " + soLuong + " SP #" + sanPhamId);
                }
                psUpdate.executeBatch();
            }

            conn.commit();
            System.out.println("✅ Trừ tồn kho thành công cho đơn #" + donHangId);
            return true;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // =========================
    // MAP RESULTSET
    // =========================
    private ThanhToan map(ResultSet rs) throws SQLException {
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
}
