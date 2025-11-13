package controller;

import dao.ChiTietGioHangDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/cap-nhat-so-luong")
public class ChiTietGioHang extends HttpServlet {
    private ChiTietGioHangDAO dao = new ChiTietGioHangDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        int soLuong = Integer.parseInt(request.getParameter("soLuong"));

        boolean ok = dao.updateSoLuong(id, soLuong);
        response.getWriter().write(ok ? "success" : "fail");
    }
}
