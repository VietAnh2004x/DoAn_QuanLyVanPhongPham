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

// Map servlet này với link bạn vừa tạo
@WebServlet(urlPatterns = {"/doi-mat-khau"})
public class DoiMatKhau extends HttpServlet {

    // HIỂN THỊ TRANG ĐỔI MẬT KHẨU
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        if (session.getAttribute("authUser") == null) {
            // Nếu chưa đăng nhập, đá về trang login
            response.sendRedirect(request.getContextPath() + "/view/dangnhap.jsp");
        } else {
            // Nếu đã đăng nhập, chuyển đến trang
            request.getRequestDispatcher("/view/doimatkhau.jsp").forward(request, response);
        }
    }

    // XỬ LÝ VIỆC ĐỔI MẬT KHẨU
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        NguoiDung user = (NguoiDung) session.getAttribute("authUser");

        // 1. Kiểm tra đăng nhập
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/view/dangnhap.jsp");
            return;
        }

        // 2. Lấy dữ liệu từ form
        String matKhauCu = request.getParameter("matkhaucu");
        String matKhauMoi = request.getParameter("matkhaumoi");
        String xacNhanMatKhau = request.getParameter("xacnhanmatkhau");

        // 3. Xử lý logic
        NguoiDungDAO dao = new NguoiDungDAO();

        try {
            // Kiểm tra mật khẩu cũ có đúng không
            if (!user.getMatKhau().equals(matKhauCu)) {
                request.setAttribute("errorMessage", "Mật khẩu cũ không chính xác!");
                request.getRequestDispatcher("/view/doimatkhau.jsp").forward(request, response);
                return;
            }

            // Kiểm tra mật khẩu mới có khớp không
            if (!matKhauMoi.equals(xacNhanMatKhau)) {
                request.setAttribute("errorMessage", "Mật khẩu mới và xác nhận không khớp!");
                request.getRequestDispatcher("/view/doimatkhau.jsp").forward(request, response);
                return;
            }

            // Mọi thứ OK, gọi DAO để cập nhật
            boolean updateSuccess = dao.updatePassword(user.getNguoiDungId(), matKhauMoi);

            if (updateSuccess) {
                // Cập nhật lại session (rất quan trọng)
                user.setMatKhau(matKhauMoi);
                session.setAttribute("authUser", user);
                
                request.setAttribute("successMessage", "Đổi mật khẩu thành công!");
            } else {
                request.setAttribute("errorMessage", "Không thể cập nhật mật khẩu. Vui lòng thử lại.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
        }

        // 4. Trả về trang
        request.getRequestDispatcher("/view/doimatkhau.jsp").forward(request, response);
    }
}