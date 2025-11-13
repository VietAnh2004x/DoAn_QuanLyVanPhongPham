package controller;

import dao.ChiTietGioHangDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/xoa-chi-tiet-gio-hang")
public class XoaChiTietGioHang extends HttpServlet {
    private ChiTietGioHangDAO dao = new ChiTietGioHangDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        boolean ok = dao.remove(id);
        response.getWriter().write(ok ? "success" : "fail");
    }
}
