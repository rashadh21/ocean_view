package com.oceanview.controller;

import com.oceanview.model.Bill;
import com.oceanview.service.BillingService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;

@WebServlet("/bill")
public class BillServlet extends HttpServlet {

    private BillingService billingService;

    @Override
    public void init() throws ServletException {
        super.init();
        billingService = new BillingService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String reservationIdStr = request.getParameter("reservationId");
        String action = request.getParameter("action"); // 'generate' or 'view'

        if (reservationIdStr != null) {
            try {
                int reservationId = Integer.parseInt(reservationIdStr);
                Bill bill = billingService.calculateAndGenerateBill(reservationId);
                
                if (bill != null) {
                    if ("pdf".equals(action)) {
                        downloadPDF(bill, response);
                    } else {
                        request.setAttribute("bill", bill);
                        request.getRequestDispatcher("/WEB-INF/views/billing/generate-bill.jsp").forward(request, response);
                    }
                } else {
                     response.sendError(HttpServletResponse.SC_NOT_FOUND, "Bill could not be generated");
                }
            } catch (Exception e) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing bill: " + e.getMessage());
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Reservation ID is required");
        }
    }

    private void downloadPDF(Bill bill, HttpServletResponse response) throws IOException {
        byte[] pdfBytes = billingService.generatePDF(bill);
        
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"bill_" + bill.getBillId() + ".pdf\"");
        response.setContentLength(pdfBytes.length);
        
        try (OutputStream os = response.getOutputStream()) {
            os.write(pdfBytes);
        }
    }
}
