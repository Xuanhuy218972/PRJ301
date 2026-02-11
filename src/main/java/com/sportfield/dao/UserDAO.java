/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.sportfield.dao;

/**
 *
 * @author hxhbang
 */
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.sportfield.model.User;
import com.sportfield.utils.DBContext;

public class UserDAO {

    public User login(String username, String password) {
        String sql = "SELECT * FROM Users WHERE Username = ? AND Password = ?";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setString(1, username);
                ps.setString(2, password);

                rs = ps.executeQuery();

                if (rs.next()) {
                    User user = new User();

                    user.setUserID(rs.getInt("UserID"));
                    user.setUsername(rs.getString("Username"));
                    user.setPassword(rs.getString("Password"));
                    user.setRole(rs.getString("Role"));
                    user.setEmail(rs.getString("Email"));
                    user.setPhone(rs.getString("Phone"));
                    user.setAddress(rs.getString("Address"));
                    user.setDistrict(rs.getString("District"));
                    user.setAvatar(rs.getString("Avatar"));

                    user.setFullName(rs.getString("FullName"));
                    user.setBusinessName(rs.getString("BusinessName"));
                    user.setBusinessLicense(rs.getString("BusinessLicense"));
                    user.setShopImage(rs.getString("ShopImage"));
                    user.setWalletBalance(rs.getDouble("WalletBalance"));
                    user.setVerified(rs.getBoolean("Verified"));

                    user.setCreatedAt(rs.getTimestamp("CreatedAt"));

                    return user;
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Login Error: " + e.getMessage());
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return null;
    }
    
    public boolean checkUserExist(String username, String email) {
        String sql = "SELECT UserID FROM Users WHERE Username = ? OR Email = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setString(1, username);
                ps.setString(2, email);
                rs = ps.executeQuery();
                if (rs.next()) {
                    return true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return false;
    }
    
    public boolean register(User user) {
        String sql = "INSERT INTO Users (Username, Password, Email, Phone, FullName, Role, WalletBalance, Verified, CreatedAt) "
                   + "VALUES (?, ?, ?, ?, ?, 'CUSTOMER', 0, 1, GETDATE())";
        
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setString(1, user.getUsername());
                ps.setString(2, user.getPassword());
                ps.setString(3, user.getEmail());
                ps.setString(4, user.getPhone());
                ps.setString(5, user.getFullName());
                
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
