package serviceImpl;

import model.Admin;
import repository.AdminRepository;
import repositoryImpl.AdminRepositoryImpl;
import service.AdminService;

import javax.sql.DataSource;

public class AdminServiceImpl implements AdminService {

    private final AdminRepository adminRepository;

    public AdminServiceImpl(DataSource ds) {
        this.adminRepository = new AdminRepositoryImpl(ds);
    }

    @Override
    public Admin isAuthenticated(String username, String password) {
        return this.adminRepository.isAuthenticated(username, password);
    }
}
