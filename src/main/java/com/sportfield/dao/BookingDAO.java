package com.sportfield.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.sportfield.model.Booking;
import com.sportfield.utils.DBContext;

public class BookingDAO {
    public List<Booking> getAllBookings() {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM Bookings ORDER BY CreatedAt DESC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                rs = ps.executeQuery();

                while (rs.next()) {
                    Booking booking = new Booking();
                    booking.setBookingID(rs.getInt("BookingID"));
                    booking.setCustomerID(rs.getInt("CustomerID"));
                    booking.setBookingType(rs.getString("BookingType"));
                    booking.setTotalPrice(rs.getBigDecimal("TotalPrice"));
                    booking.setDeposit(rs.getBigDecimal("Deposit"));
                    booking.setStatus(rs.getString("Status"));
                    booking.setNote(rs.getString("Note"));

                    Timestamp createdAt = rs.getTimestamp("CreatedAt");
                    if (createdAt != null) {
                        booking.setCreatedAt(createdAt.toLocalDateTime());
                    }

                    bookings.add(booking);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }

        return bookings;
    }

    public boolean updateStatus(int bookingID, String status) {
        String sql = "UPDATE Bookings SET Status = ? WHERE BookingID = ?";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setString(1, status);
                ps.setInt(2, bookingID);

                int rows = ps.executeUpdate();
                return rows > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, null);
        }

        return false;
    }
}

