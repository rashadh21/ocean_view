package com.oceanview.dao.impl;

import com.oceanview.config.DatabaseConfig;
import com.oceanview.dao.RoomTypeDAO;
import com.oceanview.model.RoomType;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class RoomTypeDAOImpl implements RoomTypeDAO {

    @Override
    public Optional<RoomType> getById(int id) {
        String sql = "SELECT * FROM room_types WHERE room_type_id = ?";
        try (Connection conn = DatabaseConfig.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return Optional.of(mapResultSetToRoomType(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    @Override
    public List<RoomType> getAll() {
        List<RoomType> types = new ArrayList<>();
        String sql = "SELECT * FROM room_types";
        try (Connection conn = DatabaseConfig.getInstance().getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                types.add(mapResultSetToRoomType(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return types;
    }

    @Override
    public void save(RoomType type) {
        String sql = "INSERT INTO room_types (type_name, description, base_price, capacity, amenities) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConfig.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, type.getTypeName());
            stmt.setString(2, type.getDescription());
            stmt.setBigDecimal(3, type.getBasePrice());
            stmt.setInt(4, type.getCapacity());
            stmt.setString(5, type.getAmenities());
            
            stmt.executeUpdate();
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    type.setRoomTypeId(generatedKeys.getInt(1));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void update(RoomType type) {
        String sql = "UPDATE room_types SET type_name = ?, description = ?, base_price = ?, capacity = ?, amenities = ? WHERE room_type_id = ?";
        try (Connection conn = DatabaseConfig.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, type.getTypeName());
            stmt.setString(2, type.getDescription());
            stmt.setBigDecimal(3, type.getBasePrice());
            stmt.setInt(4, type.getCapacity());
            stmt.setString(5, type.getAmenities());
            stmt.setInt(6, type.getRoomTypeId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void delete(int id) {
        String sql = "DELETE FROM room_types WHERE room_type_id = ?";
        try (Connection conn = DatabaseConfig.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private RoomType mapResultSetToRoomType(ResultSet rs) throws SQLException {
        RoomType type = new RoomType();
        type.setRoomTypeId(rs.getInt("room_type_id"));
        type.setTypeName(rs.getString("type_name"));
        type.setDescription(rs.getString("description"));
        type.setBasePrice(rs.getBigDecimal("base_price"));
        type.setCapacity(rs.getInt("capacity"));
        type.setAmenities(rs.getString("amenities"));
        type.setCreatedAt(rs.getTimestamp("created_at"));
        return type;
    }
}
