package com.oceanview.api;

import com.google.gson.Gson;
import com.oceanview.model.Guest;
import com.oceanview.service.GuestService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/api/v1/guests")
public class GuestAPIServlet extends HttpServlet {

    private GuestService guestService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        guestService = new GuestService();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String query = request.getParameter("search");
        List<Guest> guests;
        
        if (query != null && !query.trim().isEmpty()) {
            guests = guestService.searchGuests(query.trim());
        } else {
            guests = guestService.getAllGuests();
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(guests));
        out.flush();
    }
}
