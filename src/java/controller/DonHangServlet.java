package controller;

import dao.DonHangDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.DonHang;
import model.NguoiDung;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/don-hang"})
public class DonHangServlet extends HttpServlet {

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
            // Lấy ID người dùng (từ model NguoiDung)
            int khachHangId = user.getNguoiDungId(); 
            
            DonHangDAO dao = new DonHangDAO();
            // Gọi hàm DAO đã sửa, dùng khachHangId
            List<DonHang> listDonHang = dao.getDonHangByKhachHangId(khachHangId);

            request.setAttribute("listDonHang", listDonHang);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Không thể tải lịch sử đơn hàng: " + e.getMessage());
        }
        
        request.getRequestDispatcher("/view/donhang.jsp").forward(request, response);
    }
}