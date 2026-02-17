package com.oceanview.service;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.dao.RoomDAO;
import com.oceanview.factory.DAOFactory;
import com.oceanview.model.Reservation;
import com.oceanview.util.ValidationUtil;

import java.sql.Date;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public class ReservationService {
    
    private ReservationDAO reservationDAO;
    private RoomDAO roomDAO;

    public ReservationService() {
        this.reservationDAO = DAOFactory.getReservationDAO();
        this.roomDAO = DAOFactory.getRoomDAO();
    }
    
    public List<Reservation> getAllReservations() {
        return reservationDAO.getAll();
    }
    
    public Reservation getReservationById(int id) {
        return reservationDAO.getById(id).orElse(null);
    }
    
    public Reservation getReservationByNumber(String number) {
        return reservationDAO.findByReservationNumber(number).orElse(null);
    }
    
    public String createReservation(Reservation reservation) throws Exception {
        // Validation
        if (!ValidationUtil.isValidDateRange(reservation.getCheckInDate().toLocalDate(), reservation.getCheckOutDate().toLocalDate())) {
            throw new IllegalArgumentException("Invalid date range: Check-out date must be after Check-in date.");
        }
        
        // Check availability strictly again before creation
        boolean available = roomDAO.isRoomAvailable(reservation.getRoomId(), reservation.getCheckInDate(), reservation.getCheckOutDate());
        if (!available) {
            throw new IllegalStateException("Room is not available for the selected dates");
        }
        
        reservationDAO.save(reservation);
        
        // After save, we need to get the generated reservation number.
        // Since we don't have it potentially (trigger generated), we might need to query it back 
        // or rely on the `reservationId` which is set.
        // Ideally, the DAO should refresh the object or we make a second call.
        // For simplicity, we return success or the ID.
        // Let's try to fetch it if we can, or just return ID.
        // Given the trigger logic, it's safer to just return a success message or the ID if we can't easily get the number without a fresh select.
        
        return "Reservation Created Successfully"; 
    }
    
    public void updateReservationStatus(int reservationId, String status) {
        Optional<Reservation> resOpt = reservationDAO.getById(reservationId);
        if (resOpt.isPresent()) {
            Reservation res = resOpt.get();
            res.setStatus(status);
            reservationDAO.update(res);
        }
    }
    
    public void cancelReservation(int reservationId) {
        updateReservationStatus(reservationId, "CANCELLED");
    }
}
