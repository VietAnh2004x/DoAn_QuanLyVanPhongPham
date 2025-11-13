package controller;

import dao.NguoiDungDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.NguoiDung;
import java.io.IOException;

@WebServlet("/dang-ky") 
public class DangKy extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển đến trang JSP
        request.getRequestDispatcher("/view/dangky.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");

        // Lấy dữ liệu từ form dangky.jsp
        String hoten = request.getParameter("hoten");
        String email = request.getParameter("email");
        String sodienthoai = request.getParameter("sodienthoai");
        String diachi = request.getParameter("diachi");
        String matkhau = request.getParameter("matkhau");
        String nhaplaimatkhau = request.getParameter("nhaplaimatkhau");

        // 1. Kiểm tra mật khẩu có khớp không
        if (!matkhau.equals(nhaplaimatkhau)) {
            request.setAttribute("message", "Mật khẩu nhập lại không khớp!");
            request.getRequestDispatcher("/view/dangky.jsp").forward(request, response);
            return; // Dừng thực hiện
        }

        NguoiDungDAO dao = new NguoiDungDAO();
        
        // 2. Kiểm tra Email đã tồn tại chưa
        if (dao.checkUserExist(email)) {
            request.setAttribute("message", "Email này đã được sử dụng!");
            request.getRequestDispatcher("/view/dangky.jsp").forward(request, response);
            return; // Dừng thực hiện
        }

        // 3. Nếu mọi thứ ổn, tạo đối tượng NguoiDung mới
        NguoiDung newUser = new NguoiDung();
        newUser.setHoTen(hoten);
        newUser.setEmail(email);
        newUser.setMatKhau(matkhau); // Sẽ nói về việc băm mật khẩu ở dưới
        newUser.setSoDienThoai(sodienthoai);
        newUser.setDiaChi(diachi);
        newUser.setNgayDangKy(new java.util.Date());
        
        // Mặc định RoleId = 2 (cho Khách hàng), 1 có thể là Admin
        // Dựa theo CSDL của bạn có bảng Role
        newUser.setRoleId(2); 

        // 4. Thêm vào CSDL
        try {
            dao.insert(newUser);
            // Đăng ký thành công, có thể chuyển hướng về trang đăng nhập
            response.sendRedirect(request.getContextPath() + "/view/dangnhap.jsp"); // Chuyển sang trang đăng nhập
        } catch (IOException e) {
            request.setAttribute("message", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/view/dangky.jsp").forward(request, response);
        }
    }
}