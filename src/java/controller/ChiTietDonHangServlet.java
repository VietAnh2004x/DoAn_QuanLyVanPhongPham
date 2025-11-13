package controller;

import dao.DonHangDAO;
import dao.SanPhamDAO; // Thêm DAO của SanPham
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.ChiTietDonHang; // Thêm Model mới
import model.DonHang;
import model.NguoiDung;
import model.SanPham; // Thêm Model SanPham
import org.json.JSONArray; // Thêm thư viện JSON
import org.json.JSONObject; // Thêm thư viện JSON

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(urlPatterns = {"/chi-tiet-don-hang"})
public class ChiTietDonHangServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        NguoiDung user = (NguoiDung) session.getAttribute("authUser");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/view/dangnhap.jsp");
            return;
        }

        try {
            int donHangId = Integer.parseInt(request.getParameter("id"));

            // 1. Lấy thông tin đơn hàng chung (như cũ)
            DonHangDAO donHangDAO = new DonHangDAO();
            DonHang donHang = donHangDAO.getById(donHangId);

            // 2. Lấy chuỗi JSON từ đơn hàng
            String jsonString = donHang.getDanhSachSanPham();

            // 3. Chuẩn bị DAO và List mới
            SanPhamDAO sanPhamDAO = new SanPhamDAO(); // (Phải có file SanPhamDAO.java)
            List<ChiTietDonHang> itemList = new ArrayList<>();

            // 4. Đọc chuỗi JSON
            JSONArray jsonArray = new JSONArray(jsonString);
            for (int i = 0; i < jsonArray.length(); i++) {
                JSONObject obj = jsonArray.getJSONObject(i);
                
                int sanPhamId = obj.getInt("SanPhamId");
                int soLuong = obj.getInt("SoLuong");

                // 5. Dùng ID lấy thông tin SanPham
                // (Giả sử bạn có hàm getById trong SanPhamDAO)
                SanPham sp = sanPhamDAO.getSanPhamById(sanPhamId); 

                // 6. Tạo đối tượng mới để hiển thị
                ChiTietDonHang item = new ChiTietDonHang();
                item.setTenSanPham(sp.getTenSanPham());
                item.setHinhAnh(sp.getHinhAnh());
                item.setSoLuong(soLuong);
                
                // Lấy giá. Tốt nhất là giá khuyến mãi (nếu có)
                double donGia = (sp.getGiaKhuyenMai() > 0) ? sp.getGiaKhuyenMai() : sp.getGiaBan();
                item.setDonGia(donGia);
                
                itemList.add(item);
            }

            // 7. Gửi cả 2 thông tin sang JSP
            request.setAttribute("donHang", donHang); // Thông tin chung (tổng tiền, địa chỉ...)
            request.setAttribute("itemList", itemList); // Danh sách sản phẩm (để hiển thị)

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Không thể tải chi tiết đơn hàng: " + e.getMessage());
        }

        request.getRequestDispatcher("/view/chitietdonhang.jsp").forward(request, response);
    }
}