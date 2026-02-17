package com.oceanview.controller;

import com.oceanview.model.Guest;
import com.oceanview.service.GuestService;
import com.oceanview.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/guests")
public class GuestServlet extends HttpServlet {

    private GuestService guestService;

    @Override
    public void init() throws ServletException {
        super.init();
        guestService = new GuestService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "new":
                showNewForm(request, response);
                break;
            case "view":
                // Implement view logic if needed
                listGuests(request, response);
                break;
            case "list":
            default:
                listGuests(request, response);
                break;
        }
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/guest/new-guest.jsp").forward(request, response);
    }

    private void listGuests(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String query = request.getParameter("search");
        List<Guest> guests;
        if (query != null && !query.trim().isEmpty()) {
            guests = guestService.searchGuests(query.trim());
        } else {
            guests = guestService.getAllGuests();
        }
        request.setAttribute("guests", guests);
        request.getRequestDispatcher("/WEB-INF/views/guest/guest-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String fullName = request.getParameter("fullName");
            String contact = request.getParameter("contactNumber");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String idNumber = request.getParameter("idNumber"); // If you added this field
            String nationality = request.getParameter("nationality"); // If added

            // Validation
            if (!ValidationUtil.validatePhone(contact)) {
                throw new IllegalArgumentException("Invalid phone number");
            }

            Guest guest = new Guest();
            guest.setFullName(ValidationUtil.sanitize(fullName));
            guest.setContactNumber(contact);
            guest.setEmail(ValidationUtil.sanitize(email));
            guest.setAddress(ValidationUtil.sanitize(address));
            // Set other fields if available in form and model
            
            guestService.registerGuest(guest);
            
            response.sendRedirect("guests?action=list");

        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/guest/new-guest.jsp").forward(request, response);
        }
    }
}
