package com.sportfield.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.sportfield.model.Booking;
import com.sportfield.model.BookingDetail;
import com.sportfield.utils.DBContext;

public class BookingDAO {

    public List<Booking> getAllBookings() {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, u.FullName AS CustomerName, u.Phone AS CustomerPhone "
                   + "FROM Bookings b LEFT JOIN Users u ON b.CustomerID = u.UserID "
                   + "ORDER BY b.CreatedAt DESC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                rs = ps.executeQuery();

                while (rs.next()) {
                    Booking booking = mapBooking(rs);
                    booking.setCustomerName(rs.getString("CustomerName"));
                    booking.setCustomerPhone(rs.getString("CustomerPhone"));
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

    public List<Booking> getBookingsByStatus(String status) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, u.FullName AS CustomerName, u.Phone AS CustomerPhone "
                   + "FROM Bookings b LEFT JOIN Users u ON b.CustomerID = u.UserID "
                   + "WHERE b.Status = ? ORDER BY b.CreatedAt DESC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setString(1, status);
                rs = ps.executeQuery();

                while (rs.next()) {
                    Booking booking = mapBooking(rs);
                    booking.setCustomerName(rs.getString("CustomerName"));
                    booking.setCustomerPhone(rs.getString("CustomerPhone"));
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

    public Booking getBookingByID(int bookingID) {
        String sql = "SELECT b.*, u.FullName AS CustomerName, u.Phone AS CustomerPhone "
                   + "FROM Bookings b LEFT JOIN Users u ON b.CustomerID = u.UserID "
                   + "WHERE b.BookingID = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setInt(1, bookingID);
                rs = ps.executeQuery();

                if (rs.next()) {
                    Booking booking = mapBooking(rs);
                    booking.setCustomerName(rs.getString("CustomerName"));
                    booking.setCustomerPhone(rs.getString("CustomerPhone"));
                    return booking;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }

        return null;
    }

    public List<BookingDetail> getDetailsByBookingID(int bookingID) {
        List<BookingDetail> details = new ArrayList<>();
        String sql = "SELECT bd.*, f.FieldName, fs.StartTime AS SlotStart, fs.EndTime AS SlotEnd "
                   + "FROM BookingDetails bd "
                   + "LEFT JOIN FieldSlots fs ON bd.SlotID = fs.SlotID "
                   + "LEFT JOIN Fields f ON fs.FieldID = f.FieldID "
                   + "WHERE bd.BookingID = ? ORDER BY bd.BookingDate, fs.StartTime";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setInt(1, bookingID);
                rs = ps.executeQuery();

                while (rs.next()) {
                    BookingDetail detail = new BookingDetail();
                    detail.setDetailID(rs.getInt("DetailID"));
                    detail.setBookingID(rs.getInt("BookingID"));
                    detail.setSlotID(rs.getInt("SlotID"));

                    Date bookingDate = rs.getDate("BookingDate");
                    if (bookingDate != null) {
                        detail.setBookingDate(bookingDate.toLocalDate());
                    }

                    detail.setPrice(rs.getBigDecimal("Price"));
                    detail.setFieldName(rs.getString("FieldName"));

                    java.sql.Time startTime = rs.getTime("SlotStart");
                    java.sql.Time endTime = rs.getTime("SlotEnd");
                    if (startTime != null) {
                        detail.setSlotStartTime(startTime.toString().substring(0, 5));
                    }
                    if (endTime != null) {
                        detail.setSlotEndTime(endTime.toString().substring(0, 5));
                    }

                    details.add(detail);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }

        return details;
    }

    public boolean insertBooking(Booking booking) {
        String sql = "INSERT INTO Bookings (CustomerID, BookingType, TotalPrice, Deposit, Status, Note, CreatedAt) "
                   + "VALUES (?, ?, ?, ?, ?, ?, GETDATE())";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setInt(1, booking.getCustomerID());
                ps.setString(2, booking.getBookingType());
                ps.setBigDecimal(3, booking.getTotalPrice());
                ps.setBigDecimal(4, booking.getDeposit());
                ps.setString(5, booking.getStatus());
                ps.setString(6, booking.getNote());

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

    public boolean updateBooking(Booking booking) {
        String sql = "UPDATE Bookings SET BookingType = ?, TotalPrice = ?, Deposit = ?, Status = ?, Note = ? "
                   + "WHERE BookingID = ?";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setString(1, booking.getBookingType());
                ps.setBigDecimal(2, booking.getTotalPrice());
                ps.setBigDecimal(3, booking.getDeposit());
                ps.setString(4, booking.getStatus());
                ps.setString(5, booking.getNote());
                ps.setInt(6, booking.getBookingID());

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

    public boolean deleteBooking(int bookingID) {
        Connection conn = null;
        PreparedStatement ps1 = null;
        PreparedStatement ps2 = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                conn.setAutoCommit(false);

                ps1 = conn.prepareStatement("DELETE FROM BookingDetails WHERE BookingID = ?");
                ps1.setInt(1, bookingID);
                ps1.executeUpdate();

                ps2 = conn.prepareStatement("DELETE FROM Bookings WHERE BookingID = ?");
                ps2.setInt(1, bookingID);
                int rows = ps2.executeUpdate();

                conn.commit();
                return rows > 0;
            }
        } catch (Exception e) {
            try {
                if (conn != null) conn.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            DBContext.close(null, ps1, null);
            DBContext.close(conn, ps2, null);
        }

        return false;
    }

    public int countBookingsToday() {
        String sql = "SELECT COUNT(*) FROM Bookings WHERE CAST(CreatedAt AS DATE) = CAST(GETDATE() AS DATE)";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                rs = ps.executeQuery();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return 0;
    }

    public BigDecimal getMonthlyRevenue() {
        String sql = "SELECT ISNULL(SUM(TotalPrice), 0) FROM Bookings "
                   + "WHERE MONTH(CreatedAt) = MONTH(GETDATE()) AND YEAR(CreatedAt) = YEAR(GETDATE()) "
                   + "AND Status IN ('CONFIRMED', 'COMPLETED')";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                rs = ps.executeQuery();
                if (rs.next()) {
                    return rs.getBigDecimal(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return BigDecimal.ZERO;
    }

    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM Bookings WHERE Status = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setString(1, status);
                rs = ps.executeQuery();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return 0;
    }

    private Booking mapBooking(ResultSet rs) throws Exception {
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

        return booking;
    }
}
