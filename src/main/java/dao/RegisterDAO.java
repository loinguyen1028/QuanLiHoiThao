package dao;

import model.Register;
import utils.DataSourceUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RegisterDAO {

    // --- CÁC HÀM CŨ GIỮ NGUYÊN ---
    public boolean insert(Register r) {
        String sql = "INSERT INTO registrations (seminar_id, name, email, phone, user_type) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DataSourceUtil.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, r.getSeminarId());
            ps.setString(2, r.getName());
            ps.setString(3, r.getEmail());
            ps.setString(4, r.getPhone());
            ps.setString(5, r.getUserType());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public Register findById(int id) {
        String sql = "SELECT * FROM registrations WHERE id = ?";
        try (Connection conn = DataSourceUtil.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if(rs.next()) {
                Register r = new Register();
                r.setId(rs.getInt("id"));
                r.setSeminarId(rs.getInt("seminar_id"));
                r.setName(rs.getString("name"));
                r.setEmail(rs.getString("email"));
                r.setPhone(rs.getString("phone"));
                r.setUserType(rs.getString("user_type"));
                r.setVip(rs.getBoolean("is_vip"));
                return r;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM registrations WHERE id=?";
        try (Connection conn = DataSourceUtil.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean update(Register r) {
        String sql = "UPDATE registrations SET name=?, email=?, phone=?, user_type=?, seminar_id=? WHERE id=?";
        try (Connection conn = DataSourceUtil.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, r.getName());
            ps.setString(2, r.getEmail());
            ps.setString(3, r.getPhone());
            ps.setString(4, r.getUserType());
            ps.setInt(5, r.getSeminarId());
            ps.setInt(6, r.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean toggleVip(int id) {
        String sql = "UPDATE registrations SET is_vip = NOT is_vip WHERE id = ?";
        try (Connection conn = DataSourceUtil.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // --- CẬP NHẬT 2 HÀM NÀY ĐỂ LỌC VIP ---

    public List<Register> getByCategoryIdWithPaging(int categoryId, int page, int pageSize, int vipStatus) {
        List<Register> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;

        // SQL: Thêm điều kiện lọc VIP (? = -1 để lấy tất cả)
        String sql = "SELECT r.id, r.seminar_id, r.register_date, r.registration_code, r.check_in_id, " +
                "       r.is_vip, r.checkin_time, r.name, r.email, r.password, r.phone, r.user_type " +
                "FROM registrations r " +
                "JOIN seminar s ON r.seminar_id = s.id " +
                "WHERE s.category_id = ? " +
                "AND (? = -1 OR r.is_vip = ?) " +
                "ORDER BY r.register_date DESC " +
                "LIMIT ? OFFSET ?";

        try (Connection conn = DataSourceUtil.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, categoryId);
            ps.setInt(2, vipStatus);
            ps.setInt(3, vipStatus);
            ps.setInt(4, pageSize);
            ps.setInt(5, offset);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Register r = new Register();
                r.setId(rs.getInt("id"));
                r.setSeminarId(rs.getInt("seminar_id"));
                r.setRegisterDate(rs.getDate("register_date"));
                r.setVip(rs.getBoolean("is_vip"));
                r.setName(rs.getString("name"));
                r.setEmail(rs.getString("email"));
                r.setPhone(rs.getString("phone"));
                r.setUserType(rs.getString("user_type"));
                list.add(r);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int countByCategoryId(int categoryId, int vipStatus) {
        String sql = "SELECT COUNT(*) FROM registrations r JOIN seminar s ON r.seminar_id = s.id " +
                "WHERE s.category_id = ? AND (? = -1 OR r.is_vip = ?)";
        try (Connection conn = DataSourceUtil.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ps.setInt(2, vipStatus);
            ps.setInt(3, vipStatus);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }
}