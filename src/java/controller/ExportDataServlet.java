package controller;

import dao.DonHangDAO;
import dao.NguoiDungDAO;
import dao.SanPhamDAO;
import model.DonHang;
import model.NguoiDung;
import model.SanPham;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.List;

// Đổi URL pattern thành /export-excel cho chung
@WebServlet(name = "ExportDataServlet", urlPatterns = {"/export-excel"})
public class ExportDataServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Check quyền Admin
        HttpSession session = request.getSession();
        NguoiDung user = (NguoiDung) session.getAttribute("authUser");
        if (user == null || user.getRoleId() != 1) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền admin.");
            return;
        }

        // 2. Lấy tham số 'type' để biết xuất bảng nào (product | user | order)
        String type = request.getParameter("type");
        if (type == null) type = "product"; // Mặc định là sản phẩm

        try (XSSFWorkbook workbook = new XSSFWorkbook()) {
            
            // Dùng switch để chọn hàm xử lý tương ứng
            switch (type) {
                case "user":
                    exportNguoiDung(workbook, request);
                    break;
                case "order":
                    exportDonHang(workbook, request);
                    break;
                case "product":
                default:
                    exportSanPham(workbook, request);
                    break;
            }

            // 3. Thiết lập Header trả về file
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            
            // Đặt tên file động theo loại
            String fileName = "Export_Data.xlsx";
            if(type.equals("user")) fileName = "DanhSachNguoiDung.xlsx";
            else if(type.equals("order")) fileName = "DanhSachDonHang.xlsx";
            else fileName = "DanhSachSanPham.xlsx";
            
            response.setHeader("Content-Disposition", "attachment; filename=" + fileName);

            // 4. Ghi ra luồng output
            try (OutputStream out = response.getOutputStream()) {
                workbook.write(out);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi xuất file: " + e.getMessage());
        }
    }

    // =========================================================
    // HÀM XỬ LÝ RIÊNG CHO SẢN PHẨM (Code cũ của bạn)
    // =========================================================
    private void exportSanPham(XSSFWorkbook workbook, HttpServletRequest request) {
        Sheet sheet = workbook.createSheet("Sản Phẩm");
        
        // Lấy dữ liệu (giữ nguyên logic tìm kiếm của bạn)
        String keyword = request.getParameter("keyword");
        String loaiIdStr = request.getParameter("loaiId");
        int loaiId = (loaiIdStr != null && !loaiIdStr.isEmpty()) ? Integer.parseInt(loaiIdStr) : 0;
        
        SanPhamDAO dao = new SanPhamDAO();
        List<SanPham> list = dao.search(keyword, loaiId); // Giả sử bạn đã có hàm search này

        // Tạo Header
        String[] headers = {"ID", "Tên sản phẩm", "Giá nhập", "Giá bán", "Tồn kho", "Trạng thái"};
        createHeader(workbook, sheet, headers);

        // Tạo Data
        int rowNum = 1;
        CellStyle numberStyle = createCurrencyStyle(workbook);
        
        for (SanPham sp : list) {
            Row row = sheet.createRow(rowNum++);
            row.createCell(0).setCellValue(sp.getSanPhamId());
            row.createCell(1).setCellValue(sp.getTenSanPham());
            
            Cell cellGiaNhap = row.createCell(2);
            cellGiaNhap.setCellValue(sp.getGiaNhap());
            cellGiaNhap.setCellStyle(numberStyle);

            Cell cellGiaBan = row.createCell(3);
            cellGiaBan.setCellValue(sp.getGiaBan());
            cellGiaBan.setCellStyle(numberStyle);

            row.createCell(4).setCellValue(sp.getTonKho());
            row.createCell(5).setCellValue(sp.getTrangThai());
        }
        autoSizeColumns(sheet, headers.length);
    }

    // =========================================================
    // HÀM XỬ LÝ RIÊNG CHO NGƯỜI DÙNG (Mới)
    // =========================================================
    private void exportNguoiDung(XSSFWorkbook workbook, HttpServletRequest request) {
        Sheet sheet = workbook.createSheet("Người Dùng");

        NguoiDungDAO dao = new NguoiDungDAO();
        // Bạn có thể thêm logic search cho user nếu muốn, ở đây tôi lấy all
        List<NguoiDung> list = dao.getAll(); 

        String[] headers = {"ID", "Họ tên", "Email", "Số điện thoại", "Địa chỉ", "Vai trò (1=Admin)"};
        createHeader(workbook, sheet, headers);

        int rowNum = 1;
        for (NguoiDung u : list) {
            Row row = sheet.createRow(rowNum++);
            row.createCell(0).setCellValue(u.getNguoiDungId());
            row.createCell(1).setCellValue(u.getHoTen());
            row.createCell(2).setCellValue(u.getEmail());
            row.createCell(3).setCellValue(u.getSoDienThoai());
            row.createCell(4).setCellValue(u.getDiaChi());
            
            // Xử lý Role cho dễ hiểu
            String role = (u.getRoleId() == 1) ? "Admin" : "Khách hàng";
            row.createCell(5).setCellValue(role);
        }
        autoSizeColumns(sheet, headers.length);
    }

    // =========================================================
    // HÀM XỬ LÝ RIÊNG CHO ĐƠN HÀNG (Mới)
    // =========================================================
    private void exportDonHang(XSSFWorkbook workbook, HttpServletRequest request) {
        Sheet sheet = workbook.createSheet("Đơn Hàng");

        DonHangDAO dao = new DonHangDAO();
        List<DonHang> list = dao.getAll();

        String[] headers = {"Mã ĐH", "Khách hàng ID", "Ngày đặt", "Tổng tiền", "Trạng thái", "Địa chỉ giao"};
        createHeader(workbook, sheet, headers);

        int rowNum = 1;
        CellStyle currencyStyle = createCurrencyStyle(workbook);
        // Format ngày tháng
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");

        for (DonHang dh : list) {
            Row row = sheet.createRow(rowNum++);
            row.createCell(0).setCellValue(dh.getDonHangId());
            row.createCell(1).setCellValue(dh.getKhachHangId()); // Có thể join tên khách nếu muốn
            
            // Xử lý ngày
            String ngayDat = (dh.getNgayDat() != null) ? sdf.format(dh.getNgayDat()) : "";
            row.createCell(2).setCellValue(ngayDat);
            
            Cell cellTien = row.createCell(3);
            cellTien.setCellValue(dh.getTongTien());
            cellTien.setCellStyle(currencyStyle);
            
            row.createCell(4).setCellValue(dh.getTrangThai());
            row.createCell(5).setCellValue(dh.getDiaChiGiao());
        }
        autoSizeColumns(sheet, headers.length);
    }

    // ==================== CÁC HÀM TIỆN ÍCH CHUNG (HELPER) ====================
    
    private void createHeader(XSSFWorkbook workbook, Sheet sheet, String[] columns) {
        Row headerRow = sheet.createRow(0);
        CellStyle headerStyle = workbook.createCellStyle();
        Font font = workbook.createFont();
        font.setBold(true);
        headerStyle.setFont(font);
        headerStyle.setFillForegroundColor(IndexedColors.LIGHT_GREEN.getIndex());
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);

        for (int i = 0; i < columns.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(columns[i]);
            cell.setCellStyle(headerStyle);
        }
    }

    private CellStyle createCurrencyStyle(XSSFWorkbook workbook) {
        CellStyle style = workbook.createCellStyle();
        DataFormat format = workbook.createDataFormat();
        style.setDataFormat(format.getFormat("#,##0")); // Format số: 100,000
        return style;
    }
    
    private void autoSizeColumns(Sheet sheet, int colCount) {
        for (int i = 0; i < colCount; i++) {
            sheet.autoSizeColumn(i);
        }
    }
}