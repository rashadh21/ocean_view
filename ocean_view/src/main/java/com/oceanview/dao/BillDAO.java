package com.oceanview.dao;

import com.oceanview.model.Bill;
import java.util.Optional;

public interface BillDAO extends BaseDAO<Bill> {
    Optional<Bill> findByReservationId(int reservationId);
    double calculateTodayRevenue();
}
