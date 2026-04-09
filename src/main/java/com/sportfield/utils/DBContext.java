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
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import io.github.cdimascio.dotenv.Dotenv;

public class DBContext {

    private static final Dotenv dotenv;
    static {
        Dotenv d;
        try {
            d = Dotenv.configure().ignoreIfMissing().load();
        } catch (Exception e) {
            d = null;
        }
        dotenv = d;
    }

    private static String getEnv(String key, String defaultValue) {
        // 1. Try system environment variable first (for Docker)
        String val = System.getenv(key);
        if (val != null && !val.isEmpty()) {
            return val;
        }
        // 2. Try dotenv (for local development)
        if (dotenv != null) {
            val = dotenv.get(key);
            if (val != null && !val.isEmpty()) {
                return val;
            }
        }
        // 3. Return default
        return defaultValue;
    }

    private static final String HOST = getEnv("DB_HOST", "localhost");
    private static final String PORT = getEnv("DB_PORT", "5432");
    private static final String DB_NAME = getEnv("DB_NAME", "sportfields");
    private static final String USER = getEnv("DB_USER", "postgres");
    private static final String PASSWORD = getEnv("DB_PASSWORD", "postgres");
    private static final String DB_URL = "jdbc:postgresql://" + HOST + ":" + PORT + "/" + DB_NAME;

    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("org.postgresql.Driver");
        return DriverManager.getConnection(DB_URL, USER, PASSWORD);
    }

    public static void close(Connection conn, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null && !rs.isClosed()) {
                rs.close();
            }
            if (ps != null && !ps.isClosed()) {
                ps.close();
            }
            if (conn != null && !conn.isClosed()) {
                conn.close();
            }
        } catch (SQLException e) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, "[DBContext] close error", e);
        }
    }
}
