package repositoryImpl;

import dto.ChartDataDTO;
import dto.GuestStatDTO;
import model.PageRequest;
import model.Register;
import repository.RegisterRepository;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class RegisterRepositoryImpl implements RegisterRepository {
    private final DataSource ds;

    public RegisterRepositoryImpl(DataSource ds) {
        this.ds = ds;
    }

    @Override
    public List<ChartDataDTO> getRegistrationStatsByDate() {
        List<ChartDataDTO> list = new ArrayList<>();

        String sql = "SELECT register_date, COUNT(*) as count " +
                "FROM registrations " +
                "GROUP BY register_date " +
                "ORDER BY register_date ASC LIMIT 10";

        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String dateStr = rs.getString("register_date");

                if (dateStr == null) dateStr = "N/A";

                list.add(new ChartDataDTO(
                        dateStr,
                        rs.getInt("count")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<GuestStatDTO> getGuestStatistics() {
        List<GuestStatDTO> list = new ArrayList<>();

        String sql = "SELECT user_type, " +
                "COUNT(*) as total_reg, " +
                "COUNT(CASE WHEN checkin_time IS NOT NULL THEN 1 END) as total_checkin " +
                "FROM registrations " +
                "GROUP BY user_type";

        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String type = rs.getString("user_type");
                if (type == null || type.isEmpty()) {
                    type = "Khác";
                }

                list.add(new GuestStatDTO(
                        type, // Lấy đúng tên cột user_type
                        rs.getInt("total_reg"),
                        rs.getInt("total_checkin")
                ));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public List<Register> findAll() {
        return List.of();
    }

    @Override
    public List<Register> findAll(PageRequest pageRequest) {
        return List.of();
    }

    @Override
    public Register findById(int id) {
        return null;
    }

    @Override
    public Register create(Register entity) {
        return null;
    }

    @Override
    public boolean update(Register entity) {
        return false;
    }

    @Override
    public boolean delete(int id) {
        return false;
    }
}
