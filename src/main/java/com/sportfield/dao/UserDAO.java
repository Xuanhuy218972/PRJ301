package com.sportfield.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.sportfield.model.User;
import com.sportfield.utils.DBContext;

public class UserDAO {

    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());

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
                    return mapUser(rs);
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "[UserDAO] login error", e);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return null;
    }

    public boolean register(User user) {
        String sql = "INSERT INTO Users (Username, Password, FullName, Email, Phone, Role, WalletBalance, Avatar, CreatedAt, Address, Gender, DateOfBirth) "
                   + "VALUES (?, ?, ?, ?, ?, 'CUSTOMER', 0, ?, GETDATE(), ?, ?, ?)";
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
                ps.setString(6, user.getAvatar());
                ps.setString(7, user.getAddress());
                ps.setString(8, user.getGender());
                ps.setString(9, user.getDateOfBirth());
                int rows = ps.executeUpdate();
                return rows > 0;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "[UserDAO] register error", e);
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
            LOGGER.log(Level.SEVERE, "[UserDAO] checkUserExist error", e);
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
                    users.add(mapUser(rs));
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "[UserDAO] getAll error", e);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return users;
    }

    public List<User> getUsersByRole(String role) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE Role = ? ORDER BY CreatedAt DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setString(1, role);
                rs = ps.executeQuery();
                while (rs.next()) {
                    users.add(mapUser(rs));
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "[UserDAO] getUsersByRole error", e);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return users;
    }

    public List<User> getNewCustomers(int month, int year) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE Role = 'CUSTOMER' AND MONTH(CreatedAt) = ? AND YEAR(CreatedAt) = ? ORDER BY CreatedAt DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setInt(1, month);
                ps.setInt(2, year);
                rs = ps.executeQuery();
                while (rs.next()) {
                    users.add(mapUser(rs));
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "[UserDAO] getNewCustomers error", e);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return users;
    }

    public List<User> getUsersByFilters(String role, String type, int month, int year, String name) {
        List<User> users = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Users WHERE 1=1 ");

        if ("new_customers".equals(type)) {
            sql.append("AND Role = 'CUSTOMER' AND MONTH(CreatedAt) = ? AND YEAR(CreatedAt) = ? ");
        } else if (role != null && !role.trim().isEmpty() && !"ALL".equalsIgnoreCase(role)) {
            sql.append("AND Role = ? ");
        }

        if (name != null && !name.trim().isEmpty()) {
            sql.append("AND (FullName LIKE ? OR Username LIKE ?) ");
        }

        sql.append("ORDER BY CreatedAt DESC");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql.toString());
                int paramIndex = 1;

                if ("new_customers".equals(type)) {
                    ps.setInt(paramIndex++, month);
                    ps.setInt(paramIndex++, year);
                } else if (role != null && !role.trim().isEmpty() && !"ALL".equalsIgnoreCase(role)) {
                    ps.setString(paramIndex++, role);
                }

                if (name != null && !name.trim().isEmpty()) {
                    ps.setString(paramIndex++, "%" + name.trim() + "%");
                    ps.setString(paramIndex++, "%" + name.trim() + "%");
                }

                rs = ps.executeQuery();
                while (rs.next()) {
                    users.add(mapUser(rs));
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "[UserDAO] getUsersByFilters error", e);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return users;
    }

    public boolean update(User user) {
        String sql = "UPDATE Users SET FullName = ?, Email = ?, Phone = ?, Address = ?, Gender = ?, DateOfBirth = ?, Avatar = ? WHERE UserID = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setString(1, user.getFullName());
                ps.setString(2, user.getEmail());
                ps.setString(3, user.getPhone());
                ps.setString(4, user.getAddress());
                ps.setString(5, user.getGender());
                ps.setString(6, user.getDateOfBirth());
                ps.setString(7, user.getAvatar());
                ps.setInt(8, user.getUserID());
                int rows = ps.executeUpdate();
                return rows > 0;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "[UserDAO] update error", e);
        } finally {
            DBContext.close(conn, ps, null);
        }
        return false;
    }

    public boolean delete(int userID) {
        String sql = "DELETE FROM Users WHERE UserID = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setInt(1, userID);
                int rows = ps.executeUpdate();
                return rows > 0;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "[UserDAO] delete error", e);
        } finally {
            DBContext.close(conn, ps, null);
        }
        return false;
    }

    public boolean changeRole(int userID, String newRole) {
        String sql = "UPDATE Users SET Role = ? WHERE UserID = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setString(1, newRole);
                ps.setInt(2, userID);
                int rows = ps.executeUpdate();
                return rows > 0;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "[UserDAO] changeRole error", e);
        } finally {
            DBContext.close(conn, ps, null);
        }
        return false;
    }

    public User getUserByID(int userID) {
        String sql = "SELECT * FROM Users WHERE UserID = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setInt(1, userID);
                rs = ps.executeQuery();
                if (rs.next()) {
                    return mapUser(rs);
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "[UserDAO] getUserByID error", e);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return null;
    }

    public boolean updatePassword(int userID, String hashedPassword) {
        String sql = "UPDATE Users SET Password = ? WHERE UserID = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setString(1, hashedPassword);
                ps.setInt(2, userID);
                int rows = ps.executeUpdate();
                return rows > 0;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "[UserDAO] updatePassword error", e);
        } finally {
            DBContext.close(conn, ps, null);
        }
        return false;
    }

    public User getUserByUsernameAndEmail(String username, String email) {
        String sql = "SELECT * FROM Users WHERE Username = ? AND Email = ?";
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
                    return mapUser(rs);
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "[UserDAO] getUserByUsernameAndEmail error", e);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return null;
    }

    private User mapUser(ResultSet rs) throws Exception {
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
