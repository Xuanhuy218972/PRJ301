package com.sportfield.utils;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

public class TestDB {
    public static void main(String[] args) {
        try (Connection conn = DBContext.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT TOP 5 BookingID, TotalPrice, Deposit, Status, PaymentMethod, PaymentStatus, PaidAmount FROM Bookings ORDER BY BookingID DESC")) {
            while (rs.next()) {
                System.out.printf("BK%d: Total=%s, Dep=%s, Status=%s, PayMethod=%s, PayStatus=%s, Paid=%s\n",
                    rs.getInt(1), rs.getBigDecimal(2), rs.getBigDecimal(3), rs.getString(4), rs.getString(5), rs.getString(6), rs.getBigDecimal(7));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
