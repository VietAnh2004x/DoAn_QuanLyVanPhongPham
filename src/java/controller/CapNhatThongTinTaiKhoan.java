package controller;

import dao.NguoiDungDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.NguoiDung;

import java.io.IOException;

// Map servlet này với action của form
@WebServlet(urlPatterns = {"/cap-nhat-thong-tin"})
public class CapNhatThongTinTaiKhoan extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        
        // 1. Lấy user hiện tại từ session
        NguoiDung user = (NguoiDung) session.getAttribute("authUser");

        // 2. Kiểm tra nếu chưa đăng nhập thì "đá" về
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/view/dangnhap.jsp");
            return;
        }

        // 3. Lấy thông tin mới từ form
        String hoTen = request.getParameter("hoten");
        String soDienThoai = request.getParameter("sodienthoai");
        String diaChi = request.getParameter("diachi");

        try {
            NguoiDungDAO dao = new NguoiDungDAO();
            
            // 4. Gọi hàm DAO mới để update (xem Bước 3)
            boolean updateSuccess = dao.updateThongTin(user.getNguoiDungId(), hoTen, soDienThoai, diaChi);

            if (updateSuccess) {
                // 5. QUAN TRỌNG: Cập nhật lại thông tin trong session
                user.setHoTen(hoTen);
                user.setSoDienThoai(soDienThoai);
                user.setDiaChi(diaChi);
                session.setAttribute("authUser", user); // Lưu user đã cập nhật
            }
            
            // 6. Chuyển hướng về lại trang thông tin
            response.sendRedirect(request.getContextPath() + "/thong-tin-ca-nhan");

        } catch (Exception e) {
            e.printStackTrace();
            // Nếu lỗi, cũng trả về trang thông tin (có thể thêm thông báo lỗi)
            response.sendRedirect(request.getContextPath() + "/thong-tin-ca-nhan");
        }
    }
}