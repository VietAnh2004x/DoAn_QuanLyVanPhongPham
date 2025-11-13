package controller;

import dao.DonHangDAO;
import dao.NguoiDungDAO;
import dao.SanPhamDAO;
import dao.ThongKeDao;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/admin")
public class AdminController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        model.NguoiDung user = (model.NguoiDung) session.getAttribute("authUser");

        // ✅ Kiểm tra quyền đăng nhập admin
        if (user == null || user.getRoleId() != 1) {
            response.sendRedirect(request.getContextPath() + "/dang-nhap");
            return;
        }

        // ✅ Lấy thống kê từ DAO
        SanPhamDAO spDAO = new SanPhamDAO();
        DonHangDAO dhDAO = new DonHangDAO();
        NguoiDungDAO ndDAO = new NguoiDungDAO();
        ThongKeDao tkDAO = new ThongKeDao();

        try {
            // --- Thống kê số lượng tổng ---
            int tongSP = spDAO.getAll().size();
            int tongKH = ndDAO.getAll().size();
            int tongDH = dhDAO.getAll().size();
            double tongDoanhThu = dhDAO.getTongDoanhThu();

            // --- Biểu đồ doanh thu + Top sản phẩm ---
            Map<String, Double> doanhThuThang = tkDAO.getDoanhThuTheoThang();
            List<Map<String, Object>> topSanPham = tkDAO.getTopSanPhamBanChay();

            // --- Truyền dữ liệu sang JSP ---
            request.setAttribute("tongSP", tongSP);
            request.setAttribute("tongKH", tongKH);
            request.setAttribute("tongDH", tongDH);
            request.setAttribute("doanhThu", tongDoanhThu);
            request.setAttribute("doanhThuThang", doanhThuThang);
            request.setAttribute("topSanPham", topSanPham);

            // --- Trả về trang Dashboard ---
            request.getRequestDispatcher("/view/dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/view/dashboard.jsp").forward(request, response);
        }
    }
}
