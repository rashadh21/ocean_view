package com.oceanview.service;

import com.oceanview.dao.UserDAO;
import com.oceanview.factory.DAOFactory;
import com.oceanview.model.User;
import com.oceanview.util.PasswordUtil;

import java.sql.Timestamp;
import java.time.Instant;
import java.util.Optional;

public class AuthenticationService {
    
    private UserDAO userDAO;

    public AuthenticationService() {
        this.userDAO = DAOFactory.getUserDAO();
    }
    
    // Constructor for testing
    public AuthenticationService(UserDAO userDAO) {
        this.userDAO = userDAO;
    }

    public User authenticate(String username, String password) {
        Optional<User> userOpt = userDAO.findByUsername(username);
        
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            // In a real scenario with mixed plain/hashed passwords, might need a strategy.
            // Assuming all passwords in DB are hashed except initial seeds if not handled carefully.
            // For this project, we assume PasswordUtil handles verification.
            // Note: The sample data insert script used dummy hashes. Real app needs valid hashes.
            
            if (PasswordUtil.verifyPassword(password, user.getPassword())) {
                if (!user.isActive()) {
                    return null; // or throw inactive exception
                }
                // Update last login
                user.setLastLogin(Timestamp.from(Instant.now()));
                userDAO.update(user);
                return user;
            }
        }
        return null;
    }
}
