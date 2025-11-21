package repositoryImpl;

import dto.SeminarDTO;
import model.PageRequest;
import model.Seminar;
import repository.SeminarRepository;
import utils.DataSourceUtil;

import javax.sql.DataSource;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class SeminarRepositoryImpl implements SeminarRepository {

    private final DataSource ds;

    public SeminarRepositoryImpl(DataSource ds) {
        this.ds = ds;
    }

    // --- 1. LẤY DANH SÁCH THEO CATEGORY (Cập nhật thêm cột mới) ---
    @Override
    public List<Seminar> findByCategoryId(int categoryId) {
        List<Seminar> list = new ArrayList<>();
        // Thêm registration_open, registration_deadline vào câu SQL
        String sql = "SELECT * FROM seminar WHERE category_id = ? ORDER BY start_date ASC";

        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, categoryId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Seminar s = mapResultSetToSeminar(rs); // Dùng hàm map chung cho gọn
                    list.add(s);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // --- 2. LẤY TẤT CẢ (Cập nhật thêm cột mới) ---
    @Override
    public List<Seminar> findAll() {
        List<Seminar> listSeminar = new ArrayList<>();
        String sql = "SELECT * FROM seminar";
        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                listSeminar.add(mapResultSetToSeminar(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return listSeminar;
    }

    // --- 3. PHÂN TRANG (Cập nhật thêm cột mới) ---
    @Override
    public List<Seminar> findAll(PageRequest pageRequest) {
        List<Seminar> listSeminar = new ArrayList<>();
        String baseSql = "SELECT * FROM seminar WHERE name LIKE ? OR speaker LIKE ?";
        String order = "desc".equalsIgnoreCase(pageRequest.getOrderField()) ? "DESC" : "ASC";
        String sql = baseSql + " ORDER BY " + pageRequest.getSortField() + " " + order + " LIMIT ? OFFSET ?";

        String keyword = "%" + (pageRequest.getKeyword() == null ? "" : pageRequest.getKeyword()) + "%";

        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, keyword);
            ps.setString(2, keyword);
            ps.setInt(3, pageRequest.getPageSize());
            ps.setInt(4, pageRequest.getOffset());

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    listSeminar.add(mapResultSetToSeminar(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
        return listSeminar;
    }

    // --- 4. LẤY CHI TIẾT (QUAN TRỌNG NHẤT - Sửa lỗi hiển thị Status) ---
    @Override
    public Seminar findById(int id) {
        String sql = "SELECT * FROM seminar WHERE id = ?";

        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToSeminar(rs); // Đã lấy đủ registration_open/deadline
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return null;
    }

    // --- 5. TẠO MỚI (Cập nhật để lưu được ngày đăng ký) ---
    @Override
    public Seminar create(Seminar entity) {
        // Thêm cột registration_open, registration_deadline vào INSERT
        String sql = "INSERT INTO seminar (name, description, start_date, end_date, " +
                "location, speaker, category_id, max_attendees, status, image_url, registration_open, registration_deadline) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, entity.getName());
            ps.setString(2, entity.getDescription());
            ps.setObject(3, entity.getStart_date());
            ps.setObject(4, entity.getEnd_date());
            ps.setString(5, entity.getLocation());
            ps.setString(6, entity.getSpeaker());
            ps.setInt(7, entity.getCategoryId());
            ps.setInt(8, entity.getMaxAttendance());
            ps.setString(9, entity.getStatus());
            ps.setString(10, entity.getImage());

            // Set 2 trường mới (Timestamp)
            ps.setTimestamp(11, entity.getRegistrationOpen());
            ps.setTimestamp(12, entity.getRegistrationDeadline());

            ps.executeUpdate();

            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    entity.setId(generatedKeys.getInt(1));
                }
            }
            return entity;

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    // --- 6. CẬP NHẬT (Cập nhật để sửa được ngày đăng ký) ---
    @Override
    public boolean update(Seminar entity) {
        // Thêm cột registration_open, registration_deadline vào UPDATE
        String sql = "UPDATE seminar " +
                "SET name = ?, description = ?, start_date = ?, end_date = ?, " +
                "location = ?, speaker = ?, category_id = ?, " +
                "max_attendees = ?, status = ?, image_url = ?, " +
                "registration_open = ?, registration_deadline = ? " +
                "WHERE id = ?";

        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, entity.getName());
            ps.setString(2, entity.getDescription());
            ps.setObject(3, entity.getStart_date());
            ps.setObject(4, entity.getEnd_date());
            ps.setString(5, entity.getLocation());
            ps.setString(6, entity.getSpeaker());
            ps.setInt(7, entity.getCategoryId());
            ps.setInt(8, entity.getMaxAttendance());
            ps.setString(9, entity.getStatus());
            ps.setString(10, entity.getImage());

            // Set 2 trường mới
            ps.setTimestamp(11, entity.getRegistrationOpen());
            ps.setTimestamp(12, entity.getRegistrationDeadline());

            ps.setInt(13, entity.getId());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM seminar WHERE id = ?";
        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    // --- Helper Method: Map ResultSet to Seminar (Tránh lặp code) ---
    private Seminar mapResultSetToSeminar(ResultSet rs) throws SQLException {
        Seminar s = new Seminar();
        s.setId(rs.getInt("id"));
        s.setName(rs.getString("name"));
        s.setDescription(rs.getString("description"));

        // Map LocalDateTime
        Timestamp startTs = rs.getTimestamp("start_date");
        if (startTs != null) s.setStart_date(startTs.toLocalDateTime());

        Timestamp endTs = rs.getTimestamp("end_date");
        if (endTs != null) s.setEnd_date(endTs.toLocalDateTime());

        s.setLocation(rs.getString("location"));
        s.setSpeaker(rs.getString("speaker"));
        s.setCategoryId(rs.getInt("category_id"));
        s.setMaxAttendance(rs.getInt("max_attendees"));
        s.setStatus(rs.getString("status"));
        s.setImage(rs.getString("image_url"));

        // ✅ QUAN TRỌNG: Map 2 trường mới ở đây
        s.setRegistrationOpen(rs.getTimestamp("registration_open"));
        s.setRegistrationDeadline(rs.getTimestamp("registration_deadline"));

        return s;
    }

    @Override
    public List<SeminarDTO> findAllToDTO(PageRequest pageRequest) {
        List<SeminarDTO> listSeminar = new ArrayList<>();
        // SQL join category (DTO hiện tại chưa có field registration date nên giữ nguyên)
        String baseSql = "SELECT seminar.*, category.categoryName FROM seminar JOIN category ON seminar.category_id = category.id";
        String whereSql = " WHERE (seminar.name LIKE ? OR seminar.speaker LIKE ? OR seminar.location LIKE ? OR category.categoryName LIKE ?)";
        String order = "desc".equalsIgnoreCase(pageRequest.getOrderField()) ? "DESC" : "ASC";
        String sql = baseSql + whereSql + " ORDER BY " + pageRequest.getSortField() + " " + order + " LIMIT ? OFFSET ?";

        String keyword = "%" + (pageRequest.getKeyword() == null ? "" : pageRequest.getKeyword()) + "%";

        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, keyword);
            ps.setString(2, keyword);
            ps.setString(3, keyword);
            ps.setString(4, keyword);
            ps.setInt(5, pageRequest.getPageSize());
            ps.setInt(6, pageRequest.getOffset());

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SeminarDTO s = new SeminarDTO();
                    s.setId(rs.getInt("id"));
                    s.setName(rs.getString("name"));
                    s.setDescription(rs.getString("description"));
                    LocalDateTime startDate = rs.getObject("start_date", LocalDateTime.class);
                    s.setStart_date(startDate);
                    LocalDateTime endDate = rs.getObject("end_date", LocalDateTime.class);
                    s.setEnd_date(endDate);
                    s.setLocation(rs.getString("location"));
                    s.setSpeaker(rs.getString("speaker"));
                    s.setCategoryId(rs.getInt("category_id"));
                    s.setCategoryName(rs.getString("categoryName"));
                    s.setMaxAttendance(rs.getInt("max_attendees"));
                    s.setStatus(rs.getString("status"));
                    s.setImage(rs.getString("image_url"));
                    listSeminar.add(s);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
        return listSeminar;
    }

    @Override
    public int count(String keyword) {
        String baseSql = "FROM seminar JOIN category ON seminar.category_id = category.id";
        String whereSql = " WHERE (seminar.name LIKE ? OR seminar.speaker LIKE ? OR seminar.location LIKE ? OR category.categoryName LIKE ?)";
        String sql = "SELECT COUNT(*) " + baseSql + whereSql;

        String keywordSearch = "%" + (keyword == null ? "" : keyword) + "%";

        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, keywordSearch);
            ps.setString(2, keywordSearch);
            ps.setString(3, keywordSearch);
            ps.setString(4, keywordSearch);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
        return 0;
    }

    @Override
    public int countUpcomingSeminars() {
        String sql = "SELECT COUNT(*) FROM seminar WHERE start_date > NOW()";
        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
        return 0;
    }

}