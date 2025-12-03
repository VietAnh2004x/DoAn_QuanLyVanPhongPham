package controller;

import dao.DanhGiaDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

import model.DanhGiaSanPham;
import model.NguoiDung;

@WebServlet("/admin/danh-gia")
public class QuanLyDanhGiaSanPhamController extends HttpServlet {

    private final DanhGiaDAO dao = new DanhGiaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        NguoiDung user =
                (session != null) ? (NguoiDung) session.getAttribute("authUser") : null;

        // ✅ Check admin
        if (user == null || user.getRoleId() != 1) {
            response.sendRedirect(request.getContextPath() + "/dang-nhap");
            return;
        }

        try {
            // ===============================
            // 1. Lấy tham số
            // ===============================
            String keyword = request.getParameter("keyword");
            String diemRaw = request.getParameter("diem");   // ⭐ QUAN TRỌNG
            String sanPhamIdRaw = request.getParameter("sanPhamId");

            Integer sanPhamId = null;
            if (sanPhamIdRaw != null && !sanPhamIdRaw.isBlank()) {
                sanPhamId = Integer.parseInt(sanPhamIdRaw);
            }

            List<DanhGiaSanPham> list;

            // ===============================
            // 2. LOGIC XỬ LÝ
            // ===============================

            // ✅ ƯU TIÊN 1: TÌM KIẾM
            if (keyword != null && !keyword.isBlank()) {

                if (sanPhamId != null) {
                    list = dao.searchDanhGiaBySanPham(sanPhamId, keyword.trim());
                } else {
                    list = dao.searchDanhGia(keyword.trim());
                }

                request.setAttribute("keyword", keyword);

            }
            // ✅ ƯU TIÊN 2: LỌC SAO
            else if (diemRaw != null && !diemRaw.isBlank()) {

                int diem = Integer.parseInt(diemRaw);

                if (sanPhamId != null) {
                    list = dao.filterDanhGiaBySao(sanPhamId, diem);
                } else {
                    list = dao.filterDanhGiaBySao(diem);
                }

                request.setAttribute("diem", diem);
            }
            // ✅ MẶC ĐỊNH
            else {

                if (sanPhamId != null) {
                    list = dao.getDanhGiaBySanPhamId(sanPhamId);
                } else {
                    list = dao.getAllDanhGia();
                }
            }

            // ===============================
            // 3. Gửi sang JSP
            // ===============================
            request.setAttribute("list", list);
            request.setAttribute("sanPhamId", sanPhamId);

            request.getRequestDispatcher("/view/danhgia-list.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải danh sách đánh giá");
            request.getRequestDispatcher("/view/danhgia-list.jsp")
                    .forward(request, response);
        }
    }
}
