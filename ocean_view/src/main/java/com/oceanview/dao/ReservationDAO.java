package com.oceanview.dao;

import com.oceanview.model.Reservation;
import java.util.Optional;

public interface ReservationDAO extends BaseDAO<Reservation> {
    Optional<Reservation> findByReservationNumber(String reservationNumber);
}
