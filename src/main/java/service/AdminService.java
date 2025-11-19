package service;

import model.Admin;

public interface AdminService {
    Admin isAuthenticated(String username, String password);
}
