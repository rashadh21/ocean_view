package com.oceanview.service;

import com.oceanview.dao.RoomDAO;
import com.oceanview.dao.RoomTypeDAO;
import com.oceanview.factory.DAOFactory;
import com.oceanview.model.Room;
import com.oceanview.model.RoomType;

import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

public class RoomService {
    
    private RoomDAO roomDAO;
    private RoomTypeDAO roomTypeDAO;

    public RoomService() {
        this.roomDAO = DAOFactory.getRoomDAO();
        this.roomTypeDAO = DAOFactory.getRoomTypeDAO();
    }

    // Constructor for testing
    public RoomService(RoomDAO roomDAO, RoomTypeDAO roomTypeDAO) {
        this.roomDAO = roomDAO;
        this.roomTypeDAO = roomTypeDAO;
    }
    
    public List<Room> getAvailableRooms(LocalDate checkIn, LocalDate checkOut) {
        return roomDAO.getAvailableRooms(Date.valueOf(checkIn), Date.valueOf(checkOut));
    }

    public boolean isRoomAvailable(int roomId, LocalDate checkIn, LocalDate checkOut) {
        // Basic validation
        if (checkIn.isAfter(checkOut) || checkIn.isBefore(LocalDate.now())) {
            return false;
        }
        return roomDAO.isRoomAvailable(roomId, Date.valueOf(checkIn), Date.valueOf(checkOut));
    }
    
    public List<RoomType> getAllRoomTypes() {
        return roomTypeDAO.getAll();
    }
    
    public Room getRoomById(int id) {
        return roomDAO.getById(id).orElse(null);
    }
}
