package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.NguoiDung;

import java.io.IOException;

// Map servlet này với link mà bạn đã sửa ở Bước 1
@WebServlet(urlPatterns = {"/thong-tin-ca-nhan"})
public class ThongTinTaiKhoan extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // Lấy tài khoản từ session
        NguoiDung user = (NguoiDung) session.getAttribute("authUser");
        
        if (user != null) {
            // Nếu đã đăng nhập, chuyển tiếp đến trang thông tin
            request.getRequestDispatcher("/view/thongtintaikhoan.jsp").forward(request, response);
        } else {
            // Nếu chưa đăng nhập, đá về trang đăng nhập
            response.sendRedirect(request.getContextPath() + "/view/dangnhap.jsp");
        }
    }
}