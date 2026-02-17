package com.oceanview.dao.impl;

import com.oceanview.config.DatabaseConfig;
import com.oceanview.dao.RoomDAO;
import com.oceanview.model.Room;
import com.oceanview.model.RoomType;

import java.sql.*;
import java.sql.Date;
import java.util.*;

public class RoomDAOImpl implements RoomDAO {

    @Override
    public Optional<Room> getById(int id) {
        String sql = "SELECT r.*, rt.type_name, rt.base_price, rt.capacity FROM rooms r " +
                     "JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
                     "WHERE r.room_id = ?";
        try (Connection conn = DatabaseConfig.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return Optional.of(mapResultSetToRoom(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    @Override
    public List<Room> getAll() {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT r.*, rt.type_name, rt.base_price, rt.capacity FROM rooms r " +
                     "JOIN room_types rt ON r.room_type_id = rt.room_type_id";
        try (Connection conn = DatabaseConfig.getInstance().getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                rooms.add(mapResultSetToRoom(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }

    @Override
    public void save(Room room) {
        String sql = "INSERT INTO rooms (room_number, room_type_id, floor_number, status) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseConfig.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, room.getRoomNumber());
            stmt.setInt(2, room.getRoomTypeId());
            stmt.setInt(3, room.getFloorNumber());
            stmt.setString(4, room.getStatus());
            
            stmt.executeUpdate();
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    room.setRoomId(generatedKeys.getInt(1));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void update(Room room) {
        String sql = "UPDATE rooms SET room_number = ?, room_type_id = ?, floor_number = ?, status = ? WHERE room_id = ?";
        try (Connection conn = DatabaseConfig.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, room.getRoomNumber());
            stmt.setInt(2, room.getRoomTypeId());
            stmt.setInt(3, room.getFloorNumber());
            stmt.setString(4, room.getStatus());
            stmt.setInt(5, room.getRoomId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void delete(int id) {
        String sql = "DELETE FROM rooms WHERE room_id = ?";
        try (Connection conn = DatabaseConfig.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<Room> getAvailableRooms(Date checkIn, Date checkOut) {
        List<Room> rooms = new ArrayList<>();
        // Using the stored function CheckRoomAvailability in a query is less efficient for bulk selection 
        // than a direct JOIN exclusion, but for simplicity and requirement adherence we can use it 
        // or a direct NOT EXISTS clause. Let's use a standard efficient query.
        String sql = "SELECT r.*, rt.type_name, rt.base_price, rt.capacity FROM rooms r " +
                     "JOIN room_types rt ON r.room_type_id = rt.room_type_id " +
                     "WHERE r.status = 'AVAILABLE' AND NOT EXISTS (" +
                     "  SELECT 1 FROM reservations res " +
                     "  WHERE res.room_id = r.room_id " +
                     "  AND res.status IN ('CONFIRMED', 'CHECKED_IN') " +
                     "  AND (" +
                     "    (res.check_in_date <= ? AND res.check_out_date > ?) OR " +
                     "    (res.check_in_date < ? AND res.check_out_date >= ?) OR " +
                     "    (res.check_in_date >= ? AND res.check_out_date <= ?)" +
                     "  )" +
                     ")";
        
        try (Connection conn = DatabaseConfig.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setDate(1, checkIn);
            stmt.setDate(2, checkIn);
            stmt.setDate(3, checkOut);
            stmt.setDate(4, checkOut);
            stmt.setDate(5, checkIn);
            stmt.setDate(6, checkOut);
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                rooms.add(mapResultSetToRoom(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }

    @Override
    public boolean isRoomAvailable(int roomId, Date checkIn, Date checkOut) {
        String sql = "SELECT CheckRoomAvailability(?, ?, ?)";
        try (Connection conn = DatabaseConfig.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, roomId);
            stmt.setDate(2, checkIn);
            stmt.setDate(3, checkOut);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getBoolean(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public int countAvailableRooms() {
        // Count rooms that are not currently occupied (checked in or reserved for today)
        String sql = "SELECT COUNT(*) FROM rooms r WHERE r.status = 'AVAILABLE' AND NOT EXISTS (" +
                     "  SELECT 1 FROM reservations res " +
                     "  WHERE res.room_id = r.room_id " +
                     "  AND res.status IN ('CONFIRMED', 'CHECKED_IN') " +
                     "  AND CURDATE() BETWEEN res.check_in_date AND res.check_out_date" +
                     ")";
        try (Connection conn = DatabaseConfig.getInstance().getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Room mapResultSetToRoom(ResultSet rs) throws SQLException {
        Room room = new Room();
        room.setRoomId(rs.getInt("room_id"));
        room.setRoomNumber(rs.getString("room_number"));
        room.setRoomTypeId(rs.getInt("room_type_id"));
        room.setFloorNumber(rs.getInt("floor_number"));
        room.setStatus(rs.getString("status"));
        
        // Map joined RoomType data if present
        try {
            RoomType type = new RoomType();
            type.setRoomTypeId(rs.getInt("room_type_id"));
            type.setTypeName(rs.getString("type_name"));
            type.setBasePrice(rs.getBigDecimal("base_price"));
            type.setCapacity(rs.getInt("capacity"));
            room.setRoomType(type);
        } catch (SQLException e) {
            // Columns might not be present if validatng simple select
        }
        
        return room;
    }
}
