package com.oceanview.service;

import com.oceanview.dao.GuestDAO;
import com.oceanview.factory.DAOFactory;
import com.oceanview.model.Guest;
import java.util.List;
import java.util.Optional;

public class GuestService {
    
    private GuestDAO guestDAO;

    public GuestService() {
        this.guestDAO = DAOFactory.getGuestDAO();
    }
    
    public List<Guest> getAllGuests() {
        return guestDAO.getAll();
    }
    
    public Guest getGuestById(int id) {
        return guestDAO.getById(id).orElse(null);
    }
    
    public List<Guest> searchGuests(String query) {
        return guestDAO.searchGuests(query);
    }
    
    public void registerGuest(Guest guest) {
        // Business logic or validation could go here
        guestDAO.save(guest);
    }
    
    public void updateGuest(Guest guest) {
        guestDAO.update(guest);
    }
    
    public void deleteGuest(int id) {
        guestDAO.delete(id);
    }
}
