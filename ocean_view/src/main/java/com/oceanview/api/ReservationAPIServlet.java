package com.oceanview.api;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.oceanview.model.Reservation;
import com.oceanview.service.ReservationService;
import com.oceanview.util.ValidationUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/api/v1/reservations/*")
public class ReservationAPIServlet extends HttpServlet {

    private ReservationService reservationService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        reservationService = new ReservationService();
        gson = new GsonBuilder().setDateFormat("yyyy-MM-dd").create();
    }

    private void sendJson(HttpServletResponse response, Object obj) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(obj));
        out.flush();
    }

    private void sendError(HttpServletResponse response, int status, String message) throws IOException {
        response.setStatus(status);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print("{\"error\": \"" + message + "\"}");
        out.flush();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                List<Reservation> reservations = reservationService.getAllReservations();
                sendJson(response, reservations);
            } else {
                String idStr = pathInfo.substring(1); // /123 or /RES20230001
                if (idStr.matches("\\d+")) {
                    Reservation res = reservationService.getReservationById(Integer.parseInt(idStr));
                    if (res != null) {
                        sendJson(response, res);
                    } else {
                        sendError(response, HttpServletResponse.SC_NOT_FOUND, "Reservation not found");
                    }
                } else {
                     Reservation res = reservationService.getReservationByNumber(idStr);
                     if (res != null) {
                        sendJson(response, res);
                     } else {
                        sendError(response, HttpServletResponse.SC_NOT_FOUND, "Reservation not found");
                     }
                }
            }
        } catch (Exception e) {
            sendError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            BufferedReader reader = request.getReader();
            Reservation reservation = gson.fromJson(reader, Reservation.class);
            
            if (reservation == null) {
                sendError(response, HttpServletResponse.SC_BAD_REQUEST, "Invalid request body");
                return;
            }

            reservationService.createReservation(reservation);
            response.setStatus(HttpServletResponse.SC_CREATED);
            sendJson(response, "Reservation created successfully");

        } catch (Exception e) {
            sendError(response, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        }
    }
    
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
         if (pathInfo == null || pathInfo.equals("/")) {
             sendError(response, HttpServletResponse.SC_BAD_REQUEST, "Reservation ID required");
             return;
         }
         
         try {
             String idStr = pathInfo.substring(1);
             int id = Integer.parseInt(idStr);
             reservationService.cancelReservation(id);
             response.setStatus(HttpServletResponse.SC_NO_CONTENT);
         } catch (NumberFormatException e) {
             sendError(response, HttpServletResponse.SC_BAD_REQUEST, "Invalid ID format");
         } catch (Exception e) {
             sendError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
         }
    }
}
