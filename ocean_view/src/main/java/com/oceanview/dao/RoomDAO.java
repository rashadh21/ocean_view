package com.oceanview.dao;

import com.oceanview.model.Room;
import java.sql.Date;
import java.util.List;

public interface RoomDAO extends BaseDAO<Room> {
    List<Room> getAvailableRooms(Date checkIn, Date checkOut);
    boolean isRoomAvailable(int roomId, Date checkIn, Date checkOut);
    int countAvailableRooms();
}
