package repositoryImpl;

import model.Category;
import model.PageRequest;
import repository.CategoryRepository;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CategoryRepositoryImpl implements CategoryRepository {

    private final DataSource ds;

    public CategoryRepositoryImpl(DataSource ds) {
        this.ds = ds;
    }

    @Override
    public List<Category> findAll() {
        List<Category> listCategory = new ArrayList<>();
        String sql = "SELECT * FROM category";
        try {
            try (Connection conn = ds.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Category category = new Category();
                    category.setId(rs.getInt("id"));
                    category.setName(rs.getString("categoryName"));
                    listCategory.add(category);
                }
            }
            return listCategory;

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public List<Category> findAll(PageRequest pageRequest) {
        return List.of();
    }

    @Override
    public Category findById(int id) {
        return null;
    }

    @Override
    public Category create(Category entity) {
        return null;
    }

    @Override
    public boolean update(Category entity) {
        return false;
    }

    @Override
    public boolean delete(int id) {
        return false;
    }
}
