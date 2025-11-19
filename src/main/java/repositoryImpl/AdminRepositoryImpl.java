package repositoryImpl;

import model.Admin;
import model.PageRequest;
import repository.AdminRepository;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

public class AdminRepositoryImpl implements AdminRepository {

    private final DataSource ds;

    public AdminRepositoryImpl(DataSource ds) {
        this.ds = ds;
    }

    @Override
    public Admin isAuthenticated(String username, String password) {
        String sql = "SELECT * FROM admin WHERE email = ? AND password = ?";
        try(Connection connection = ds.getConnection();
            PreparedStatement ps = connection.prepareStatement(sql)){
            ps.setString(1, username);
            ps.setString(2, password);
            try(ResultSet rs = ps.executeQuery()){
                if(rs.next()){
                    Admin admin = new Admin();
                    admin.setId(rs.getInt("id_admin"));
                    admin.setName(rs.getString("name"));
                    admin.setEmail(rs.getString("email"));
                    admin.setPassword(rs.getString("password"));
                    admin.setPhone(rs.getString("phone"));
                    admin.setRole(rs.getString("role"));
                    return admin;
                }
            }
        }catch (Exception e){
            throw new RuntimeException(e);
        }
        return null;
    }

    @Override
    public List<Admin> findAll() {
        return List.of();
    }

    @Override
    public List<Admin> findAll(PageRequest pageRequest) {
        return List.of();
    }

    @Override
    public Admin findById(int id) {
        return null;
    }

    @Override
    public Admin create(Admin entity) {
        return null;
    }

    @Override
    public boolean update(Admin entity) {
        return false;
    }

    @Override
    public boolean delete(int id) {
        return false;
    }
}
