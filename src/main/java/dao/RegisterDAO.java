package dao;

import model.Register;
import utils.DataSourceUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RegisterDAO {

    // ✅ Thêm đăng ký mới vào bảng registrations
    public boolean insert(Register r) {
        // Chỉ insert các cột cần thiết, phần còn lại dùng DEFAULT trong DB
        String sql = "INSERT INTO registrations " +
                "(seminar_id, name, email, phone, user_type) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DataSourceUtil.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, r.getSeminarId());      // FK tới seminar.id
            ps.setString(2, r.getName());        // cột name
            ps.setString(3, r.getEmail());       // cột email
            ps.setString(4, r.getPhone());       // cột phone
            ps.setString(5, r.getUserType());    // cột user_type

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Trong RegisterDAO

    // Lấy danh sách đăng ký theo category_id (1: Môi trường, 2: Công nghệ, 3: Khoa học)
    public List<Register> getByCategoryId(int categoryId) {
        List<Register> list = new ArrayList<>();

        String sql = "SELECT r.id, r.seminar_id, r.register_date, r.registration_code, " +
                "       r.is_vip, r.checkin_time, r.name, r.email, r.password, r.phone, r.user_type " +
                "FROM registrations r " +
                "JOIN seminar s ON r.seminar_id = s.id " +
                "WHERE s.category_id = ? " +
                "ORDER BY r.register_date DESC";

        try (Connection conn = DataSourceUtil.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, categoryId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Register r = new Register();
                r.setId(rs.getInt("id"));
                r.setSeminarId(rs.getInt("seminar_id"));
                r.setRegisterDate(rs.getDate("register_date"));
                r.setRegistrationCode(rs.getString("registration_code"));
                r.setVip(rs.getBoolean("is_vip"));
                r.setCheckinTime(rs.getTimestamp("checkin_time"));
                r.setName(rs.getString("name"));
                r.setEmail(rs.getString("email"));
                r.setPassword(rs.getString("password"));
                r.setPhone(rs.getString("phone"));
                r.setUserType(rs.getString("user_type"));

                list.add(r);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }


    // ✅ Lấy danh sách đăng ký theo từng hội thảo (seminar_id)
    public List<Register> getBySeminarId(int seminarId) {
        List<Register> list = new ArrayList<>();

        String sql = "SELECT id, seminar_id, register_date, registration_code, " +
                "       is_vip, checkin_time, name, email, password, phone, user_type " +
                "FROM registrations " +
                "WHERE seminar_id = ? " +
                "ORDER BY register_date DESC";

        try (Connection conn = DataSourceUtil.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, seminarId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Register r = new Register();
                r.setId(rs.getInt("id"));
                r.setSeminarId(rs.getInt("seminar_id"));
                r.setRegisterDate(rs.getDate("register_date"));
                r.setRegistrationCode(rs.getString("registration_code"));
                r.setVip(rs.getBoolean("is_vip"));
                r.setCheckinTime(rs.getTimestamp("checkin_time"));
                r.setName(rs.getString("name"));
                r.setEmail(rs.getString("email"));
                r.setPassword(rs.getString("password"));
                r.setPhone(rs.getString("phone"));
                r.setUserType(rs.getString("user_type"));

                list.add(r);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
}
