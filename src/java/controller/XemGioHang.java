package controller;

import dao.ChiTietGioHangDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.ChiTietGioHang;
import model.NguoiDung;

@WebServlet("/xem-gio-hang")
public class XemGioHang extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("[DEBUG] Vào servlet XemGioHang (GET)");
        HttpSession session = request.getSession();
        NguoiDung authUser = (NguoiDung) session.getAttribute("authUser");

        if (authUser == null) {
            System.out.println("[DEBUG] ❌ Chưa đăng nhập -> redirect sang dang-nhap");
            response.sendRedirect("dang-nhap");
            return;
        }

        int userId = authUser.getNguoiDungId();
        ChiTietGioHangDAO dao = new ChiTietGioHangDAO();

        List<ChiTietGioHang> cartItems = dao.getByNguoiDungId(userId);
        double cartTotal = dao.tinhTongTienGioHang(userId);

        // ✅ Gửi dữ liệu sang JSP
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("cartTotal", cartTotal);

        System.out.println("[DEBUG] ✅ Forward sang view/giohang.jsp (cartTotal=" + cartTotal + ")");
        request.getRequestDispatcher("view/giohang.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("[DEBUG] Vào servlet XemGioHang (POST)");
        HttpSession session = request.getSession();
        NguoiDung authUser = (NguoiDung) session.getAttribute("authUser");

        if (authUser == null) {
            System.out.println("[DEBUG] ❌ Chưa đăng nhập -> redirect dang-nhap");
            response.sendRedirect("dang-nhap");
            return;
        }

        // 🔹 Khi bấm "Tiến hành đặt hàng" -> chuyển sang servlet ThanhToan
        String action = request.getParameter("action");
        if ("checkout".equals(action)) {
            System.out.println("[DEBUG] ✅ Nhấn nút Tiến hành đặt hàng, chuyển sang ThanhToan");
            response.sendRedirect("thanh-toan"); // GET sang trang thanh toán
            return;
        }

        // Trường hợp khác có thể xử lý sau (xóa, cập nhật, v.v.)
        doGet(request, response);
    }
}
