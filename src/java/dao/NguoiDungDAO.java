package dao;

import model.NguoiDung;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.SanPham;

public class NguoiDungDAO {

    // Lấy danh sách tất cả người dùng
    public List<NguoiDung> getAll() {
        List<NguoiDung> list = new ArrayList<>();
        String sql = "SELECT * FROM NguoiDung";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new NguoiDung(
                        rs.getInt("nguoiDungId"),
                        rs.getString("hoTen"),
                        rs.getString("email"),
                        rs.getString("matKhau"),
                        rs.getString("soDienThoai"),
                        rs.getString("diaChi"),
                        rs.getDate("ngayDangKy"),
                        rs.getInt("roleId")
                ));
            }

        } catch (Exception e) {
        }
        return list;
    }

    // Thêm người dùng
    public boolean insert(NguoiDung nd) {
        String sql = "INSERT INTO NguoiDung(hoTen, email, matKhau, soDienThoai, diaChi, ngayDangKy, roleId) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, nd.getHoTen());
            ps.setString(2, nd.getEmail());
            ps.setString(3, nd.getMatKhau());
            ps.setString(4, nd.getSoDienThoai());
            ps.setString(5, nd.getDiaChi());
            ps.setDate(6, new java.sql.Date(nd.getNgayDangKy().getTime()));
            ps.setInt(7, nd.getRoleId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
        }
        return false;
    }

    // Cập nhật thông tin người dùng
    public boolean update(NguoiDung nd) {
        String sql = "UPDATE NguoiDung SET hoTen=?, email=?, matKhau=?, soDienThoai=?, diaChi=?, ngayDangKy=?, roleId=? WHERE nguoiDungId=?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, nd.getHoTen());
            ps.setString(2, nd.getEmail());
            ps.setString(3, nd.getMatKhau());
            ps.setString(4, nd.getSoDienThoai());
            ps.setString(5, nd.getDiaChi());
            ps.setDate(6, new java.sql.Date(nd.getNgayDangKy().getTime()));
            ps.setInt(7, nd.getRoleId());
            ps.setInt(8, nd.getNguoiDungId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
        }
        return false;
    }

    // Cập nhật thông tin cá nhân (Không bao gồm mật khẩu, email)
    public boolean updateThongTin(int nguoiDungId, String hoTen, String soDienThoai, String diaChi) throws Exception {

        String sql = "UPDATE NguoiDung SET hoTen = ?, soDienThoai = ?, diaChi = ? WHERE nguoiDungId = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, hoTen);
            ps.setString(2, soDienThoai);
            ps.setString(3, diaChi);
            ps.setInt(4, nguoiDungId);

            return ps.executeUpdate() > 0;
        }
        // Lỗi sẽ tự động được ném ra
    }

    // Xóa người dùng
    public boolean delete(int id) {
        String sql = "DELETE FROM NguoiDung WHERE nguoiDungId=?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Đăng nhập (Login)
    public NguoiDung login(String email, String matKhau) {
        String sql = "SELECT * FROM NguoiDung WHERE email=? AND matKhau=?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, matKhau);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new NguoiDung(
                        rs.getInt("nguoiDungId"),
                        rs.getString("hoTen"),
                        rs.getString("email"),
                        rs.getString("matKhau"),
                        rs.getString("soDienThoai"),
                        rs.getString("diaChi"),
                        rs.getDate("ngayDangKy"),
                        rs.getInt("roleId")
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null; // sai email/mật khẩu
    }

    // Lấy người dùng theo ID
    public NguoiDung getById(int id) {
        String sql = "SELECT * FROM NguoiDung WHERE nguoiDungId=?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new NguoiDung(
                        rs.getInt("nguoiDungId"),
                        rs.getString("hoTen"),
                        rs.getString("email"),
                        rs.getString("matKhau"),
                        rs.getString("soDienThoai"),
                        rs.getString("diaChi"),
                        rs.getDate("ngayDangKy"),
                        rs.getInt("roleId")
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Hàm kiểm tra Email đã tồn tại chưa
    public boolean checkUserExist(String email) {
        String sql = "SELECT * FROM NguoiDung WHERE email = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                // Nếu rs.next() là true, nghĩa là tìm thấy 1 dòng
                // -> email đã tồn tại
                return rs.next();
            }

        } catch (Exception e) {
        }

        return false; // Mặc định là false (chưa tồn tại)
    }

    public int getTongSanPham(int nguoiDungId) {
        String sql = """
            SELECT COALESCE(SUM(ct.soLuong), 0) AS tongSoLuong
            FROM GioHang gh
            JOIN ChiTietGioHang ct ON gh.gioHangId = ct.gioHangId
            WHERE gh.khachHangId = ?
        """;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, nguoiDungId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("tongSoLuong");
            }

        } catch (Exception e) {
        }
        return 0;
    }

    public List<SanPham> getDanhSachSanPhamTrongGio(int nguoiDungId) {
        List<SanPham> list = new ArrayList<>();

        String sql = """
            SELECT sp.*, ct.soLuong
            FROM GioHang gh
            JOIN ChiTietGioHang ct ON gh.gioHangId = ct.gioHangId
            JOIN SanPham sp ON ct.sanPhamId = sp.sanPhamId
            WHERE gh.khachHangId = ?
        """;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, nguoiDungId);
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
                // gán thêm số lượng từ bảng ChiTietGioHang
                // cần thêm thuộc tính 'soLuong' tạm thời trong model SanPham nếu muốn hiển thị
                // ví dụ: sp.setSoLuong(rs.getInt("soLuong"));
                list.add(sp);
            }

        } catch (Exception e) {
        }

        return list;
    }
    
    // Cập nhật mật khẩu
    public boolean updatePassword(int nguoiDungId, String newPassword) throws Exception {
        
        String sql = "UPDATE NguoiDung SET matKhau = ? WHERE nguoiDungId = ?";

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newPassword);
            ps.setInt(2, nguoiDungId);

            return ps.executeUpdate() > 0;
        }
        // Lỗi sẽ tự động được ném ra
    }
    // Trong tệp NguoiDungDAO.java

    public List<NguoiDung> search(String keyword) {
        List<NguoiDung> list = new ArrayList<>();

        String sql = "SELECT * FROM NguoiDung WHERE hoTen LIKE ? OR email LIKE ? OR soDienThoai LIKE ?";

        try (Connection conn = new DBConnection().getConnection(); // Giả sử bạn có DBContext
                 PreparedStatement ps = conn.prepareStatement(sql)) {

            String searchKeyword = "%" + keyword + "%";

            // Không có gì thay đổi ở đây
            ps.setString(1, searchKeyword); // Cho hoTen
            ps.setString(2, searchKeyword); // Cho email
            ps.setString(3, searchKeyword); // Cho soDienThoai

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new NguoiDung(
                        rs.getInt("nguoiDungId"),
                        rs.getString("hoTen"),
                        rs.getString("email"),
                        rs.getString("matKhau"),
                        rs.getString("soDienThoai"),
                        rs.getString("diaChi"),
                        rs.getDate("ngayDangKy"),
                        rs.getInt("roleId")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
