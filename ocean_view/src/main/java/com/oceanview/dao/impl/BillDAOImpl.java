package com.oceanview.dao.impl;

import com.oceanview.config.DatabaseConfig;
import com.oceanview.dao.BillDAO;
import com.oceanview.model.Bill;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class BillDAOImpl implements BillDAO {

    @Override
    public Optional<Bill> getById(int id) {
        String sql = "SELECT * FROM bills WHERE bill_id = ?";
        return getBill(id, sql);
    }

    @Override
    public List<Bill> getAll() {
        List<Bill> bills = new ArrayList<>();
        String sql = "SELECT * FROM bills";
        try (Connection conn = DatabaseConfig.getInstance().getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                bills.add(mapResultSetToBill(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bills;
    }

    @Override
    public void save(Bill bill) {
        String sql = "INSERT INTO bills (reservation_id, total_nights, room_charges, tax_amount, service_charges, discount, total_amount) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseConfig.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            setBillStatementParams(bill, stmt);
            
            stmt.executeUpdate();
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    bill.setBillId(generatedKeys.getInt(1));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void update(Bill bill) {
        String sql = "UPDATE bills SET reservation_id = ?, total_nights = ?, room_charges = ?, tax_amount = ?, service_charges = ?, discount = ?, total_amount = ?, payment_status = ?, payment_method = ? WHERE bill_id = ?";
        try (Connection conn = DatabaseConfig.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            setBillStatementParams(bill, stmt);
            stmt.setString(8, bill.getPaymentStatus());
            stmt.setString(9, bill.getPaymentMethod());
            stmt.setInt(10, bill.getBillId());
            
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void setBillStatementParams(Bill bill, PreparedStatement stmt) throws SQLException {
        stmt.setInt(1, bill.getReservationId());
        stmt.setInt(2, bill.getTotalNights());
        stmt.setBigDecimal(3, bill.getRoomCharges());
        stmt.setBigDecimal(4, bill.getTaxAmount());
        stmt.setBigDecimal(5, bill.getServiceCharges());
        stmt.setBigDecimal(6, bill.getDiscount());
        stmt.setBigDecimal(7, bill.getTotalAmount());
    }

    @Override
    public void delete(int id) {
        String sql = "DELETE FROM bills WHERE bill_id = ?";
        try (Connection conn = DatabaseConfig.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Optional<Bill> findByReservationId(int reservationId) {
        String sql = "SELECT * FROM bills WHERE reservation_id = ?";
        try (Connection conn = DatabaseConfig.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, reservationId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return Optional.of(mapResultSetToBill(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    private Optional<Bill> getBill(int id, String sql) {
        try (Connection conn = DatabaseConfig.getInstance().getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return Optional.of(mapResultSetToBill(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return Optional.empty();
    }

    @Override
    public double calculateTodayRevenue() {
        String sql = "SELECT SUM(total_amount) FROM bills WHERE bill_date = CURDATE() AND payment_status = 'PAID'";
        try (Connection conn = DatabaseConfig.getInstance().getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    private Bill mapResultSetToBill(ResultSet rs) throws SQLException {
        Bill bill = new Bill();
        bill.setBillId(rs.getInt("bill_id"));
        bill.setReservationId(rs.getInt("reservation_id"));
        bill.setTotalNights(rs.getInt("total_nights"));
        bill.setRoomCharges(rs.getBigDecimal("room_charges"));
        bill.setTaxAmount(rs.getBigDecimal("tax_amount"));
        bill.setServiceCharges(rs.getBigDecimal("service_charges"));
        bill.setDiscount(rs.getBigDecimal("discount"));
        bill.setTotalAmount(rs.getBigDecimal("total_amount"));
        bill.setPaymentStatus(rs.getString("payment_status"));
        bill.setPaymentMethod(rs.getString("payment_method"));
        bill.setBillDate(rs.getTimestamp("bill_date"));
        return bill;
    }
}
