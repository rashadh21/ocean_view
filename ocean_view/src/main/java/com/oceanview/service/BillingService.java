package com.oceanview.service;

import com.oceanview.config.DatabaseConfig;
import com.oceanview.dao.BillDAO;
import com.oceanview.factory.DAOFactory;
import com.oceanview.model.Bill;
import com.oceanview.util.PDFGenerator;

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Types;

public class BillingService {
    
    private BillDAO billDAO;

    public BillingService() {
        this.billDAO = DAOFactory.getBillDAO();
    }
    
    public Bill calculateAndGenerateBill(int reservationId) throws SQLException {
        // Check if bill already exists
        return billDAO.findByReservationId(reservationId).orElseGet(() -> {
            try {
                return createBillUsingProcedure(reservationId);
            } catch (SQLException e) {
                e.printStackTrace();
                return null;
            }
        });
    }

    private Bill createBillUsingProcedure(int reservationId) throws SQLException {
        try (Connection conn = DatabaseConfig.getInstance().getConnection();
             CallableStatement stmt = conn.prepareCall("{CALL CalculateBill(?, ?)}")) {
            
            stmt.setInt(1, reservationId);
            stmt.registerOutParameter(2, Types.DECIMAL);
            stmt.execute();
            
            // The procedure inserts the bill, so we can now fetch it
            return billDAO.findByReservationId(reservationId).orElse(null);
        }
    }
    
    public Bill getBillByReservationId(int reservationId) {
        return billDAO.findByReservationId(reservationId).orElse(null);
    }
    
    public byte[] generatePDF(Bill bill) {
        return PDFGenerator.generateBillPDF(bill);
    }
}
