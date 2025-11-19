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
    @Override
    public List<Seminar> findByCategoryId(int categoryId) {
        List<Seminar> list = new ArrayList<>();
        String sql = "SELECT id, name, description, start_date, end_date, " +
                "location, speaker, category_id, max_attendees, status, image_url " +
                "FROM seminar WHERE category_id = ? ORDER BY start_date ASC";

        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, categoryId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Seminar s = new Seminar();
                    s.setId(rs.getInt("id"));
                    s.setName(rs.getString("name"));
                    s.setDescription(rs.getString("description"));

                    Timestamp startTs = rs.getTimestamp("start_date");
                    Timestamp endTs   = rs.getTimestamp("end_date");
                    if (startTs != null) s.setStart_date(startTs.toLocalDateTime());
                    if (endTs != null)   s.setEnd_date(endTs.toLocalDateTime());

                    s.setLocation(rs.getString("location"));
                    s.setSpeaker(rs.getString("speaker"));
                    s.setCategoryId(rs.getInt("category_id"));
                    s.setMaxAttendance(rs.getInt("max_attendees"));
                    s.setStatus(rs.getString("status"));
                    s.setImage(rs.getString("image_url"));

                    list.add(s);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public List<Seminar> findAll() {
        List<Seminar> listSeminar = new ArrayList<>();
        String sql = "SELECT * FROM seminar";
        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Seminar s = new Seminar();
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
                s.setMaxAttendance(rs.getInt("max_attendees"));
                s.setStatus(rs.getString("status"));
                s.setImage(rs.getString("image_url"));
                listSeminar.add(s);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return listSeminar;
    }

    @Override
    public List<Seminar> findAll(PageRequest pageRequest) {
        List<Seminar> listSeminar = new ArrayList<>();
        String baseSql = "SELECT * FROM seminar WHERE name LIKE ? OR speaker LIKE ?";
        String order = "desc".equalsIgnoreCase(pageRequest.getOrderField()) ? "DESC" : "ASC";
        String sql = baseSql + " ORDER BY " + pageRequest.getSortField() + " " + order + " LIMIT ? OFFSET ?";

        String keyword = "%" + (pageRequest.getKeyword() == null ? "" : pageRequest.getKeyword()) + "%";

        // 2. Thực thi câu lệnh
        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // 3. Set các tham số
            ps.setString(1, keyword); // Cho name LIKE ?
            ps.setString(2, keyword); // Cho speaker LIKE ?
            ps.setInt(3, pageRequest.getPageSize());
            ps.setInt(4, pageRequest.getOffset());

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Seminar s = new Seminar();
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
                    s.setMaxAttendance(rs.getInt("max_attendees"));
                    s.setStatus(rs.getString("status"));
                    s.setImage(rs.getString("image_url"));
                    listSeminar.add(s);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Nên log lỗi
            throw new RuntimeException(e);
        }
        return listSeminar;
    }

    @Override
    public Seminar findById(int id) {
        String sql = "SELECT * FROM seminar WHERE id = ?";

        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Seminar s = new Seminar();
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

                    s.setMaxAttendance(rs.getInt("max_attendees"));
                    s.setStatus(rs.getString("status"));
                    s.setImage(rs.getString("image_url"));

                    return s;
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return null;
    }

    @Override
    public Seminar create(Seminar entity) {
        String sql = "INSERT INTO seminar (name, description, start_date, end_date, " +
                "location, speaker, category_id, max_attendees, status, image_url) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = ds.getConnection();
             // Yêu cầu trả về key tự tăng (nếu có)
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, entity.getName());
            ps.setString(2, entity.getDescription());

            // Dùng setObject cho LocalDateTime
            ps.setObject(3, entity.getStart_date());
            ps.setObject(4, entity.getEnd_date());

            ps.setString(5, entity.getLocation());
            ps.setString(6, entity.getSpeaker());
            ps.setInt(7, entity.getCategoryId());
            ps.setInt(8, entity.getMaxAttendance());
            ps.setString(9, entity.getStatus());
            ps.setString(10, entity.getImage());

            ps.executeUpdate();

            // Lấy ID vừa được tạo ra
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

    @Override
    public boolean update(Seminar entity) {
        String sql = "UPDATE seminar " +
                "SET name = ?, description = ?, start_date = ?, end_date = ?, " +
                "location = ?, speaker = ?, category_id = ?, " +
                "max_attendees = ?, status = ?, image_url = ? " +
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

            ps.setInt(11, entity.getId());

            int rowsAffected = ps.executeUpdate();

            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace(); // Nên log lỗi
            throw new RuntimeException(e);
        }
    }

    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM seminar WHERE id = ?";
        DataSource ds = DataSourceUtil.getDataSource();

        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            int rowsDeleted = ps.executeUpdate();

            if (rowsDeleted > 0) {
                return true;
            } else {
                System.out.println("Không tìm thấy sách với id = " + id);
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return false;
    }

    @Override
    public List<SeminarDTO> findAllToDTO(PageRequest pageRequest) {
        List<SeminarDTO> listSeminar = new ArrayList<>();

        String baseSql = "SELECT seminar.*, category.categoryName\n" +
                "FROM seminar\n" +
                "JOIN category ON seminar.category_id = category.id";
        String whereSql = " WHERE (seminar.name LIKE ? OR seminar.speaker LIKE ? OR seminar.location LIKE ? OR category.categoryName LIKE ?)";
        String order = "desc".equalsIgnoreCase(pageRequest.getOrderField()) ? "DESC" : "ASC";
        String sql = baseSql + whereSql + " ORDER BY " + pageRequest.getSortField() + " " + order + " LIMIT ? OFFSET ?";

        String keyword = "%" + (pageRequest.getKeyword() == null ? "" : pageRequest.getKeyword()) + "%";

        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, keyword); // Cho name LIKE ?
            ps.setString(2, keyword);// Cho speaker LIKE ?
            ps.setString(3, keyword); // cho location
            ps.setString(4, keyword); // cho ategoryName
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
        String baseSql = "FROM seminar " +
                "JOIN category ON seminar.category_id = category.id";

        String whereSql = " WHERE (seminar.name LIKE ? OR seminar.speaker LIKE ? OR seminar.location LIKE ? OR category.categoryName LIKE ?)";

        String sql = "SELECT COUNT(*) " + baseSql + whereSql;

        String keywordSearch = "%" + (keyword == null ? "" : keyword) + "%";

        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, keywordSearch); // Cho seminar.name
            ps.setString(2, keywordSearch); // Cho seminar.speaker
            ps.setString(3, keywordSearch); // Cho seminar.location
            ps.setString(4, keywordSearch); // Cho category.categoryName

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
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
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
        return 0;
    }
}
