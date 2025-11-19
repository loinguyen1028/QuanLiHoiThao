package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnect {
    // Kết nối đến database mới: quan_li_hoi_thao
    // Thêm tham số ?useSSL=false&allowPublicKeyRetrieval=true để tránh lỗi bảo mật của MySQL 8.0+
    private static final String URL = "jdbc:mysql://localhost:3306/quan_li_hoi_thao?useSSL=false&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASSWORD = "26072003"; // Mật khẩu của bạn

    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            System.out.println("❌ Lỗi kết nối CSDL: " + e.getMessage());
        }
        return conn;
    }
}