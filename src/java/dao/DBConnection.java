package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL = "jdbc:mysql://localhost:3306/vanphongpham?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = ""; // nếu bạn có mật khẩu MySQL thì điền vào đây

    public static Connection getConnection() {
        Connection conn = null;
        try {
            // ✅ Driver chính xác cho MySQL 8 trở lên
            Class.forName("com.mysql.cj.jdbc.Driver");

            conn = DriverManager.getConnection(URL, USER, PASSWORD);

            // ✅ RẤT QUAN TRỌNG: đảm bảo mọi insert/update được lưu ngay lập tức
            conn.setAutoCommit(true);

            System.out.println("[DEBUG] ✅ Kết nối MySQL thành công!");
        } catch (ClassNotFoundException e) {
            System.out.println("[ERROR] Không tìm thấy MySQL JDBC Driver: " + e.getMessage());
        } catch (SQLException e) {
            System.out.println("[ERROR] Kết nối MySQL thất bại: " + e.getMessage());
        }
        return conn;
    }
}
