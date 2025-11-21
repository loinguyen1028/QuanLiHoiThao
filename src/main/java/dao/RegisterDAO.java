package dao;

import model.Register;
import utils.DataSourceUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RegisterDAO {

    // 1. Lấy danh sách (FULL BỘ LỌC: VIP, UserType, CheckIn, Keyword)
    public List<Register> getByCategoryIdWithPaging(int categoryId, int page, int pageSize,
                                                    int vipStatus, String userType, int checkInStatus, String keyword) {
        List<Register> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String searchPattern = "%" + (keyword == null ? "" : keyword.trim()) + "%";
        if (userType == null) userType = "";

        // SQL logic:
        // vipStatus = -1 -> Lấy hết
        // userType = "" -> Lấy hết
        // checkInStatus = -1 -> Lấy hết, 1 -> Đã checkin, 0 -> Chưa checkin

        String sql = "SELECT r.*, s.name as seminar_name " +
                "FROM registrations r " +
                "JOIN seminar s ON r.seminar_id = s.id " +
                "WHERE s.category_id = ? " +
                "AND (? = -1 OR r.is_vip = ?) " +
                "AND (? = '' OR r.user_type = ?) " +
                "AND (? = -1 OR (? = 1 AND r.checkin_time IS NOT NULL) OR (? = 0 AND r.checkin_time IS NULL)) " +
                "AND (r.name LIKE ? OR r.email LIKE ? OR r.phone LIKE ?) " +
                "ORDER BY r.register_date DESC " +
                "LIMIT ? OFFSET ?";

        try (Connection conn = DataSourceUtil.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            int i = 1;
            ps.setInt(i++, categoryId);

            // VIP
            ps.setInt(i++, vipStatus);
            ps.setInt(i++, vipStatus);

            // User Type
            ps.setString(i++, userType);
            ps.setString(i++, userType);

            // Check-in Status
            ps.setInt(i++, checkInStatus);
            ps.setInt(i++, checkInStatus);
            ps.setInt(i++, checkInStatus);

            // Keyword
            ps.setString(i++, searchPattern);
            ps.setString(i++, searchPattern);
            ps.setString(i++, searchPattern);

            // Paging
            ps.setInt(i++, pageSize);
            ps.setInt(i++, offset);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // 2. Đếm tổng số (Cũng phải có đủ bộ lọc)
    public int countByCategoryId(int categoryId, int vipStatus, String userType, int checkInStatus, String keyword) {
        String searchPattern = "%" + (keyword == null ? "" : keyword.trim()) + "%";
        if (userType == null) userType = "";

        String sql = "SELECT COUNT(*) FROM registrations r JOIN seminar s ON r.seminar_id = s.id " +
                "WHERE s.category_id = ? " +
                "AND (? = -1 OR r.is_vip = ?) " +
                "AND (? = '' OR r.user_type = ?) " +
                "AND (? = -1 OR (? = 1 AND r.checkin_time IS NOT NULL) OR (? = 0 AND r.checkin_time IS NULL)) " +
                "AND (r.name LIKE ? OR r.email LIKE ? OR r.phone LIKE ?)";

        try (Connection conn = DataSourceUtil.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            int i = 1;
            ps.setInt(i++, categoryId);
            ps.setInt(i++, vipStatus);
            ps.setInt(i++, vipStatus);
            ps.setString(i++, userType);
            ps.setString(i++, userType);
            ps.setInt(i++, checkInStatus);
            ps.setInt(i++, checkInStatus);
            ps.setInt(i++, checkInStatus);
            ps.setString(i++, searchPattern);
            ps.setString(i++, searchPattern);
            ps.setString(i++, searchPattern);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

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
        } catch (SQLException e) { return false; }
    }

    public Register findById(int id) {
        String sql = "SELECT * FROM registrations WHERE id = ?";
        try (Connection conn = DataSourceUtil.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if(rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM registrations WHERE id=?";
        try (Connection conn = DataSourceUtil.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { return false; }
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
        } catch (SQLException e) { return false; }
    }

    public boolean toggleVip(int id) {
        String sql = "UPDATE registrations SET is_vip = NOT is_vip WHERE id = ?";
        try (Connection conn = DataSourceUtil.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { return false; }
    }

    // Helper map row
    private Register mapRow(ResultSet rs) throws SQLException {
        Register r = new Register();
        r.setId(rs.getInt("id"));
        r.setSeminarId(rs.getInt("seminar_id"));
        r.setRegisterDate(rs.getDate("register_date"));
        r.setRegistrationCode(rs.getString("registration_code"));
        r.setCheckInId(rs.getString("check_in_id"));
        r.setVip(rs.getBoolean("is_vip"));
        r.setCheckinTime(rs.getTimestamp("checkin_time"));
        r.setName(rs.getString("name"));
        r.setEmail(rs.getString("email"));
        r.setPhone(rs.getString("phone"));
        r.setUserType(rs.getString("user_type"));
        return r;
    }
}