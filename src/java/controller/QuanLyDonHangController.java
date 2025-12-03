package controller;

import dao.DonHangDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.lang.reflect.Type;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import dao.ThanhToanDAO;

import model.DonHang;
import model.NguoiDung;

@WebServlet("/admin/don-hang")
public class QuanLyDonHangController extends HttpServlet {

    private final DonHangDAO dao = new DonHangDAO();

    // ================= GET =================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // ✅ CHECK LOGIN + ROLE
        HttpSession session = request.getSession(false);
        NguoiDung user = (session != null)
                ? (NguoiDung) session.getAttribute("authUser")
                : null;

        if (user == null || user.getRoleId() != 1) {
            response.sendRedirect(request.getContextPath() + "/dang-nhap");
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.isBlank()) {
            action = "list";
        }

        switch (action) {
            case "view":
                handleView(request, response);
                break;

            case "print":
                handlePrint(request, response);
                break;

            case "list":
                handleList(request, response);
                break;

            default:
                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Action không hợp lệ: " + action
                );
        }
    }

    // ================= CHI TIẾT ĐƠN HÀNG =================
    private void handleView(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = parseId(request, response);
        if (id == -1) return;

        DonHang dh = dao.getById(id);
        if (dh == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND,
                    "Không tìm thấy đơn hàng ID = " + id);
            return;
        }

        List<Map<String, Object>> listSanPham =
                parseSanPhamJson(dh.getDanhSachSanPham());

        request.setAttribute("dh", dh);
        request.setAttribute("listSanPham", listSanPham);

        request.getRequestDispatcher("/view/donhang-view.jsp")
                .forward(request, response);
    }

    // ================= IN HÓA ĐƠN =================
    private void handlePrint(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = parseId(request, response);
        if (id == -1) return;

        DonHang dh = dao.getById(id);
        if (dh == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND,
                    "Không tìm thấy đơn hàng ID = " + id);
            return;
        }

        List<Map<String, Object>> listSanPham =
                parseSanPhamJson(dh.getDanhSachSanPham());

        request.setAttribute("dh", dh);
        request.setAttribute("listSanPham", listSanPham);

        // ✅ chỉ render hoadon.jsp – dùng window.print()
        request.getRequestDispatcher("/view/hoadon.jsp")
                .forward(request, response);
    }

    // ================= DANH SÁCH ĐƠN HÀNG =================
    private void handleList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");

        List<DonHang> list =
                (keyword != null && !keyword.isBlank())
                        ? dao.search(keyword.trim())
                        : dao.getAll();

        request.setAttribute("list", list);
        request.getRequestDispatcher("/view/donhang-list.jsp")
                .forward(request, response);
    }

    // ================= PARSE ID =================
    private int parseId(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            return Integer.parseInt(request.getParameter("id"));
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "ID đơn hàng không hợp lệ");
            return -1;
        }
    }

    // ================= PARSE JSON SP =================
    private List<Map<String, Object>> parseSanPhamJson(String json) {

        if (json == null || json.isBlank()) return List.of();

        try {
            Gson gson = new Gson();
            Type type = new TypeToken<List<Map<String, Object>>>() {}.getType();
            return gson.fromJson(json, type);
        } catch (Exception e) {
            return List.of();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("donHangId"));
        String trangThai = request.getParameter("trangThai");

        // ✅ Update trạng thái
        dao.updateTrangThai(id, trangThai);

        // ✅ CHỈ TRỪ KHO KHI ĐƠN = "Hoàn tất"
        if ("Hoàn tất".equals(trangThai)) {
            ThanhToanDAO ttDao = new ThanhToanDAO();
            ttDao.capNhatTonKhoTheoDonHang(id);
        }

        response.sendRedirect(request.getContextPath() + "/admin/don-hang");
    }

}
