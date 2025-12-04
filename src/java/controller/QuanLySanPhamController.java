package controller;

import dao.LoaiSanPhamDAO;
import dao.NhaCungCapDAO;
import dao.SanPhamDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.List;
import model.SanPham;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 5,
        maxRequestSize = 1024 * 1024 * 10
)
@WebServlet("/admin/san-pham")
public class QuanLySanPhamController extends HttpServlet {

    private final SanPhamDAO spDAO = new SanPhamDAO();
    private final LoaiSanPhamDAO loaiDAO = new LoaiSanPhamDAO();
    private final NhaCungCapDAO nccDAO = new NhaCungCapDAO();

    private String getAutoUploadPath() {
        String[] drives = {"D:", "E:", "C:"};

        for (String d : drives) {
            File dir = new File(d + "/DoAn_Uploads");
            if (dir.exists() || dir.mkdirs()) {
                return dir.getAbsolutePath();
            }
        }
        throw new RuntimeException("Không tìm thấy ổ đĩa hợp lệ để lưu ảnh!");
    }

    private String getFolderName(int loaiId) {
        switch (loaiId) {
            case 1:
                return "balo";
            case 2:
                return "but";
            case 3:
                return "vo";
            case 4:
                return "hopbut";
            default:
                return "khac";
        }
    }

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
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "new":
                request.setAttribute("dsLoai", loaiDAO.getAll());
                request.setAttribute("dsNCC", nccDAO.getAll());
                request.getRequestDispatcher("/view/sanpham-form.jsp").forward(request, response);
                break;

            case "edit":
                int id = Integer.parseInt(request.getParameter("id"));
                SanPham sp = spDAO.getSanPhamById(id);

                request.setAttribute("sp", sp);
                request.setAttribute("dsLoai", loaiDAO.getAll());
                request.setAttribute("dsNCC", nccDAO.getAll());
                request.getRequestDispatcher("/view/sanpham-form.jsp").forward(request, response);
                break;

            case "delete":
                String idRaw = request.getParameter("sanPhamId");
                if (idRaw == null || idRaw.isEmpty()) {
                    idRaw = request.getParameter("id");
                }

                int deleteId = Integer.parseInt(idRaw);
                spDAO.delete(deleteId);

                response.sendRedirect(request.getContextPath() + "/admin/san-pham");
                break;

            default:
                String keyword = request.getParameter("keyword");
                int loaiId = request.getParameter("loaiId") != null ? Integer.parseInt(request.getParameter("loaiId")) : 0;

                List<SanPham> list = spDAO.search(keyword, loaiId);
                request.setAttribute("list", list);
                request.setAttribute("dsLoai", loaiDAO.getAll());
                request.getRequestDispatcher("/view/sanpham-list.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        int id = 0;
        try {
            id = Integer.parseInt(request.getParameter("sanPhamId"));
        } catch (Exception ignored) {
        }

        String ten = request.getParameter("tenSanPham");
        double giaNhap = Double.parseDouble(request.getParameter("giaNhap"));
        double giaBan = Double.parseDouble(request.getParameter("giaBan"));
        int tonKho = Integer.parseInt(request.getParameter("tonKho"));
        String moTa = request.getParameter("moTa");
        String trangThai = request.getParameter("trangThai");
        int loaiId = Integer.parseInt(request.getParameter("loaiId"));
        int nhaCungCapId = Integer.parseInt(request.getParameter("nhaCungCapId"));

        // ===== LẤY TÊN FOLDER THEO LOẠI =====
        String folderLoai = getFolderName(loaiId); // balo/but/hopbut/...

        // ===== THƯ MỤC THẬT TRONG WEB APP =====
        String realPath = request.getServletContext().getRealPath("/assets/image/" + folderLoai);

        File uploadFolder = new File(realPath);
        if (!uploadFolder.exists()) {
            uploadFolder.mkdirs();
        }

        Part filePart = request.getPart("hinhAnhFile");

        String hinhAnh = null;

        // Nếu update → giữ ảnh cũ
        if (id > 0) {
            SanPham spOld = spDAO.getSanPhamById(id);
            if (spOld != null) {
                hinhAnh = spOld.getHinhAnh();
            }
        }

        // Nếu upload ảnh mới
        if (filePart != null && filePart.getSize() > 0) {

            String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();

            File savedFile = new File(uploadFolder, fileName);

            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, savedFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
            }

            // 👉 ĐƯỜNG DẪN CHUẨN ĐỂ JSP LOAD ĐƯỢC
            hinhAnh = "/assets/image/" + folderLoai + "/" + fileName;
        }

        if (hinhAnh == null) {
            hinhAnh = "/assets/upload/no-image.jpg";
        }

        SanPham sp = new SanPham(id, ten, loaiId, nhaCungCapId, moTa,
                giaNhap, giaBan, tonKho, hinhAnh, trangThai);

        if (id > 0) {
            spDAO.update(sp);
        } else {
            spDAO.insert(sp);
        }

        response.sendRedirect(request.getContextPath() + "/admin/san-pham");
    }
}
