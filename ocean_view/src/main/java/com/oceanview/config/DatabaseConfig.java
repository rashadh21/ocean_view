package com.oceanview.config;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

import org.apache.commons.dbcp2.BasicDataSource;

public class DatabaseConfig {

    private static DatabaseConfig instance;
    private BasicDataSource dataSource;

    private DatabaseConfig() {
        Properties props = new Properties();
        try (InputStream is = getClass().getClassLoader().getResourceAsStream("db.properties")) {
            if (is == null) {
                throw new RuntimeException("db.properties not found in classpath");
            }
            props.load(is);

            dataSource = new BasicDataSource();
            dataSource.setDriverClassName(props.getProperty("db.driver"));
            dataSource.setUrl(props.getProperty("db.url"));
            dataSource.setUsername(props.getProperty("db.username"));
            dataSource.setPassword(props.getProperty("db.password"));

            dataSource.setInitialSize(Integer.parseInt(props.getProperty("db.pool.initialSize")));
            dataSource.setMaxTotal(Integer.parseInt(props.getProperty("db.pool.maxTotal")));
            dataSource.setMaxIdle(Integer.parseInt(props.getProperty("db.pool.maxIdle")));
            dataSource.setMinIdle(Integer.parseInt(props.getProperty("db.pool.minIdle")));

        } catch (IOException e) {
            throw new RuntimeException("Error loading database configuration", e);
        }
    }

    public static synchronized DatabaseConfig getInstance() {
        if (instance == null) {
            instance = new DatabaseConfig();
        }
        return instance;
    }

    public Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }
    
    public void close() throws SQLException {
        if (dataSource != null) {
            dataSource.close();
        }
    }
}
