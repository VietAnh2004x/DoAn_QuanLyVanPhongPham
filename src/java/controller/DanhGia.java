package controller;

import dao.DanhGiaDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.DanhGiaSanPham;
import model.NguoiDung;

@WebServlet("/danh-gia")
public class DanhGia extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        // 1. Kiểm tra xem người dùng đã đăng nhập chưa
        NguoiDung authUser = (NguoiDung) session.getAttribute("authUser");
        
        // Lấy ID sản phẩm từ form (input ẩn)
        String sanPhamIdStr = request.getParameter("productId");
        
        if (authUser == null) {
            response.sendRedirect("dang-nhap?redirect=chi-tiet-san-pham?productId=" + sanPhamIdStr);
            return;
        }

        try {
            // 2. Lấy dữ liệu từ form
            int sanPhamId = Integer.parseInt(sanPhamIdStr);
            int khachHangId = authUser.getNguoiDungId(); // Lấy ID từ session
            int diem = Integer.parseInt(request.getParameter("rating")); // Lấy điểm sao
            String noiDung = request.getParameter("comment"); // Lấy nội dung
            
            // 3. Tạo đối tượng DanhGia
            DanhGiaSanPham dg = new DanhGiaSanPham();
            dg.setSanPhamId(sanPhamId);
            dg.setKhachHangId(khachHangId);
            dg.setDiem(diem);
            dg.setNoiDung(noiDung);
            // NgayDanhGia sẽ được set tự động trong DAO (NOW())

            // 4. Gọi DAO để lưu
            DanhGiaDAO danhGiaDAO = new DanhGiaDAO();
            boolean thanhCong = danhGiaDAO.insert(dg);

            // 5. Chuyển hướng người dùng quay lại trang sản phẩm
            response.sendRedirect("chi-tiet-san-pham?productId=" + sanPhamId);

        } catch (IOException | NumberFormatException e) {
            // Xử lý lỗi (ví dụ: gửi về trang lỗi)
            response.sendRedirect("chi-tiet-san-pham?productId=" + sanPhamIdStr + "&error=true");
        }
    }
}
