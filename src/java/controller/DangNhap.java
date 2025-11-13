package controller;

import dao.NguoiDungDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.NguoiDung;

@WebServlet("/dang-nhap")
public class DangNhap extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Nếu đã đăng nhập rồi thì không cần vào lại trang đăng nhập
        HttpSession session = request.getSession(false);
        NguoiDung authUser = (session != null) ? (NguoiDung) session.getAttribute("authUser") : null;

        if (authUser != null) {
            // Nếu là admin => chuyển thẳng vào trang quản trị
            if (authUser.getRoleId() == 1) {
                response.sendRedirect(request.getContextPath() + "/admin");
                return;
            }
            // Nếu là user => về trang chủ
            response.sendRedirect(request.getContextPath() + "/trang-chu");
            return;
        }

        // Chưa đăng nhập => hiện form đăng nhập
        request.getRequestDispatcher("/view/dangnhap.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String matKhau = request.getParameter("matkhau");

        // Kiểm tra dữ liệu nhập
        if (email == null || email.isEmpty() || matKhau == null || matKhau.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ Email và Mật khẩu!");
            request.getRequestDispatcher("/view/dangnhap.jsp").forward(request, response);
            return;
        }

        // Gọi DAO để xác thực người dùng
        NguoiDungDAO dao = new NguoiDungDAO();
        NguoiDung user = dao.login(email, matKhau);

        if (user != null) {
            // ✅ Đăng nhập thành công
            HttpSession session = request.getSession();
            session.setAttribute("authUser", user);

            System.out.println("[DEBUG] Đăng nhập thành công - Email: " + email + ", Role: " + user.getRoleId());

            // ✅ Phân quyền theo RoleId
            if (user.getRoleId() == 1) {
                // Admin => vào trang quản trị
                response.sendRedirect(request.getContextPath() + "/admin");
            } else {
                // User => về trang chủ
                response.sendRedirect(request.getContextPath() + "/trang-chu");
            }

        } else {
            // ❌ Sai thông tin đăng nhập
            System.out.println("[ERROR] Đăng nhập thất bại - Email: " + email);
            request.setAttribute("error", "Email hoặc mật khẩu không đúng!");
            request.getRequestDispatcher("/view/dangnhap.jsp").forward(request, response);
        }
    }
}
