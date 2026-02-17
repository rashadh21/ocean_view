package com.oceanview.factory;

import com.oceanview.dao.*;
import com.oceanview.dao.impl.*;

public class DAOFactory {
    
    private static UserDAO userDAO = new UserDAOImpl();
    private static RoomDAO roomDAO = new RoomDAOImpl();
    private static RoomTypeDAO roomTypeDAO = new RoomTypeDAOImpl();
    private static GuestDAO guestDAO = new GuestDAOImpl();
    private static ReservationDAO reservationDAO = new ReservationDAOImpl();
    private static BillDAO billDAO = new BillDAOImpl();

    public static UserDAO getUserDAO() {
        return userDAO;
    }

    public static RoomDAO getRoomDAO() {
        return roomDAO;
    }

    public static RoomTypeDAO getRoomTypeDAO() {
        return roomTypeDAO;
    }

    public static GuestDAO getGuestDAO() {
        return guestDAO;
    }

    public static ReservationDAO getReservationDAO() {
        return reservationDAO;
    }

    public static BillDAO getBillDAO() {
        return billDAO;
    }
}
