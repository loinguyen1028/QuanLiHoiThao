package repositoryImpl;

import dto.ChartDataDTO;
import dto.GuestStatDTO;
import model.PageRequest;
import model.Register;
import repository.RegisterRepository;
import utils.DBConnect; // Dùng DBConnect để tránh lỗi SSL/Public Key

import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RegisterRepositoryImpl implements RegisterRepository {

    // Biến này giữ lại để khớp constructor của Service, nhưng ta ưu tiên dùng DBConnect
    private final DataSource ds;

    public RegisterRepositoryImpl(DataSource ds) {
        this.ds = ds;
    }

    // ==========================================
    // 1. CÁC HÀM CORE (THÊM, SỬA, XÓA, TÌM KIẾM)
    // ==========================================

    @Override
    public Register create(Register entity) {
        String sql = "INSERT INTO registrations (seminar_id, registration_code, check_in_id, name, email, phone, user_type) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, entity.getSeminarId());
            ps.setString(2, entity.getRegistrationCode());
            ps.setString(3, entity.getCheckInId());
            ps.setString(4, entity.getName());
            ps.setString(5, entity.getEmail());
            ps.setString(6, entity.getPhone());
            ps.setString(7, entity.getUserType());

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if(rs.next()) entity.setId(rs.getInt(1));
            }
            return entity;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public boolean update(Register entity) {
        // Cho phép Admin sửa thông tin
        String sql = "UPDATE registrations SET name=?, email=?, phone=?, user_type=?, is_vip=? WHERE id=?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, entity.getName());
            ps.setString(2, entity.getEmail());
            ps.setString(3, entity.getPhone());
            ps.setString(4, entity.getUserType());
            ps.setBoolean(5, entity.isVip());
            ps.setInt(6, entity.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM registrations WHERE id=?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    @Override
    public Register findById(int id) {
        String sql = "SELECT r.*, s.name as seminar_name FROM registrations r JOIN seminar s ON r.seminar_id = s.id WHERE r.id=?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    @Override
    public List<Register> findBySeminarId(int seminarId) {
        List<Register> list = new ArrayList<>();
        String sql = "SELECT r.*, s.name as seminar_name FROM registrations r JOIN seminar s ON r.seminar_id = s.id WHERE seminar_id=? ORDER BY id DESC";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, seminarId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // ==========================================
    // 2. CÁC HÀM NGHIỆP VỤ (VERIFY, CHECK-IN)
    // ==========================================

    @Override
    public Register findByEmailAndCode(String email, String code) {
        String sql = "SELECT r.*, s.name as seminar_name FROM registrations r JOIN seminar s ON r.seminar_id = s.id WHERE email=? AND registration_code=?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email); ps.setString(2, code);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    @Override
    public Register findByCheckInId(String checkInId) {
        String sql = "SELECT r.*, s.name as seminar_name FROM registrations r JOIN seminar s ON r.seminar_id = s.id WHERE check_in_id=?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, checkInId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    @Override
    public boolean setCheckInTime(String checkInId) {
        String sql = "UPDATE registrations SET checkin_time=NOW() WHERE check_in_id=?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, checkInId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // ==========================================
    // 3. CÁC HÀM THỐNG KÊ (CỦA BẠN BẠN)
    // ==========================================
    // Lưu ý: Đã chuyển sang dùng DBConnect để tránh lỗi 500

    @Override
    public List<ChartDataDTO> getRegistrationStatsByDate() {
        List<ChartDataDTO> list = new ArrayList<>();
        String sql = "SELECT register_date, COUNT(*) as count FROM registrations GROUP BY register_date ORDER BY register_date ASC LIMIT 10";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String dateStr = rs.getString("register_date");
                list.add(new ChartDataDTO(dateStr == null ? "N/A" : dateStr, rs.getInt("count")));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public List<GuestStatDTO> getGuestStatistics() {
        List<GuestStatDTO> list = new ArrayList<>();
        String sql = "SELECT user_type, COUNT(*) as total_reg, COUNT(CASE WHEN checkin_time IS NOT NULL THEN 1 END) as total_checkin FROM registrations GROUP BY user_type";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String type = rs.getString("user_type");
                list.add(new GuestStatDTO(type == null || type.isEmpty() ? "Khác" : type, rs.getInt("total_reg"), rs.getInt("total_checkin")));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // ==========================================
    // 4. HÀM BỔ TRỢ & PLACEHOLDER
    // ==========================================

    // Helper map row để tránh lặp code
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
        try { r.setEventName(rs.getString("seminar_name")); } catch (Exception e) {}
        return r;
    }

    @Override public List<Register> findAll() { return List.of(); }
    @Override public List<Register> findAll(PageRequest pageRequest) { return List.of(); }
}