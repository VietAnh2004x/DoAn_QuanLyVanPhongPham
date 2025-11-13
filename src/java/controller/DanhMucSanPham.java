package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.*;
import dao.*;
import java.util.ArrayList;
import jakarta.servlet.annotation.WebServlet;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/danh-muc")
public class DanhMucSanPham extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        try {
            // 1. Lấy tất cả tham số
            String idStr = request.getParameter("loaiId");
            String priceRange = request.getParameter("priceRange");
            String sortMode = request.getParameter("sort");

            // 2. Kiểm tra LoaiId
            if (idStr == null || idStr.trim().isEmpty()) {
                response.sendRedirect("trang-chu");
                return;
            }

            // 3. Đặt giá trị mặc định cho Sắp xếp
            if (sortMode == null || sortMode.trim().isEmpty()) {
                sortMode = "popular";
            }

            int loaiId = Integer.parseInt(idStr);

            // --- Khởi tạo DAO ---
            SanPhamDAO sanPhamDAO = new SanPhamDAO();
            LoaiSanPhamDAO loaiSanPhamDAO = new LoaiSanPhamDAO();

            // --- Lấy tên danh mục ---
            LoaiSanPham loaiSP = loaiSanPhamDAO.getLoaiSanPhamById(loaiId);
            String tenDanhMuc = (loaiSP != null) ? loaiSP.getTenLoai() : "Sản phẩm";

            String bannerFile = "banner_tonghop.jpg"; // mặc định

            switch(loaiId) {
                case 1:
                    bannerFile = "banner_but.jpg";
                    break;
                case 6:
                    bannerFile = "banner_vo.png";
                    break;
                case 7:
                    bannerFile = "banner_sach.png";
                    break;
                case 8:
                    bannerFile = "banner_tonghop2.jpg";
                    break;
                case 2:
                    bannerFile = "dungcuhoctap.jpg";
                    break;
                case 5:
                    bannerFile = "butlong.jpg";
                    break;
                case 9:
                    bannerFile = "banner_biahoso.png";
                    break;
                case 4:
                    bannerFile = "banner_giayin.jpg";
                    break;
                case 3:
                    bannerFile = "banner_maytinh.jpg";
                    break;
            }

            // 4. Xử lý khoảng giá
            Double minGia = null;
            Double maxGia = null;

            if (priceRange != null && !priceRange.isEmpty()) {
                switch (priceRange) {
                    case "0-50000":
                        minGia = 0.0;
                        maxGia = 50000.0;
                        break;
                    case "50000-100000":
                        minGia = 50000.0;
                        maxGia = 100000.0;
                        break;
                    case "100000-200000":
                        minGia = 100000.0;
                        maxGia = 200000.0;
                        break;
                    case "200000-500000":
                        minGia = 200000.0;
                        maxGia = 500000.0;
                        break;
                    case "500000-max":
                        minGia = 500000.0;
                        maxGia = null;
                        break;
                }
            }

            // 5. Gọi hàm DAO (Hàm này cần được sửa trong DAO)
            ArrayList<SanPham> listSanPhamTheoDanhMuc = sanPhamDAO.getSanPhamByFilterAndSort(loaiId, minGia, maxGia, sortMode);

            // 6. Gửi dữ liệu sang JSP
            request.setAttribute("tenDanhMuc", tenDanhMuc);
            request.setAttribute("listSanPhamTheoDanhMuc", listSanPhamTheoDanhMuc);
            request.setAttribute("sortMode", sortMode);
            request.setAttribute("selectedPriceRange", priceRange);
            
            // Gửi sang JSP
            request.setAttribute("bannerFile", bannerFile);

            // SỬA ĐƯỜNG DẪN NÀY NẾU FILE JSP CỦA BẠN NẰM Ở THƯ MỤC GỐC
            request.getRequestDispatcher("view/danhmucsanpham.jsp").forward(request, response);

        } catch (ServletException | IOException | NumberFormatException e) { // In lỗi ra
            // In lỗi ra
            throw new ServletException("Lỗi khi tải trang danh mục", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet hiển thị sản phẩm theo danh mục";
    }
}
