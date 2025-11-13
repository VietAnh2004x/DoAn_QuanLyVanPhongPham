package controller;

import dao.*;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.io.PrintWriter;
import model.NguoiDung;

@WebServlet("/them-gio-hang")
public class GioHang extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession();
        NguoiDung authUser = (NguoiDung) session.getAttribute("authUser");

        if (authUser == null) {
            out.print("{\"requireLogin\": true}");
            return;
        }

        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            // --- Lấy giỏ hàng hoặc tạo mới ---
            GioHangDAO ghDao = new GioHangDAO();
            int gioHangId = ghDao.createIfNotExist(authUser.getNguoiDungId());
            if (gioHangId <= 0) {
                out.print("{\"success\": false, \"message\": \"Không tạo được giỏ hàng!\"}");
                return;
            }

            // --- Thêm vào chi tiết giỏ hàng ---
            ChiTietGioHangDAO ctDao = new ChiTietGioHangDAO();
            boolean added = ctDao.addOrUpdate(gioHangId, productId, quantity);
            if (!added) {
                out.print("{\"success\": false, \"message\": \"Không thể thêm sản phẩm!\"}");
                return;
            }

            // --- Lấy lại số lượng thực tế từ DB ---
            NguoiDungDAO ndDao = new NguoiDungDAO();
            int cartCount = ndDao.getTongSanPham(authUser.getNguoiDungId());

            out.print(String.format("{\"success\": true, \"cartCount\": %d}", cartCount));

        } catch (NumberFormatException e) {
            out.print("{\"success\": false, \"message\": \"Lỗi: " + e.getMessage() + "\"}");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
    }
}
