package repository;

import model.Admin;

public interface AdminRepository extends Repository<Admin>{
    Admin  isAuthenticated(String username, String password);
}
