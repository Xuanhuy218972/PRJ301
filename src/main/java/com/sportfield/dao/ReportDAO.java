package com.sportfield.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.sportfield.utils.DBContext;

public class ReportDAO {

    public BigDecimal getTotalRevenue(String year, String month) {
        String sql = "SELECT ISNULL(SUM(TotalPrice), 0) FROM Bookings "
                   + "WHERE Status IN ('CONFIRMED', 'COMPLETED') "
                   + "AND YEAR(CreatedAt) = ? AND MONTH(CreatedAt) = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(year));
                ps.setInt(2, Integer.parseInt(month));
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

    public BigDecimal getTotalRevenueByYear(String year) {
        String sql = "SELECT ISNULL(SUM(TotalPrice), 0) FROM Bookings "
                   + "WHERE Status IN ('CONFIRMED', 'COMPLETED') "
                   + "AND YEAR(CreatedAt) = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(year));
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

    public Map<Integer, BigDecimal> getMonthlyRevenueByYear(String year) {
        Map<Integer, BigDecimal> monthlyRevenue = new LinkedHashMap<>();
        for (int i = 1; i <= 12; i++) {
            monthlyRevenue.put(i, BigDecimal.ZERO);
        }

        String sql = "SELECT MONTH(CreatedAt) AS M, ISNULL(SUM(TotalPrice), 0) AS Revenue "
                   + "FROM Bookings WHERE Status IN ('CONFIRMED', 'COMPLETED') "
                   + "AND YEAR(CreatedAt) = ? GROUP BY MONTH(CreatedAt) ORDER BY M";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(year));
                rs = ps.executeQuery();
                while (rs.next()) {
                    monthlyRevenue.put(rs.getInt("M"), rs.getBigDecimal("Revenue"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return monthlyRevenue;
    }

    public int getTotalBookingsByMonth(String year, String month) {
        String sql = "SELECT COUNT(*) FROM Bookings WHERE YEAR(CreatedAt) = ? AND MONTH(CreatedAt) = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(year));
                ps.setInt(2, Integer.parseInt(month));
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

    public int getCompletedBookingsByMonth(String year, String month) {
        String sql = "SELECT COUNT(*) FROM Bookings WHERE YEAR(CreatedAt) = ? AND MONTH(CreatedAt) = ? "
                   + "AND Status IN ('CONFIRMED', 'COMPLETED')";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(year));
                ps.setInt(2, Integer.parseInt(month));
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

    public int getCancelledBookingsByMonth(String year, String month) {
        String sql = "SELECT COUNT(*) FROM Bookings WHERE YEAR(CreatedAt) = ? AND MONTH(CreatedAt) = ? "
                   + "AND Status = 'CANCELLED'";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(year));
                ps.setInt(2, Integer.parseInt(month));
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

    public List<Map<String, Object>> getTopFieldsByRevenue(String year, String month) {
        List<Map<String, Object>> result = new ArrayList<>();
        String sql = "SELECT TOP 5 f.FieldName, COUNT(bd.DetailID) AS TotalBookings, "
                   + "ISNULL(SUM(bd.Price), 0) AS TotalRevenue "
                   + "FROM BookingDetails bd "
                   + "JOIN FieldSlots fs ON bd.SlotID = fs.SlotID "
                   + "JOIN Fields f ON fs.FieldID = f.FieldID "
                   + "JOIN Bookings b ON bd.BookingID = b.BookingID "
                   + "WHERE b.Status IN ('CONFIRMED', 'COMPLETED') "
                   + "AND YEAR(b.CreatedAt) = ? AND MONTH(b.CreatedAt) = ? "
                   + "GROUP BY f.FieldName ORDER BY TotalRevenue DESC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(year));
                ps.setInt(2, Integer.parseInt(month));
                rs = ps.executeQuery();
                while (rs.next()) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    row.put("fieldName", rs.getString("FieldName"));
                    row.put("totalBookings", rs.getInt("TotalBookings"));
                    row.put("totalRevenue", rs.getBigDecimal("TotalRevenue"));
                    result.add(row);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return result;
    }

    public List<Integer> getAvailableYears() {
        List<Integer> years = new ArrayList<>();
        String sql = "SELECT DISTINCT YEAR(CreatedAt) AS Y FROM Bookings ORDER BY Y DESC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                rs = ps.executeQuery();
                while (rs.next()) {
                    years.add(rs.getInt("Y"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }

        if (years.isEmpty()) {
            years.add(java.time.LocalDate.now().getYear());
        }
        return years;
    }

    public int getNewCustomersByMonth(String year, String month) {
        String sql = "SELECT COUNT(*) FROM Users WHERE Role = 'CUSTOMER' "
                   + "AND YEAR(CreatedAt) = ? AND MONTH(CreatedAt) = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setInt(1, Integer.parseInt(year));
                ps.setInt(2, Integer.parseInt(month));
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
}
