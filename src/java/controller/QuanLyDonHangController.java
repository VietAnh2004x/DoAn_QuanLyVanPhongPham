package controller;

import dao.DonHangDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import java.lang.reflect.Type;
import model.DonHang;

@WebServlet("/admin/don-hang")
public class QuanLyDonHangController extends HttpServlet {

    private final DonHangDAO dao = new DonHangDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        model.NguoiDung user = (model.NguoiDung) session.getAttribute("authUser");

        // ✅ Kiểm tra quyền admin
        if (user == null || user.getRoleId() != 1) {
            response.sendRedirect(request.getContextPath() + "/dang-nhap");
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) action = "list";

        try {
            switch (action) {
                // ======= XEM CHI TIẾT ĐƠN HÀNG =======
                case "view" -> {
                    int id = Integer.parseInt(request.getParameter("id"));
                    DonHang dh = dao.getById(id);

                    if (dh == null) {
                        request.setAttribute("error", "Không tìm thấy đơn hàng #" + id);
                        request.getRequestDispatcher("/view/donhang-list.jsp").forward(request, response);
                        return;
                    }

                    // Parse JSON danh sách sản phẩm
                    String jsonSanPham = dh.getDanhSachSanPham();
                    List<Map<String, Object>> listSanPham = null;
                    if (jsonSanPham != null && !jsonSanPham.trim().isEmpty()) {
                        try {
                            Gson gson = new Gson();
                            Type listType = new TypeToken<List<Map<String, Object>>>() {}.getType();
                            listSanPham = gson.fromJson(jsonSanPham, listType);
                        } catch (Exception e) {
                            System.err.println("[ERROR] ❌ Lỗi parse JSON sản phẩm: " + e.getMessage());
                        }
                    }

                    request.setAttribute("dh", dh);
                    request.setAttribute("listSanPham", listSanPham);
                    request.getRequestDispatcher("/view/donhang-view.jsp").forward(request, response);
                }

                // ======= DANH SÁCH + TÌM KIẾM =======
                case "list" -> {
                    String keyword = request.getParameter("keyword");
                    List<DonHang> list;

                    if (keyword != null && !keyword.trim().isEmpty()) {
                        list = dao.search(keyword.trim());
                        request.setAttribute("keyword", keyword);
                    } else {
                        list = dao.getAll();
                    }

                    request.setAttribute("list", list);
                    request.getRequestDispatcher("/view/donhang-list.jsp").forward(request, response);
                }

                // ======= TRƯỜNG HỢP KHÔNG XÁC ĐỊNH =======
                default -> {
                    request.setAttribute("error", "Hành động không hợp lệ: " + action);
                    request.getRequestDispatcher("/view/donhang-list.jsp").forward(request, response);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi xử lý yêu cầu: " + e.getMessage());
            request.getRequestDispatcher("/view/donhang-list.jsp").forward(request, response);
        }
    }

    // ======= CẬP NHẬT TRẠNG THÁI =======
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            int id = Integer.parseInt(request.getParameter("donHangId"));
            String trangThai = request.getParameter("trangThai");

            boolean result = dao.updateTrangThai(id, trangThai);
            if (result) {
                System.out.println("✅ [OK] Đơn hàng #" + id + " cập nhật trạng thái → " + trangThai);
            } else {
                System.out.println("⚠ [FAIL] Không thể cập nhật đơn hàng #" + id);
            }

            response.sendRedirect(request.getContextPath() + "/admin/don-hang");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi cập nhật trạng thái: " + e.getMessage());
            request.getRequestDispatcher("/view/donhang-list.jsp").forward(request, response);
        }
    }
}
