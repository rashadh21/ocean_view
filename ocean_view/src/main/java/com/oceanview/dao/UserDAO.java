package com.oceanview.dao;

import com.oceanview.model.User;
import java.util.Optional;

public interface UserDAO extends BaseDAO<User> {
    Optional<User> findByUsername(String username);
}
