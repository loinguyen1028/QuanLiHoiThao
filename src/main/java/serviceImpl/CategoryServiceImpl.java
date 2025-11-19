package serviceImpl;

import model.Category;
import repository.CategoryRepository;
import repositoryImpl.CategoryRepositoryImpl;
import service.CategoryService;

import javax.sql.DataSource;
import java.util.List;

public class CategoryServiceImpl implements CategoryService {

    private final CategoryRepository categoryRepository;

    public CategoryServiceImpl(DataSource ds) {
        this.categoryRepository = new CategoryRepositoryImpl(ds);
    }

    @Override
    public List<Category> findAll() {
        return this.categoryRepository.findAll();
    }
}
