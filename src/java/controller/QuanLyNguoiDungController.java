package controller;

import dao.NguoiDungDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List; // ⚠️ Cần import java.util.List
import model.NguoiDung;

@WebServlet("/admin/nguoi-dung")
public class QuanLyNguoiDungController extends HttpServlet {

    private final NguoiDungDAO dao = new NguoiDungDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        model.NguoiDung user = (model.NguoiDung) session.getAttribute("authUser");

        // ✅ Kiểm tra đăng nhập & quyền Admin (Giữ nguyên, rất tốt)
        if (user == null || user.getRoleId() != 1) {
            response.sendRedirect(request.getContextPath() + "/dang-nhap");
            return;
        }

        try {
            // === LOGIC MỚI: TÌM KIẾM & HIỂN THỊ DANH SÁCH ===
            
            // 1. Lấy từ khóa tìm kiếm từ JSP
            String keyword = request.getParameter("keyword");
            
            List<NguoiDung> list;

            // 2. Kiểm tra xem người dùng có tìm kiếm hay không
            if (keyword != null && !keyword.trim().isEmpty()) {
                // Nếu có, gọi phương thức search (bạn cần tạo phương thức này trong DAO)
                list = dao.search(keyword); 
                
                // Giữ lại từ khóa để hiển thị lại trên ô tìm kiếm
                request.setAttribute("keyword", keyword); 
            } else {
                // Nếu không, lấy tất cả người dùng như cũ
                list = dao.getAll();
            }

            // 3. Gửi danh sách (đã lọc hoặc đầy đủ) sang JSP
            request.setAttribute("list", list);
            
           
            request.getRequestDispatcher("/view/nguoidung-list.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải danh sách: " + e.getMessage());
            // ⚠️ Đảm bảo tệp JSP đẹp của bạn nằm ở đường dẫn này
            request.getRequestDispatcher("/view/nguoidung-list.jsp").forward(request, response);
        }
    }

    
    
}