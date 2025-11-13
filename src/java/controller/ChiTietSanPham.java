package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import model.*;
import dao.SanPhamDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpSession;

@WebServlet("/chi-tiet-san-pham")
public class ChiTietSanPham extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        try {
            String idStr = request.getParameter("productId"); 

            if (idStr == null || idStr.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu ID sản phẩm (productId).");
                return;
            }

            int productId = Integer.parseInt(idStr); 
            
            SanPhamDAO sanPhamDAO = new SanPhamDAO();
            SanPham sanPham = sanPhamDAO.getSanPhamById(productId); 

            if (sanPham == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy sản phẩm.");
                return;
            }
            
            HttpSession session = request.getSession();
            NguoiDung authUser = (NguoiDung) session.getAttribute("authUser");

            request.setAttribute("sanPham", sanPham); 
            request.setAttribute("authUser", authUser);
            
            request.getRequestDispatcher("view/chitietsanpham.jsp").forward(request, response);

        } catch (ServletException | IOException | NumberFormatException e) { 
            throw new ServletException("Lỗi khi lấy chi tiết sản phẩm", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "Phương thức POST không được hỗ trợ.");
    }
    
    @Override
    public String getServletInfo() {
        return "Servlet hiển thị chi tiết sản phẩm";
    }
}
