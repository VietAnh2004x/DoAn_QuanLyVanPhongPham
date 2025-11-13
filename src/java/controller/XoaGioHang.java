package controller;

import dao.ChiTietGioHangDAO;
import dao.GioHangDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import model.NguoiDung;

@WebServlet("/xoa-gio-hang")
public class XoaGioHang extends HttpServlet {
    private ChiTietGioHangDAO chiTietDAO = new ChiTietGioHangDAO();
    private GioHangDAO gioHangDAO = new GioHangDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        NguoiDung user = (NguoiDung) session.getAttribute("authUser");

        if (user == null) {
            response.getWriter().write("fail");
            return;
        }
        
        if (Boolean.TRUE.equals(session.getAttribute("BUY_NOW_ACTIVE"))) {
            response.getWriter().write("ignored-buynow");
            return;
        }

        int userId = user.getNguoiDungId();
        var gioHang = gioHangDAO.getByKhachHangId(userId);

        if (gioHang != null && chiTietDAO.clear(gioHang.getGioHangId())) {
            response.getWriter().write("success");
        } else {
            response.getWriter().write("fail");
        }
    }
}
