
package dao;


import java.sql.*;
import java.util.*;
import dao.DBConnection;

public class ThongKeDao {
    // 🧭 Doanh thu theo từng tháng (12 tháng gần nhất)
    public Map<String, Double> getDoanhThuTheoThang() {
        Map<String, Double> data = new LinkedHashMap<>();
        String sql = """
            SELECT DATE_FORMAT(ngayDat, '%m/%Y') AS Thang, SUM(tongTien) AS DoanhThu
            FROM DonHang
            WHERE trangThai IN ('Hoàn tất', 'Đang giao')
            GROUP BY Thang
            ORDER BY MIN(ngayDat)
            LIMIT 12
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                data.put(rs.getString("Thang"), rs.getDouble("DoanhThu"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("[ERROR] ❌ Lỗi khi lấy doanh thu theo tháng: " + e.getMessage());
        }
        return data;
    }

    // 🏆 Top 5 sản phẩm bán chạy
    public List<Map<String, Object>> getTopSanPhamBanChay() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
            SELECT sp.tenSanPham, COUNT(dh.donHangId) AS soLuongBan
            FROM DonHang dh
            JOIN SanPham sp ON JSON_SEARCH(dh.danhSachSanPham, 'one', CAST(sp.sanPhamId AS CHAR), NULL, '$[*].SanPhamId') IS NOT NULL
            WHERE dh.trangThai IN ('Hoàn tất', 'Đang giao')
            GROUP BY sp.tenSanPham
            ORDER BY soLuongBan DESC
            LIMIT 5
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("tenSanPham", rs.getString("tenSanPham"));
                item.put("soLuongBan", rs.getInt("soLuongBan"));
                list.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("[ERROR] ❌ Lỗi khi lấy top sản phẩm bán chạy: " + e.getMessage());
        }

        return list;
    }
    // 📦 Lấy danh sách đơn hàng theo tháng (dùng cho xuất Excel)

    public List<Map<String, Object>> getDonHangTheoThang(int month) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = """
        SELECT donHangId, khachHangId, tongTien, ngayDat, trangThai, diaChiGiao
        FROM DonHang
        WHERE MONTH(ngayDat) = ?
        ORDER BY ngayDat
    """;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, month);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> dh = new HashMap<>();
                dh.put("donHangId", rs.getInt("donHangId"));
                dh.put("khachHangId", rs.getInt("khachHangId"));
                dh.put("tongTien", rs.getDouble("tongTien"));
                dh.put("ngayDat", rs.getTimestamp("ngayDat"));
                dh.put("trangThai", rs.getString("trangThai"));
                dh.put("diaChiGiao", rs.getString("diaChiGiao"));
                list.add(dh);
            }

        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("[ERROR] ❌ Lỗi khi lấy đơn hàng theo tháng: " + e.getMessage());
        }

        return list;
    }

}
