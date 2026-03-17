package com.sportfield.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.sportfield.model.Booking;
import com.sportfield.model.BookingDetail;
import com.sportfield.utils.DBContext;

public class BookingDAO {

    private static final Logger LOGGER = Logger.getLogger(BookingDAO.class.getName());

    public List<Integer> getBookedSlotIDs(int fieldID, LocalDate date) {
        List<Integer> bookedSlotIDs = new ArrayList<>();
        String sql = "SELECT bd.SlotID "
                   + "FROM BookingDetails bd "
                   + "INNER JOIN FieldSlots fs ON bd.SlotID = fs.SlotID "
                   + "INNER JOIN Bookings b ON bd.BookingID = b.BookingID "
                   + "WHERE fs.FieldID = ? AND bd.BookingDate = ? AND b.Status IN ('PENDING', 'CONFIRMED', 'COMPLETED')";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setInt(1, fieldID);
                ps.setDate(2, Date.valueOf(date));
                rs = ps.executeQuery();

                while (rs.next()) {
                    bookedSlotIDs.add(rs.getInt("SlotID"));
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
        } finally {
            DBContext.close(conn, ps, rs);
        }

        return bookedSlotIDs;
    }

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
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
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
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
        } finally {
            DBContext.close(conn, ps, rs);
        }

        return bookings;
    }

    public List<Booking> getBookingsByFilters(String status, String date, String customerName) {
        List<Booking> bookings = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT b.*, u.FullName AS CustomerName, u.Phone AS CustomerPhone " +
                "FROM Bookings b LEFT JOIN Users u ON b.CustomerID = u.UserID WHERE 1=1 ");

        if (status != null && !status.isEmpty()) {
            sql.append("AND b.Status = ? ");
        }
        if (date != null && !date.isEmpty()) {
            sql.append("AND CAST(b.CreatedAt AS DATE) = ? ");
        }
        if (customerName != null && !customerName.isEmpty()) {
            sql.append("AND u.FullName LIKE ? ");
        }

        sql.append("ORDER BY b.CreatedAt DESC");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql.toString());
                int paramIndex = 1;

                if (status != null && !status.isEmpty()) {
                    ps.setString(paramIndex++, status);
                }
                if (date != null && !date.isEmpty()) {
                    ps.setString(paramIndex++, date);
                }
                if (customerName != null && !customerName.isEmpty()) {
                    ps.setString(paramIndex++, "%" + customerName.trim() + "%");
                }

                rs = ps.executeQuery();
                while (rs.next()) {
                    Booking booking = mapBooking(rs);
                    booking.setCustomerName(rs.getString("CustomerName"));
                    booking.setCustomerPhone(rs.getString("CustomerPhone"));
                    bookings.add(booking);
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
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
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
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
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
        } finally {
            DBContext.close(conn, ps, rs);
        }

        return details;
    }

    public List<BookingDetail> getBookingDetailsByDate(String dateStr) {
        List<BookingDetail> details = new ArrayList<>();
        String sql = "SELECT bd.*, f.FieldName, fs.StartTime AS SlotStart, fs.EndTime AS SlotEnd, "
                   + "u.FullName AS CustomerName, u.Phone AS CustomerPhone, b.Status AS BookingStatus "
                   + "FROM BookingDetails bd "
                   + "JOIN Bookings b ON bd.BookingID = b.BookingID "
                   + "JOIN Users u ON b.CustomerID = u.UserID "
                   + "JOIN FieldSlots fs ON bd.SlotID = fs.SlotID "
                   + "JOIN Fields f ON fs.FieldID = f.FieldID "
                   + "WHERE bd.BookingDate = ? "
                   + "ORDER BY f.FieldName, fs.StartTime";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setString(1, dateStr);
                rs = ps.executeQuery();

                while (rs.next()) {
                    BookingDetail detail = new BookingDetail();
                    detail.setDetailID(rs.getInt("DetailID"));
                    detail.setBookingID(rs.getInt("BookingID"));
                    detail.setSlotID(rs.getInt("SlotID"));
                    detail.setBookingDate(rs.getDate("BookingDate").toLocalDate());
                    detail.setPrice(rs.getBigDecimal("Price"));
                    detail.setFieldName(rs.getString("FieldName"));
                    detail.setSlotStartTime(rs.getTime("SlotStart").toString().substring(0, 5));
                    detail.setSlotEndTime(rs.getTime("SlotEnd").toString().substring(0, 5));
                    detail.setCustomerName(rs.getString("CustomerName"));
                    detail.setCustomerPhone(rs.getString("CustomerPhone"));
                    detail.setBookingStatus(rs.getString("BookingStatus"));
                    details.add(detail);
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return details;
    }

    public boolean insertBooking(Booking booking) {
        String sql = "INSERT INTO Bookings (CustomerID, BookingType, TotalPrice, Deposit, Status, Note, "
                   + "PaymentMethod, PaymentStatus, PaidAmount, CreatedAt) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE())";

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
                ps.setString(7, booking.getPaymentMethod() != null ? booking.getPaymentMethod() : "VNPAY");
                ps.setString(8, booking.getPaymentStatus() != null ? booking.getPaymentStatus() : "UNPAID");
                ps.setBigDecimal(9, booking.getPaidAmount() != null ? booking.getPaidAmount() : BigDecimal.ZERO);

                int rows = ps.executeUpdate();
                return rows > 0;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
        } finally {
            DBContext.close(conn, ps, null);
        }

        return false;
    }
    /**
     * Insert booking + booking detail in a single transaction.
     * Returns the new BookingID, or throws RuntimeException on failure.
     */
    public int insertBookingWithDetails(Booking booking, int slotID, java.time.LocalDate bookingDate, BigDecimal slotPrice) {
        String sqlBooking = "INSERT INTO Bookings (CustomerID, BookingType, TotalPrice, Deposit, Status, Note, "
                          + "PaymentMethod, PaymentStatus, PaidAmount, CreatedAt) "
                          + "OUTPUT INSERTED.BookingID "
                          + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE())";
        String sqlDetail = "INSERT INTO BookingDetails (BookingID, SlotID, BookingDate, Price) VALUES (?, ?, ?, ?)";

        Connection conn = null;
        PreparedStatement psBooking = null;
        PreparedStatement psDetail = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                conn.setAutoCommit(false);

                psBooking = conn.prepareStatement(sqlBooking);
                psBooking.setInt(1, booking.getCustomerID());
                psBooking.setString(2, booking.getBookingType());
                psBooking.setBigDecimal(3, booking.getTotalPrice());
                psBooking.setBigDecimal(4, booking.getDeposit());
                psBooking.setString(5, booking.getStatus());
                psBooking.setString(6, booking.getNote());
                psBooking.setString(7, booking.getPaymentMethod() != null ? booking.getPaymentMethod() : "VNPAY");
                psBooking.setString(8, booking.getPaymentStatus() != null ? booking.getPaymentStatus() : "UNPAID");
                psBooking.setBigDecimal(9, booking.getPaidAmount() != null ? booking.getPaidAmount() : BigDecimal.ZERO);

                // OUTPUT INSERTED returns a ResultSet via executeQuery
                rs = psBooking.executeQuery();
                int newBookingID = -1;

                if (rs.next()) {
                    newBookingID = rs.getInt(1);
                }

                if (newBookingID > 0) {
                    psDetail = conn.prepareStatement(sqlDetail);
                    psDetail.setInt(1, newBookingID);
                    psDetail.setInt(2, slotID);
                    psDetail.setDate(3, Date.valueOf(bookingDate));
                    psDetail.setBigDecimal(4, slotPrice);
                    psDetail.executeUpdate();
                }

                conn.commit();
                return newBookingID;
            }
        } catch (Exception e) {
            try {
                if (conn != null) conn.rollback();
            } catch (Exception ex) {
                LOGGER.log(Level.SEVERE, ex.getMessage(), ex);
            }
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
            throw new RuntimeException("Insert booking failed: " + e.getMessage(), e);
        } finally {
            DBContext.close(null, psDetail, null);
            DBContext.close(null, null, rs);
            DBContext.close(conn, psBooking, null);
        }

        return -1;
    }

    public boolean updateBooking(Booking booking) {
        String sql = "UPDATE Bookings SET BookingType = ?, TotalPrice = ?, Deposit = ?, Status = ?, Note = ?, "
                   + "PaymentMethod = ?, PaymentStatus = ?, PaidAmount = ? "
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
                ps.setString(6, booking.getPaymentMethod());
                ps.setString(7, booking.getPaymentStatus());
                ps.setBigDecimal(8, booking.getPaidAmount());
                ps.setInt(9, booking.getBookingID());

                int rows = ps.executeUpdate();
                return rows > 0;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
        } finally {
            DBContext.close(conn, ps, null);
        }

        return false;
    }

    /**
     * Admin checkout: update paid amount + payment status + booking status.
     */
    public boolean updatePaymentInfo(int bookingID, BigDecimal paidAmount, String paymentStatus, String bookingStatus) {
        String sql = "UPDATE Bookings SET PaidAmount = ?, PaymentStatus = ?, Status = ? WHERE BookingID = ?";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setBigDecimal(1, paidAmount);
                ps.setString(2, paymentStatus);
                ps.setString(3, bookingStatus);
                ps.setInt(4, bookingID);

                int rows = ps.executeUpdate();
                return rows > 0;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
        } finally {
            DBContext.close(conn, ps, null);
        }

        return false;
    }

    /**
     * Add service charge to a booking's total price and append description to note.
     */
    public boolean addServiceCharge(int bookingID, BigDecimal amount, String description) {
        String sql = "UPDATE Bookings SET TotalPrice = TotalPrice + ?, "
                   + "Note = CASE WHEN Note IS NULL OR Note = '' THEN ? ELSE Note + CHAR(10) + ? END "
                   + "WHERE BookingID = ?";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                String serviceNote = "[Dịch vụ] " + description + ": " + amount + "đ";
                ps = conn.prepareStatement(sql);
                ps.setBigDecimal(1, amount);
                ps.setString(2, serviceNote);
                ps.setString(3, serviceNote);
                ps.setInt(4, bookingID);

                int rows = ps.executeUpdate();
                return rows > 0;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
        } finally {
            DBContext.close(conn, ps, null);
        }

        return false;
    }

    /**
     * Reset TotalPrice về đúng giá sân (sum BookingDetails), xóa toàn bộ dịch vụ đã thêm.
     */
    public boolean resetServiceCharges(int bookingID) {
        String sqlFieldPrice = "SELECT ISNULL(SUM(Price), 0) FROM BookingDetails WHERE BookingID = ?";
        String sqlUpdateSimple = "UPDATE Bookings SET TotalPrice = ? WHERE BookingID = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sqlFieldPrice);
                ps.setInt(1, bookingID);
                rs = ps.executeQuery();
                BigDecimal fieldPrice = BigDecimal.ZERO;
                if (rs.next()) {
                    fieldPrice = rs.getBigDecimal(1);
                }
                rs.close();
                ps.close();

                ps = conn.prepareStatement(sqlUpdateSimple);
                ps.setBigDecimal(1, fieldPrice);
                ps.setInt(2, bookingID);
                int rows = ps.executeUpdate();
                return rows > 0;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "[BookingDAO] resetServiceCharges error", e);
        } finally {
            DBContext.close(conn, ps, rs);
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
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
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
                LOGGER.log(Level.SEVERE, ex.getMessage(), ex);
            }
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
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
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return 0;
    }

    public BigDecimal getMonthlyRevenue() {
        String sql = "SELECT ISNULL(SUM(TotalPrice), 0) FROM Bookings "
                   + "WHERE MONTH(CreatedAt) = MONTH(GETDATE()) AND YEAR(CreatedAt) = YEAR(GETDATE()) "
                   + "AND Status = 'COMPLETED'";
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
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
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
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return 0;
    }

    public List<BookingDetail> getBookingsByFieldAndWeek(int fieldID, java.time.LocalDate weekStart) {
        List<BookingDetail> details = new ArrayList<>();
        java.time.LocalDate weekEnd = weekStart.plusDays(6);
        
        String sql = "SELECT bd.*, fs.StartTime, fs.EndTime, b.Status AS BookingStatus, "
                   + "u.FullName AS CustomerName, u.Phone AS CustomerPhone "
                   + "FROM BookingDetails bd "
                   + "INNER JOIN FieldSlots fs ON bd.SlotID = fs.SlotID "
                   + "INNER JOIN Bookings b ON bd.BookingID = b.BookingID "
                   + "LEFT JOIN Users u ON b.CustomerID = u.UserID "
                   + "WHERE fs.FieldID = ? AND bd.BookingDate BETWEEN ? AND ? "
                   + "AND b.Status IN ('PENDING', 'CONFIRMED', 'COMPLETED') "
                   + "ORDER BY bd.BookingDate, fs.StartTime";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setInt(1, fieldID);
                ps.setDate(2, Date.valueOf(weekStart));
                ps.setDate(3, Date.valueOf(weekEnd));
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
                    
                    java.sql.Time startTime = rs.getTime("StartTime");
                    java.sql.Time endTime = rs.getTime("EndTime");
                    if (startTime != null) {
                        detail.setSlotStartTime(startTime.toString().substring(0, 5));
                    }
                    if (endTime != null) {
                        detail.setSlotEndTime(endTime.toString().substring(0, 5));
                    }
                    
                    detail.setCustomerName(rs.getString("CustomerName"));
                    detail.setCustomerPhone(rs.getString("CustomerPhone"));
                    
                    details.add(detail);
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
        } finally {
            DBContext.close(conn, ps, rs);
        }

        return details;
    }

    public List<BookingDetail> getBookingsByUserID(int userID) {
        List<BookingDetail> details = new ArrayList<>();
        
        String sql = "SELECT bd.*, b.BookingID, b.Status AS BookingStatus, b.PaymentStatus, b.PaidAmount, b.CreatedAt, "
                   + "f.FieldName, f.FieldType, fs.StartTime, fs.EndTime "
                   + "FROM BookingDetails bd "
                   + "INNER JOIN Bookings b ON bd.BookingID = b.BookingID "
                   + "INNER JOIN FieldSlots fs ON bd.SlotID = fs.SlotID "
                   + "INNER JOIN Fields f ON fs.FieldID = f.FieldID "
                   + "WHERE b.CustomerID = ? "
                   + "ORDER BY bd.BookingDate DESC, fs.StartTime DESC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setInt(1, userID);
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
                    
                    java.sql.Time startTime = rs.getTime("StartTime");
                    java.sql.Time endTime = rs.getTime("EndTime");
                    if (startTime != null) {
                        detail.setSlotStartTime(startTime.toString().substring(0, 5));
                    }
                    if (endTime != null) {
                        detail.setSlotEndTime(endTime.toString().substring(0, 5));
                    }
                    
                    // Set booking status in dedicated field (fixed: was using customerName hack)
                    detail.setBookingStatus(rs.getString("BookingStatus"));
                    detail.setPaymentStatus(rs.getString("PaymentStatus"));
                    detail.setPaidAmount(rs.getBigDecimal("PaidAmount"));
                    
                    details.add(detail);
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
        } finally {
            DBContext.close(conn, ps, rs);
        }

        return details;
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

        // Payment fields
        booking.setPaymentMethod(rs.getString("PaymentMethod"));
        booking.setPaymentStatus(rs.getString("PaymentStatus"));
        booking.setPaidAmount(rs.getBigDecimal("PaidAmount"));

        // Cancel fields
        try {
            booking.setRefundAmount(rs.getBigDecimal("RefundAmount"));
            booking.setCancelReason(rs.getString("CancelReason"));
        } catch (Exception ignored) {
            // Columns may not exist yet before migration
        }

        Timestamp createdAt = rs.getTimestamp("CreatedAt");
        if (createdAt != null) {
            booking.setCreatedAt(createdAt.toLocalDateTime());
        }

        return booking;
    }

    /**
     * Lấy BookingDetail đầu tiên của một booking (dùng để tính thời gian hủy).
     */
    public BookingDetail getFirstDetailByBookingID(int bookingID) {
        String sql = "SELECT TOP 1 bd.*, f.FieldName, fs.StartTime AS SlotStart, fs.EndTime AS SlotEnd "
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

                if (rs.next()) {
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

                    return detail;
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
        } finally {
            DBContext.close(conn, ps, rs);
        }

        return null;
    }

    /**
     * Hủy booking + ghi lý do + số tiền hoàn.
     * Dùng 2 câu UPDATE riêng để tương thích DB chưa có cột RefundAmount/CancelReason.
     */
    public boolean cancelBooking(int bookingID, String cancelReason, BigDecimal refundAmount) {
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            if (conn == null) return false;

            conn.setAutoCommit(false);

            // Bước 1: Cập nhật status + note (các cột chắc chắn tồn tại)
            String cancelNote = "[HỦY] " + cancelReason;
            String sqlBase = "UPDATE Bookings SET Status = 'CANCELLED', "
                           + "Note = ISNULL(Note,'') + CHAR(10) + ? "
                           + "WHERE BookingID = ?";
            ps = conn.prepareStatement(sqlBase);
            ps.setString(1, cancelNote);
            ps.setInt(2, bookingID);
            int rows = ps.executeUpdate();
            ps.close();
            ps = null;

            if (rows > 0) {
                // Bước 2: Thử cập nhật RefundAmount + CancelReason nếu cột tồn tại
                try {
                    String sqlExtra = "UPDATE Bookings SET RefundAmount = ?, CancelReason = ? WHERE BookingID = ?";
                    ps = conn.prepareStatement(sqlExtra);
                    ps.setBigDecimal(1, refundAmount);
                    ps.setString(2, cancelReason);
                    ps.setInt(3, bookingID);
                    ps.executeUpdate();
                    ps.close();
                    ps = null;
                } catch (Exception ignored) {
                    // Cột chưa tồn tại trong DB — bỏ qua, không ảnh hưởng chức năng hủy
                    LOGGER.log(Level.WARNING, "[BookingDAO] RefundAmount/CancelReason columns not found, skipping");
                }
            }

            conn.commit();
            return rows > 0;

        } catch (Exception e) {
            try { if (conn != null) conn.rollback(); } catch (Exception ex) { /* ignore */ }
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
        } finally {
            DBContext.close(conn, ps, null);
        }

        return false;
    }

    /**
     * Auto-cancel PENDING bookings > 30 phút.
     */
    public int autoCancelExpiredPendingBookings() {
        String sql = "UPDATE Bookings SET Status = 'CANCELLED', "
                   + "Note = ISNULL(Note,'') + CHAR(10) + '[AUTO] Hủy do quá thời gian thanh toán' "
                   + "WHERE Status = 'PENDING' AND DATEDIFF(MINUTE, CreatedAt, GETDATE()) > 30";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                return ps.executeUpdate();
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
        } finally {
            DBContext.close(conn, ps, null);
        }
        return 0;
    }

    /**
     * Auto-complete bookings đã qua ngày đá.
     */
    public int autoCompletePassedBookings() {
        String sql = "UPDATE b SET b.Status = 'COMPLETED' FROM Bookings b "
                   + "INNER JOIN BookingDetails bd ON b.BookingID = bd.BookingID "
                   + "INNER JOIN FieldSlots fs ON bd.SlotID = fs.SlotID "
                   + "WHERE b.Status = 'CONFIRMED' "
                   + "AND CAST(bd.BookingDate AS DATETIME) + CAST(fs.EndTime AS DATETIME) < GETDATE()";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                return ps.executeUpdate();
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
        } finally {
            DBContext.close(conn, ps, null);
        }
        return 0;
    }

    public BigDecimal getDailyRevenue() {
        String sql = "SELECT ISNULL(SUM(TotalPrice), 0) FROM Bookings "
                   + "WHERE CAST(CreatedAt AS DATE) = CAST(GETDATE() AS DATE) "
                   + "AND Status IN ('CONFIRMED', 'COMPLETED')";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getBigDecimal(1);
        } catch (Exception e) { LOGGER.log(Level.SEVERE, e.getMessage(), e); }
        return BigDecimal.ZERO;
    }

    public BigDecimal getWeeklyRevenue() {
        String sql = "SELECT ISNULL(SUM(TotalPrice), 0) FROM Bookings "
                   + "WHERE CreatedAt >= DATEADD(day, -7, GETDATE()) "
                   + "AND Status IN ('CONFIRMED', 'COMPLETED')";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getBigDecimal(1);
        } catch (Exception e) { LOGGER.log(Level.SEVERE, e.getMessage(), e); }
        return BigDecimal.ZERO;
    }
}
