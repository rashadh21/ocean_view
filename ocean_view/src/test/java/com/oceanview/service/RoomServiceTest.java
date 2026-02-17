package com.oceanview.service;

import com.oceanview.dao.RoomDAO;
import com.oceanview.dao.RoomTypeDAO;
import com.oceanview.model.Room;
import com.oceanview.model.RoomType;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.sql.Date;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

class RoomServiceTest {

    @Mock
    private RoomDAO roomDAO;

    @Mock
    private RoomTypeDAO roomTypeDAO;

    private RoomService roomService;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        roomService = new RoomService(roomDAO, roomTypeDAO);
    }

    @Test
    void testGetAvailableRooms() {
        LocalDate checkIn = LocalDate.now().plusDays(1);
        LocalDate checkOut = LocalDate.now().plusDays(3);
        
        Room room1 = new Room();
        room1.setRoomId(1);
        room1.setRoomNumber("101");
        
        when(roomDAO.getAvailableRooms(Date.valueOf(checkIn), Date.valueOf(checkOut)))
                .thenReturn(Arrays.asList(room1));
        
        List<Room> result = roomService.getAvailableRooms(checkIn, checkOut);
        
        assertNotNull(result);
        assertEquals(1, result.size());
        assertEquals("101", result.get(0).getRoomNumber());
    }

    @Test
    void testIsRoomAvailable_True() {
        LocalDate checkIn = LocalDate.now().plusDays(1);
        LocalDate checkOut = LocalDate.now().plusDays(2);
        
        when(roomDAO.isRoomAvailable(1, Date.valueOf(checkIn), Date.valueOf(checkOut)))
                .thenReturn(true);
        
        boolean result = roomService.isRoomAvailable(1, checkIn, checkOut);
        assertTrue(result);
    }
    
    @Test
    void testIsRoomAvailable_InvalidDates() {
        LocalDate checkIn = LocalDate.now().plusDays(5);
        LocalDate checkOut = LocalDate.now().plusDays(2); // CheckOut before CheckIn
        
        boolean result = roomService.isRoomAvailable(1, checkIn, checkOut);
        assertFalse(result);
    }
}
