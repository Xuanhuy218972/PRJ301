package com.sportfield.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

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
                    user.setFullName(rs.getString("FullName"));
                    user.setEmail(rs.getString("Email"));
                    user.setPhone(rs.getString("Phone"));
                    user.setRole(rs.getString("Role"));
                    user.setWalletBalance(rs.getDouble("WalletBalance"));
                    user.setAvatar(rs.getString("Avatar"));
                    user.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    user.setAddress(rs.getString("Address"));
                    user.setGender(rs.getString("Gender"));
                    user.setDateOfBirth(rs.getString("DateOfBirth"));
                    return user;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return null;
    }

    public boolean register(User user) {
        String sql = "INSERT INTO Users (Username, Password, FullName, Email, Phone, Role, WalletBalance, CreatedAt, Address, Gender, DateOfBirth) "
                   + "VALUES (?, ?, ?, ?, ?, 'CUSTOMER', 0, GETDATE(), ?, ?, ?)";
        
        Connection conn = null;
        PreparedStatement ps = null;
        
        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setString(1, user.getUsername());
                ps.setString(2, user.getPassword());
                ps.setString(3, user.getFullName());
                ps.setString(4, user.getEmail());
                ps.setString(5, user.getPhone());
                ps.setString(6, user.getAddress());
                ps.setString(7, user.getGender());
                ps.setString(8, user.getDateOfBirth());
                
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

    public boolean checkUserExist(String username, String email) {
        String sql = "SELECT UserID FROM Users WHERE Username = ? OR Email = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<User> getAll() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM Users ORDER BY CreatedAt DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                rs = ps.executeQuery();

                while (rs.next()) {
                    User user = new User();
                    user.setUserID(rs.getInt("UserID"));
                    user.setUsername(rs.getString("Username"));
                    user.setPassword(rs.getString("Password"));
                    user.setFullName(rs.getString("FullName"));
                    user.setEmail(rs.getString("Email"));
                    user.setPhone(rs.getString("Phone"));
                    user.setRole(rs.getString("Role"));
                    user.setWalletBalance(rs.getDouble("WalletBalance"));
                    user.setAvatar(rs.getString("Avatar"));
                    user.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    user.setAddress(rs.getString("Address"));
                    user.setGender(rs.getString("Gender"));
                    user.setDateOfBirth(rs.getString("DateOfBirth"));
                    users.add(user);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return users;
    }
}
