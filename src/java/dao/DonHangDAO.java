package dao;

import model.DonHang;
import model.SanPham;              // ✅ THÊM IMPORT NÀY
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import java.lang.reflect.Type;

public class DonHangDAO {

    // 📦 Lấy toàn bộ đơn hàng (kèm tên + SĐT khách hàng)
    public List<DonHang> getAll() {
        List<DonHang> list = new ArrayList<>();
        String sql = """
            SELECT d.*, n.hoTen AS hoTenKhach, n.soDienThoai
            FROM DonHang d
            JOIN NguoiDung n ON d.khachHangId = n.nguoiDungId
            ORDER BY d.donHangId DESC
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToDonHang(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 📦 Lấy đơn hàng theo ID (in chi tiết)
    public DonHang getById(int id) {
        String sql = """
            SELECT d.*, n.hoTen AS hoTenKhach, n.soDienThoai
            FROM DonHang d
            JOIN NguoiDung n ON d.khachHangId = n.nguoiDungId
            WHERE d.donHangId = ?
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                DonHang dh = mapResultSetToDonHang(rs);
                String jsonSanPham = dh.getDanhSachSanPham();

                if (jsonSanPham != null && !jsonSanPham.trim().isEmpty()) {
                    try {
                        Gson gson = new Gson();
                        Type listType = new TypeToken<List<Map<String, Object>>>() {}.getType();
                        List<Map<String, Object>> listSP = gson.fromJson(jsonSanPham, listType);

                        // ✅ CHỖ ĐƯỢC SỬA: LẤY GIÁ KHUYẾN MÃI
                        String sqlSP = """
                            SELECT sanPhamId, tenSanPham, giaBan, giaNhap
                            FROM SanPham
                            WHERE sanPhamId = ?
                        """;

                        try (PreparedStatement psSP = conn.prepareStatement(sqlSP)) {
                            for (Map<String, Object> sp : listSP) {
                                Object idObj = sp.get("SanPhamId");
                                if (idObj == null) continue;

                                int spId = (idObj instanceof Double)
                                        ? ((Double) idObj).intValue()
                                        : (idObj instanceof String
                                            ? Integer.parseInt((String) idObj)
                                            : (int) idObj);

                                psSP.setInt(1, spId);

                                try (ResultSet rsSP = psSP.executeQuery()) {
                                    if (rsSP.next()) {
                                        sp.put("TenSanPham", rsSP.getString("tenSanPham"));

                                        // ✅ TÍNH GIÁ KHUYẾN MÃI THEO LOGIC SanPham
                                        SanPham spTmp = new SanPham();
                                        spTmp.setGiaBan(rsSP.getDouble("giaBan"));
                                        spTmp.setGiaNhap(rsSP.getDouble("giaNhap"));

                                        // ✅ GHI ĐÈ: GiaBan = Giá khuyến mãi
                                        sp.put("GiaBan", spTmp.getGiaKhuyenMai());
                                    }
                                }
                            }
                        }

                        dh.setDanhSachSanPham(gson.toJson(listSP));

                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
                return dh;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // 🔍 Tìm kiếm đơn hàng
    public List<DonHang> search(String keyword) {
        List<DonHang> list = new ArrayList<>();
        String sql = """
            SELECT d.*, n.hoTen AS hoTenKhach, n.soDienThoai
            FROM DonHang d
            JOIN NguoiDung n ON d.khachHangId = n.nguoiDungId
            WHERE d.trangThai LIKE ?
               OR n.hoTen LIKE ?
               OR d.donHangId = ?
            ORDER BY d.donHangId DESC
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            String pattern = "%" + keyword + "%";
            ps.setString(1, pattern);
            ps.setString(2, pattern);

            try {
                ps.setInt(3, Integer.parseInt(keyword));
            } catch (NumberFormatException e) {
                ps.setInt(3, -1);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToDonHang(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 🔄 Cập nhật trạng thái
    public boolean updateTrangThai(int donHangId, String trangThai) {
        String sql = "UPDATE DonHang SET trangThai = ? WHERE donHangId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, trangThai);
            ps.setInt(2, donHangId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 🗑️ Xóa đơn hàng
    public boolean delete(int donHangId) {
        String sql = "DELETE FROM DonHang WHERE donHangId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, donHangId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 📊 Tổng doanh thu
    public double getTongDoanhThu() {
        double tong = 0;
        String sql = """
            SELECT SUM(tongTien) AS TongDoanhThu
            FROM DonHang
            WHERE trangThai IN ('Hoàn tất')
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                tong = rs.getDouble("TongDoanhThu");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return tong;
    }

    // 🧾 Thêm đơn hàng
    public int insert(DonHang dh) {
        String sql = """
            INSERT INTO DonHang
            (khachHangId, tongTien, danhSachSanPham, ngayDat, diaChiGiao, phiVanChuyen, trangThai)
            VALUES (?, ?, ?, NOW(), ?, ?, ?)
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, dh.getKhachHangId());
            ps.setDouble(2, dh.getTongTien());
            ps.setString(3, dh.getDanhSachSanPham());
            ps.setString(4, dh.getDiaChiGiao());
            ps.setDouble(5, dh.getPhiVanChuyen());
            ps.setString(6, dh.getTrangThai());

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    // 🧭 Lấy đơn gần nhất
    public int getLatestOrderId(int khachHangId) {
        String sql = "SELECT donHangId FROM DonHang WHERE khachHangId = ? ORDER BY donHangId DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, khachHangId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("donHangId");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    // ===== MAP RESULTSET =====
    private DonHang mapResultSetToDonHang(ResultSet rs) throws SQLException {
        DonHang dh = new DonHang();
        dh.setDonHangId(rs.getInt("donHangId"));
        dh.setKhachHangId(rs.getInt("khachHangId"));
        dh.setDanhSachSanPham(rs.getString("danhSachSanPham"));
        dh.setTongTien(rs.getDouble("tongTien"));
        dh.setNgayDat(rs.getTimestamp("ngayDat"));
        dh.setDiaChiGiao(rs.getString("diaChiGiao"));
        dh.setPhiVanChuyen(rs.getDouble("phiVanChuyen"));
        dh.setTrangThai(rs.getString("trangThai"));

        try { dh.setHoTenKhach(rs.getString("hoTenKhach")); } catch (SQLException ignored) {}
        try { dh.setSoDienThoai(rs.getString("soDienThoai")); } catch (SQLException ignored) {}

        return dh;
    }

    // 📂 Lấy đơn theo khách hàng
    public List<DonHang> getDonHangByKhachHangId(int khachHangId) throws Exception {
        List<DonHang> list = new ArrayList<>();
        String sql = "SELECT * FROM DonHang WHERE khachHangId = ? ORDER BY ngayDat DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, khachHangId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new DonHang(
                            rs.getInt("donHangId"),
                            rs.getInt("khachHangId"),
                            rs.getString("danhSachSanPham"),
                            rs.getDouble("tongTien"),
                            rs.getDate("ngayDat"),
                            rs.getString("diaChiGiao"),
                            rs.getDouble("phiVanChuyen"),
                            rs.getString("trangThai")
                    ));
                }
            }
        }
        return list;
    }
}
