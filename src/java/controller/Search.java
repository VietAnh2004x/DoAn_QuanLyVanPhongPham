package controller;

import dao.SanPhamDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import model.SanPham;

@WebServlet("/tim-kiem")
public class Search extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8"); 

        try {
            // 1. Lấy TẤT CẢ tham số
            String keyword = request.getParameter("keyword");
            String priceRange = request.getParameter("priceRange"); // (MỚI)
            String sortMode = request.getParameter("sort");       // (MỚI)

            if (keyword == null || keyword.trim().isEmpty()) {
                response.sendRedirect("trang-chu");
                return;
            }

            // 2. Xử lý khoảng giá (priceRange)
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
                        maxGia = null; // Không có giới hạn trên
                        break;
                }
            }

            // 3. Xử lý sắp xếp (sortMode)
            if (sortMode == null || sortMode.trim().isEmpty()) {
                sortMode = "popular"; 
            }

            // 4. Gọi hàm DAO mới (searchAndFilter)
            SanPhamDAO sanPhamDAO = new SanPhamDAO();
            ArrayList<SanPham> listSanPhamTimDuoc = sanPhamDAO.searchAndFilter(keyword, minGia, maxGia, sortMode);

            // 5. Gửi dữ liệu sang JSP
            request.setAttribute("tenDanhMuc", "Kết quả tìm kiếm cho: '" + keyword + "'");
            request.setAttribute("listSanPhamTheoDanhMuc", listSanPhamTimDuoc); 
            
            // Gửi lại các tham số để JSP giữ trạng thái
            request.setAttribute("keyword", keyword);
            request.setAttribute("sortMode", sortMode);
            request.setAttribute("selectedPriceRange", priceRange);

            // 6. Chuyển tiếp 
            request.getRequestDispatcher("view/danhmucsanpham.jsp").forward(request, response);

        } catch (ServletException | IOException e) {
            throw new ServletException("Lỗi khi xử lý tìm kiếm", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Có thể form dùng POST, nên gọi doGet cho chắc
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet xử lý tìm kiếm sản phẩm";
    }
}
