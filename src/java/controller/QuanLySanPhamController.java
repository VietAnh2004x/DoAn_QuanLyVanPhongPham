package controller;

import dao.LoaiSanPhamDAO;
import dao.NhaCungCapDAO;
import dao.SanPhamDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.File;
import java.io.IOException;
import java.util.List;
import model.SanPham;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,       // 1MB
    maxFileSize = 1024 * 1024 * 5,         // 5MB
    maxRequestSize = 1024 * 1024 * 10      // 10MB
)
@WebServlet("/admin/san-pham")
public class QuanLySanPhamController extends HttpServlet {

    private final SanPhamDAO spDAO = new SanPhamDAO();
    private final LoaiSanPhamDAO loaiDAO = new LoaiSanPhamDAO();
    private final NhaCungCapDAO nccDAO = new NhaCungCapDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        model.NguoiDung user = (model.NguoiDung) session.getAttribute("authUser");

        if (user == null || user.getRoleId() != 1) {
            response.sendRedirect(request.getContextPath() + "/dang-nhap");
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) action = "list";

        try {
            switch (action) {
                case "new":
                    request.setAttribute("dsLoai", loaiDAO.getAll());
                    request.setAttribute("dsNCC", nccDAO.getAll());
                    request.getRequestDispatcher("/view/sanpham-form.jsp").forward(request, response);
                    break;

                case "edit":
                    int id = Integer.parseInt(request.getParameter("id"));
                    SanPham sp = spDAO.getSanPhamById(id);
                    if (sp == null) {
                        request.setAttribute("error", "Không tìm thấy sản phẩm có ID = " + id);
                        request.setAttribute("dsLoai", loaiDAO.getAll());
                        request.setAttribute("list", spDAO.search(null, 0));
                        request.getRequestDispatcher("/view/sanpham-list.jsp").forward(request, response);
                        return;
                    }
                    request.setAttribute("sp", sp);
                    request.setAttribute("dsLoai", loaiDAO.getAll());
                    request.setAttribute("dsNCC", nccDAO.getAll());
                    request.getRequestDispatcher("/view/sanpham-form.jsp").forward(request, response);
                    break;

                case "delete":
                    int deleteId = Integer.parseInt(request.getParameter("id"));
                    spDAO.delete(deleteId);
                    response.sendRedirect(request.getContextPath() + "/admin/san-pham");
                    break;

                default:
                    String keyword = request.getParameter("keyword");
                    String loaiIdStr = request.getParameter("loaiId");
                    int loaiId = 0;
                    if (loaiIdStr != null && !loaiIdStr.isEmpty()) {
                        try {
                            loaiId = Integer.parseInt(loaiIdStr);
                        } catch (NumberFormatException e) {
                            loaiId = 0;
                        }
                    }

                    List<SanPham> list = spDAO.search(keyword, loaiId);
                    request.setAttribute("list", list);
                    request.setAttribute("dsLoai", loaiDAO.getAll());
                    request.setAttribute("keyword", keyword);
                    request.setAttribute("loaiId", loaiId);

                    request.getRequestDispatcher("/view/sanpham-list.jsp").forward(request, response);
                    break;
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi xử lý: " + e.getMessage());
            request.setAttribute("dsLoai", loaiDAO.getAll());
            request.getRequestDispatcher("/view/sanpham-list.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        int id = 0;
        String idParam = request.getParameter("sanPhamId");
        if (idParam != null && !idParam.isEmpty()) {
            try {
                id = Integer.parseInt(idParam);
            } catch (NumberFormatException e) {
                id = 0;
            }
        }

        String ten = request.getParameter("tenSanPham");
        double giaNhap = 0, giaBan = 0;
        int tonKho = 0;
        try {
            giaNhap = Double.parseDouble(request.getParameter("giaNhap"));
            giaBan = Double.parseDouble(request.getParameter("giaBan"));
            tonKho = Integer.parseInt(request.getParameter("tonKho"));
        } catch (Exception e) {
            e.printStackTrace();
        }

        String moTa = request.getParameter("moTa");
        String trangThai = request.getParameter("trangThai");
        int loaiId = Integer.parseInt(request.getParameter("loaiId"));
        int nhaCungCapId = Integer.parseInt(request.getParameter("nhaCungCapId"));

        // ===============================
        // XỬ LÝ UPLOAD ẢNH TRÊN Ổ E
        // ===============================
        Part filePart = request.getPart("hinhAnhFile");

        // 🧱 Lưu ảnh vào thư mục cố định trên ổ E
        String uploadPath = "E:\\DoAn_Uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        System.out.println("[DEBUG] Thư mục upload ảnh: " + uploadPath);

        String hinhAnh = null;
        if (id > 0) {
            SanPham existing = spDAO.getSanPhamById(id);
            if (existing != null) {
                hinhAnh = existing.getHinhAnh();
            }
        }

        // ✳️ Nếu người dùng upload ảnh mới
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = new File(filePart.getSubmittedFileName()).getName();

            // ✅ Lưu file thật vào E:\DoAn_Uploads
            String fileSavePath = uploadPath + File.separator + fileName;
            filePart.write(fileSavePath);

            // ✅ Đường dẫn hiển thị trên web
            hinhAnh = request.getContextPath() + "/uploads/" + fileName;
        }

        // ✳️ Nếu không có ảnh, dùng ảnh mặc định
        if (hinhAnh == null || hinhAnh.isEmpty()) {
            hinhAnh = request.getContextPath() + "/assets/upload/no-image.jpg";
        }

        // ===============================
        // LƯU DỮ LIỆU VÀO DATABASE
        // ===============================
        SanPham sp = new SanPham(
                id, ten, loaiId, nhaCungCapId, moTa,
                giaNhap, giaBan, tonKho, hinhAnh,
                (trangThai != null && !trangThai.isEmpty()) ? trangThai : "Đang bán"
        );

        boolean success = (id > 0) ? spDAO.update(sp) : spDAO.insert(sp);
        System.out.println("[DEBUG] ✅ " + (id > 0 ? "Cập nhật" : "Thêm mới") + " sản phẩm: " + success);

        response.sendRedirect(request.getContextPath() + "/admin/san-pham");
    }
}
