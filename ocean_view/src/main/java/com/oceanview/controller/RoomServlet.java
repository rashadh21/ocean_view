package com.oceanview.controller;

import com.oceanview.model.Room;
import com.oceanview.service.RoomService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/rooms")
public class RoomServlet extends HttpServlet {

    private RoomService roomService;

    @Override
    public void init() throws ServletException {
        super.init();
        roomService = new RoomService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        if ("available".equals(action)) {
            checkAvailability(request, response);
        } else {
            // List rooms logic (for admin possibly?, or general view)
            // For now, let's just forward to a room list page
            request.getRequestDispatcher("/WEB-INF/views/room/room-list.jsp").forward(request, response);
        }
    }

    private void checkAvailability(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String checkInStr = request.getParameter("checkIn");
        String checkOutStr = request.getParameter("checkOut");

        if (checkInStr != null && checkOutStr != null) {
            try {
                LocalDate checkIn = LocalDate.parse(checkInStr);
                LocalDate checkOut = LocalDate.parse(checkOutStr);
                
                List<Room> availableRooms = roomService.getAvailableRooms(checkIn, checkOut);
                request.setAttribute("availableRooms", availableRooms);
                
            } catch (Exception e) {
                request.setAttribute("error", "Invalid date format");
            }
        }
        request.getRequestDispatcher("/WEB-INF/views/room/room-availability.jsp").forward(request, response);
    }
}
