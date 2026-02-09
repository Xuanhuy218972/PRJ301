/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.sportfield.utils;

/**
 *
 * @author hxhbang
 */
import java.sql.Connection;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class DBContextTest {

    @Test
    public void testConnection() {
        System.out.println("Running Test: Check DB Connection...");

        try {
            Connection conn = DBContext.getConnection();

            assertNotNull(conn, "Connection failed: Connection object is null.");

            assertFalse(conn.isClosed(), "Connection failed: Connection closed unexpectedly.");

            System.out.println(">> Test Passed: Connection established successfully.");

            DBContext.close(conn, null, null);

        } catch (Exception e) {
            fail("Test Failed due to exception: " + e.getMessage());
        }
    }
}
