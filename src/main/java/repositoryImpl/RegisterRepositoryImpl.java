package repositoryImpl;

import dto.ChartDataDTO;
import dto.GuestStatDTO;
import model.PageRequest;
import model.Register;
import repository.RegisterRepository;
import utils.DataSourceUtil; // Dùng DBConnect

import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RegisterRepositoryImpl implements RegisterRepository {

    private final DataSource ds;

    public RegisterRepositoryImpl(DataSource ds) {
        this.ds = ds;
    }

    // =================================================
    // 🔥 1. PHẦN CHECK-IN QUAN TRỌNG (ĐÃ FIX)
    // =================================================

    @Override
    public Register findByCheckInId(String checkInId) {
        if (checkInId != null) checkInId = checkInId.trim(); // Cắt khoảng trắng thừa

        // Dùng LEFT JOIN để luôn tìm thấy user, kể cả khi seminar bị lỗi ID
        String sql = "SELECT r.*, s.name as seminar_name " +
                "FROM registrations r LEFT JOIN seminar s ON r.seminar_id = s.id " +
                "WHERE r.check_in_id = ?";
        
        try (Connection conn = DataSourceUtil.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, checkInId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean setCheckInTime(String checkInId) {
        if (checkInId != null) checkInId = checkInId.trim();

        String sql = "UPDATE registrations SET checkin_time = NOW() WHERE check_in_id = ?";
        try (Connection conn = DataSourceUtil.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, checkInId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // =================================================
    // 2. CÁC HÀM CŨ (GIỮ NGUYÊN ĐỂ KHÔNG LỖI)
    // =================================================

    @Override
    public Register create(Register entity) {
        if (isEmailExists(entity.getEmail(), entity.getSeminarId())) return null;

        String sql = "INSERT INTO registrations (seminar_id, registration_code, check_in_id, name, email, phone, user_type) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DataSourceUtil.getDataSource().getConnection();
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

    private boolean isEmailExists(String email, int seminarId) {
        String sql = "SELECT id FROM registrations WHERE email = ? AND seminar_id = ?";
        try (Connection conn = DataSourceUtil.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setInt(2, seminarId);
            try (ResultSet rs = ps.executeQuery()) { return rs.next(); }
        } catch (SQLException e) { return false; }
    }

    @Override
    public boolean update(Register entity) {
        String sql = "UPDATE registrations SET name=?, email=?, phone=?, user_type=?, is_vip=?, seminar_id=? WHERE id=?";
        try (Connection conn = DataSourceUtil.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, entity.getName());
            ps.setString(2, entity.getEmail());
            ps.setString(3, entity.getPhone());
            ps.setString(4, entity.getUserType());
            ps.setBoolean(5, entity.isVip());
            ps.setInt(6, entity.getSeminarId());
            ps.setInt(7, entity.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { return false; }
    }

    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM registrations WHERE id=?";
        try (Connection conn = DataSourceUtil.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { return false; }
    }

    @Override
    public Register findById(int id) {
        String sql = "SELECT r.*, s.name as seminar_name FROM registrations r JOIN seminar s ON r.seminar_id = s.id WHERE r.id=?";
        try (Connection conn = DataSourceUtil.getDataSource().getConnection();
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
        try (Connection conn = DataSourceUtil.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, seminarId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public Register findByEmailAndCode(String email, String code) {
        String sql = "SELECT r.*, s.name as seminar_name FROM registrations r JOIN seminar s ON r.seminar_id = s.id WHERE email=? AND registration_code=?";
        try (Connection conn = DataSourceUtil.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email); ps.setString(2, code);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    @Override
    public boolean toggleVip(int id) {
        String sql = "UPDATE registrations SET is_vip = NOT is_vip WHERE id = ?";
        try (Connection conn = DataSourceUtil.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { return false; }
    }

    @Override
    public List<ChartDataDTO> getRegistrationStatsByDate() {
        List<ChartDataDTO> list = new ArrayList<>();
        String sql = "SELECT register_date, COUNT(*) as count FROM registrations GROUP BY register_date ORDER BY register_date ASC LIMIT 10";
        try (Connection conn = DataSourceUtil.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String d = rs.getString("register_date");
                list.add(new ChartDataDTO(d == null ? "N/A" : d, rs.getInt("count")));
            }
        } catch (SQLException e) { }
        return list;
    }

    @Override
    public List<GuestStatDTO> getGuestStatistics() {
        List<GuestStatDTO> list = new ArrayList<>();
        String sql = "SELECT user_type, COUNT(*) as total_reg, COUNT(CASE WHEN checkin_time IS NOT NULL THEN 1 END) as total_checkin FROM registrations GROUP BY user_type";
        try (Connection conn = DataSourceUtil.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String type = rs.getString("user_type");
                list.add(new GuestStatDTO(type == null ? "Khác" : type, rs.getInt("total_reg"), rs.getInt("total_checkin")));
            }
        } catch (SQLException e) { }
        return list;
    }

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

        try {
            r.setEventName(rs.getString("seminar_name"));
        } catch (Exception e) {
            r.setEventName("Không xác định");
        }
        return r;
    }
    @Override
    public List<Register> findAllByCategoryId(int categoryId, int seminarIdFilter, int vipStatus, String userType, int checkInStatus, int page, int pageSize) {
        List<Register> list = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        // SQL Cơ bản
        StringBuilder sql = new StringBuilder(
                "SELECT r.*, s.name as seminar_name " +
                        "FROM registrations r " +
                        "JOIN seminar s ON r.seminar_id = s.id " +
                        "WHERE s.category_id = ? "
        );
        params.add(categoryId);

        // --- CÁC BỘ LỌC ---
        if (seminarIdFilter > 0) {
            sql.append(" AND r.seminar_id = ? ");
            params.add(seminarIdFilter);
        }
        if (vipStatus != -1) {
            sql.append(" AND r.is_vip = ? ");
            params.add(vipStatus == 1);
        }
        if (userType != null && !userType.isEmpty()) {
            sql.append(" AND r.user_type = ? ");
            params.add(userType);
        }

        // 🔥 [MỚI] Lọc theo Check-in
        if (checkInStatus != -1) {
            if (checkInStatus == 1) {
                // Đã check-in: checkin_time KHÔNG NULL
                sql.append(" AND r.checkin_time IS NOT NULL ");
            } else {
                // Chưa check-in: checkin_time LÀ NULL
                sql.append(" AND r.checkin_time IS NULL ");
            }
        }

        // Sắp xếp và Phân trang
        sql.append(" ORDER BY r.register_date DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        try (Connection conn = DataSourceUtil.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public int countByFilter(int categoryId, int seminarIdFilter, int vipStatus) {
        List<Object> params = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM registrations r JOIN seminar s ON r.seminar_id = s.id WHERE s.category_id = ?"
        );
        params.add(categoryId);

        if (seminarIdFilter > 0) {
            sql.append(" AND r.seminar_id = ?");
            params.add(seminarIdFilter);
        }
        if (vipStatus != -1) {
            sql.append(" AND r.is_vip = ?");
            params.add(vipStatus == 1);
        }

        try (Connection conn = DataSourceUtil.getDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override public List<Register> findAll() { return List.of(); }
    @Override public List<Register> findAll(PageRequest pageRequest) { return List.of(); }
}