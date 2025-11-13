package controller;

import dao.ChiTietGioHangDAO;
import dao.DonHangDAO;
import dao.SanPhamDAO;
import dao.ThanhToanDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import model.ChiTietGioHang;
import model.NguoiDung;
import model.SanPham;

@WebServlet("/thanh-toan")
public class ThanhToan extends HttpServlet {

    private ChiTietGioHangDAO gioHangDAO = new ChiTietGioHangDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("[DEBUG] Bắt đầu vào servlet ThanhToan (GET)");
        HttpSession session = request.getSession();
        NguoiDung user = (NguoiDung) session.getAttribute("authUser");

        if (user == null) {
            System.out.println("[DEBUG] ❌ user == null => redirect về trang đăng nhập");
            response.sendRedirect("dang-nhap");
            return;
        }

        String action = request.getParameter("action");
        String mode = request.getParameter("mode");

        // 🔹 Nếu người dùng bấm “Tiến hành đặt hàng” từ giỏ hàng
        if ("checkout".equals(action)) {
            int userId = user.getNguoiDungId();
            List<ChiTietGioHang> cartItems = gioHangDAO.getByNguoiDungId(userId);

            if (cartItems == null || cartItems.isEmpty()) {
                System.out.println("[DEBUG] ❌ Giỏ hàng trống => redirect về xem-gio-hang");
                response.sendRedirect("xem-gio-hang");
                return;
            }

            double subtotal = gioHangDAO.tinhTongTienGioHang(userId);
            double shippingCost = (subtotal < 50000 ? 30000
                    : subtotal < 100000 ? 20000
                    : subtotal < 200000 ? 10000 : 0);
            double grandTotal = subtotal + shippingCost;

            request.setAttribute("cartItems", cartItems);
            request.setAttribute("subtotal", subtotal);
            request.setAttribute("shippingCost", shippingCost);
            request.setAttribute("grandTotal", grandTotal);
            request.setAttribute("isBuyNow", false);

            System.out.println("[DEBUG] ✅ Người dùng bấm tiến hành đặt hàng -> sang view/thanhtoan.jsp");
            request.getRequestDispatcher("/view/thanhtoan.jsp").forward(request, response);
            return;
        }

        // 🔹 MUA NGAY
        if ("buyNow".equals(mode)) {
            ChiTietGioHang item = (ChiTietGioHang) session.getAttribute("buyNowItem");
            Double subtotal = (Double) session.getAttribute("buyNowSubtotal");
            Double shipping = (Double) session.getAttribute("buyNowShipping");
            Double grandTotal = (Double) session.getAttribute("buyNowGrandTotal");

            if (item == null) {
                System.out.println("[DEBUG] ❌ Không tìm thấy sản phẩm mua ngay trong session");
                response.sendRedirect("loi.jsp");
                return;
            }

            request.setAttribute("cartItems", Arrays.asList(item));
            request.setAttribute("subtotal", subtotal);
            request.setAttribute("shippingCost", shipping);
            request.setAttribute("grandTotal", grandTotal);
            request.setAttribute("isBuyNow", true);

            System.out.println("[DEBUG] ✅ Forward sang view/thanhtoan.jsp (Mua ngay)");
            request.getRequestDispatcher("/view/thanhtoan.jsp").forward(request, response);
            return;
        }

        // 🔹 Mặc định: nếu không có mode/action thì load từ giỏ hàng
        int userId = user.getNguoiDungId();
        List<ChiTietGioHang> cartItems = gioHangDAO.getByNguoiDungId(userId);

        if (cartItems == null || cartItems.isEmpty()) {
            System.out.println("[DEBUG] ❌ Giỏ hàng trống => redirect về xem-gio-hang");
            response.sendRedirect("xem-gio-hang");
            return;
        }

        double subtotal = gioHangDAO.tinhTongTienGioHang(userId);
        double shippingCost = (subtotal < 50000 ? 30000
                : subtotal < 100000 ? 20000
                : subtotal < 200000 ? 10000 : 0);
        double grandTotal = subtotal + shippingCost;

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("subtotal", subtotal);
        request.setAttribute("shippingCost", shippingCost);
        request.setAttribute("grandTotal", grandTotal);
        request.setAttribute("isBuyNow", false);

        System.out.println("[DEBUG] ✅ Forward sang view/thanhtoan.jsp (Giỏ hàng)");
        request.getRequestDispatcher("/view/thanhtoan.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("[DEBUG] Bắt đầu vào servlet ThanhToan (POST)");
        HttpSession session = request.getSession();
        NguoiDung user = (NguoiDung) session.getAttribute("authUser");

        if (user == null) {
            System.out.println("[DEBUG] ❌ Chưa đăng nhập => redirect dang-nhap");
            response.sendRedirect("dang-nhap");
            return;
        }

        String action = request.getParameter("action");
        String tongTienStr = request.getParameter("tongTien");
        System.out.println("[DEBUG] action = " + action);
        System.out.println("[DEBUG] tongTien = " + tongTienStr);

        SanPhamDAO spDao = new SanPhamDAO();

        // 🔹 1. MUA NGAY
        if ("buyNow".equals(action)) {
            try {
                int productId = Integer.parseInt(request.getParameter("productId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                SanPham sp = spDao.getSanPhamById(productId);

                if (sp == null) throw new Exception("Không tìm thấy sản phẩm");

                double donGia = sp.getGiaKhuyenMai() > 0 ? sp.getGiaKhuyenMai() : sp.getGiaBan();
                double subtotal = donGia * quantity;
                double shippingCost = (subtotal < 50000 ? 30000
                        : subtotal < 100000 ? 20000
                        : subtotal < 200000 ? 10000 : 0);
                double grandTotal = subtotal + shippingCost;

                ChiTietGioHang temp = new ChiTietGioHang();
                temp.setSanPham(sp);
                temp.setSoLuong(quantity);

                session.setAttribute("buyNowItem", temp);
                session.setAttribute("buyNowSubtotal", subtotal);
                session.setAttribute("buyNowShipping", shippingCost);
                session.setAttribute("buyNowGrandTotal", grandTotal);

                System.out.println("[DEBUG] ✅ Mua ngay: chuyển sang view/thanhtoan.jsp");
                response.sendRedirect("thanh-toan?mode=buyNow");
                return;
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("loi.jsp");
                return;
            }
        }

        // 🔹 2. XÁC NHẬN THANH TOÁN
        if ("confirm".equals(action)) {
            try {
                int userId = user.getNguoiDungId();
                double tongTien = Double.parseDouble(tongTienStr);
                String diaChiGiao = request.getParameter("diaChiGiao");
                String phuongThuc = request.getParameter("phuongThuc");
                boolean isBuyNow = Boolean.parseBoolean(request.getParameter("isBuyNow"));

                List<ChiTietGioHang> cartItems;
                if (isBuyNow) {
                    ChiTietGioHang item = (ChiTietGioHang) session.getAttribute("buyNowItem");
                    if (item == null) throw new Exception("Không tìm thấy sản phẩm mua ngay!");
                    cartItems = Arrays.asList(item);
                } else {
                    cartItems = gioHangDAO.getByNguoiDungId(userId);
                }

                if (cartItems == null || cartItems.isEmpty()) {
                    throw new Exception("Không có sản phẩm trong giỏ hàng hoặc mua ngay!");
                }

                StringBuilder danhSachSP = new StringBuilder("[");
                for (int i = 0; i < cartItems.size(); i++) {
                    ChiTietGioHang ct = cartItems.get(i);
                    SanPham sp = ct.getSanPham();

                    danhSachSP.append("{\"SanPhamId\":").append(sp.getSanPhamId())
                            .append(",\"SoLuong\":").append(ct.getSoLuong())
                            .append(",\"TenSanPham\":\"").append(sp.getTenSanPham().replace("\"", "\\\""))
                            .append("\",\"GiaBan\":").append(sp.getGiaKhuyenMai() > 0 ? sp.getGiaKhuyenMai() : sp.getGiaBan())
                            .append("}");
                    if (i < cartItems.size() - 1) danhSachSP.append(",");
                }
                danhSachSP.append("]");

                DonHangDAO donHangDAO = new DonHangDAO();
                model.DonHang donHang = new model.DonHang();
                donHang.setKhachHangId(userId);
                donHang.setTongTien(tongTien);
                donHang.setDiaChiGiao(diaChiGiao);
                donHang.setPhiVanChuyen(0);
                donHang.setTrangThai("Chờ xác nhận");
                donHang.setDanhSachSanPham(danhSachSP.toString());

                int donHangId = donHangDAO.insert(donHang);
                if (donHangId <= 0) throw new Exception("Không thể tạo đơn hàng");

                System.out.println("[DEBUG] ✅ Đã tạo đơn hàng #" + donHangId);

                ThanhToanDAO thanhToanDAO = new ThanhToanDAO();
                model.ThanhToan tt = new model.ThanhToan();
                tt.setDonHangId(donHangId);
                tt.setPhuongThuc(phuongThuc != null ? phuongThuc : "COD");
                tt.setSoTien(tongTien);
                tt.setMaGiaoDich(java.util.UUID.randomUUID().toString());
                tt.setTrangThai("Thành công");
                tt.setNgayThanhToan(new java.util.Date());
                tt.setGhiChu("Thanh toán đơn hàng #" + donHangId);

                thanhToanDAO.insert(tt);

                // ✅ GIẢM TỒN KHO (thêm mới, không đổi cấu trúc cũ)
                for (ChiTietGioHang ct : cartItems) {
                    SanPham sp = ct.getSanPham();
                    int soLuongBan = ct.getSoLuong();
                    int tonKhoMoi = sp.getTonKho() - soLuongBan;
                    if (tonKhoMoi < 0) tonKhoMoi = 0;

                    spDao.updateTonKho(sp.getSanPhamId(), tonKhoMoi);
                    System.out.println("[DEBUG] 🔻 Giảm tồn kho SP #" + sp.getSanPhamId() + " còn lại: " + tonKhoMoi);
                }

                if (!isBuyNow) gioHangDAO.clearByNguoiDung(userId);

                System.out.println("[DEBUG] ✅ Thanh toán hoàn tất, quay về TrangChu servlet");
                response.sendRedirect(request.getContextPath() + "/trang-chu");

            } catch (Exception e) {
                System.out.println("[ERROR] ❌ Lỗi khi thanh toán: " + e.getMessage());
                e.printStackTrace();
                request.setAttribute("error", e.getMessage());
                request.getRequestDispatcher("/view/thanhtoan.jsp").forward(request, response);
            }
        }
    }
}
