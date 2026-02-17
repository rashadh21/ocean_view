package com.oceanview.controller;

import com.oceanview.factory.DAOFactory;
import com.oceanview.model.Guest;
import com.oceanview.model.Reservation;
import com.oceanview.model.User;
import com.oceanview.service.ReservationService;
import com.oceanview.dao.GuestDAO;
import com.oceanview.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/reservation")
public class ReservationServlet extends HttpServlet {

    private ReservationService reservationService;
    private GuestDAO guestDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        reservationService = new ReservationService();
        guestDAO = DAOFactory.getGuestDAO();
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
                viewReservation(request, response);
                break;
            case "cancel":
                cancelReservation(request, response);
                break;
            case "list":
            default:
                listReservations(request, response);
                break;
        }
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/reservation/new-reservation.jsp").forward(request, response);
    }

    private void viewReservation(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                Reservation reservation = reservationService.getReservationById(id);
                // Try number if ID fails or logic handles both?
                // The URL param "id" usually implies ID. If it's reservation number, we need checks.
                // Assuming ID for now based on typical patterns.
                
                request.setAttribute("reservation", reservation);
                request.getRequestDispatcher("/WEB-INF/views/reservation/view-reservation.jsp").forward(request, response);
                return;
            } catch (NumberFormatException e) {
                // Ignore
            }
        }
        response.sendRedirect("reservation?action=list");
    }

    private void listReservations(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Reservation> listReservation = reservationService.getAllReservations();
        request.setAttribute("listReservation", listReservation);
        request.getRequestDispatcher("/WEB-INF/views/reservation/reservation-list.jsp").forward(request, response);
    }
    
    private void cancelReservation(HttpServletRequest request, HttpServletResponse response) throws IOException {
         try {
            int id = Integer.parseInt(request.getParameter("id"));
            reservationService.cancelReservation(id);
         } catch (Exception e) {
             // Handle error
         }
         response.sendRedirect("reservation?action=list");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Simplify: Retrieve params directly
            String fullName = request.getParameter("guestName");
            String contact = request.getParameter("contact");
            String checkIn = request.getParameter("checkInDate");
            String checkOut = request.getParameter("checkOutDate");
            
            // Validation
            if (!ValidationUtil.validatePhone(contact)) {
                throw new IllegalArgumentException("Invalid phone number");
            }
            
            // Guest
            Guest guest = new Guest();
            guest.setFullName(ValidationUtil.sanitize(fullName));
            guest.setContactNumber(contact);
            guest.setAddress(ValidationUtil.sanitize(request.getParameter("address")));
            guest.setEmail(ValidationUtil.sanitize(request.getParameter("email")));
            // Save guest
            guestDAO.save(guest);
            
            // Reservation
            Reservation reservation = new Reservation();
            reservation.setGuestId(guest.getGuestId());
            reservation.setRoomId(Integer.parseInt(request.getParameter("roomId")));
            reservation.setCheckInDate(Date.valueOf(checkIn));
            reservation.setCheckOutDate(Date.valueOf(checkOut));
            reservation.setNumberOfGuests(Integer.parseInt(request.getParameter("numGuests")));
            reservation.setSpecialRequests(ValidationUtil.sanitize(request.getParameter("specialRequests")));
            
            User user = (User) request.getSession().getAttribute("user");
            reservation.setCreatedBy(user.getUserId());

            reservationService.createReservation(reservation);
            
            // Redirect to view
            // since we don't have the reservation ID easily without refetching or returning from service
            // let's redirect to list for now
            response.sendRedirect("reservation?action=list");

        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/reservation/new-reservation.jsp").forward(request, response);
        }
    }
}
