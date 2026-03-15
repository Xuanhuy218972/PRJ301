package com.sportfield.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.sportfield.model.ContactMessage;
import com.sportfield.utils.DBContext;

public class ContactDAO {

    private static final Logger LOGGER = Logger.getLogger(ContactDAO.class.getName());

    public boolean saveContactMessage(ContactMessage contact) {
        String sql = "INSERT INTO ContactMessages (FullName, Email, Phone, Subject, Message, CreatedAt, Status) "
                   + "VALUES (?, ?, ?, ?, ?, GETDATE(), ?)";
        
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, contact.getFullName());
            ps.setString(2, contact.getEmail());
            ps.setString(3, contact.getPhone());
            ps.setString(4, contact.getSubject());
            ps.setString(5, contact.getMessage());
            ps.setString(6, contact.getStatus());

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
            return false;
        } finally {
            DBContext.close(conn, ps, null);
        }
    }

    public List<ContactMessage> getAllContactMessages() {
        return getContactMessagesByStatus(null);
    }

    public List<ContactMessage> getContactMessagesByStatus(String status) {
        List<ContactMessage> messages = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM ContactMessages");
        if (status != null && !status.isEmpty()) {
            sql.append(" WHERE Status = ?");
        }
        sql.append(" ORDER BY CreatedAt DESC");
        
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql.toString());
            if (status != null && !status.isEmpty()) {
                ps.setString(1, status);
            }
            rs = ps.executeQuery();

            while (rs.next()) {
                ContactMessage msg = new ContactMessage();
                msg.setContactID(rs.getInt("ContactID"));
                msg.setFullName(rs.getString("FullName"));
                msg.setEmail(rs.getString("Email"));
                msg.setPhone(rs.getString("Phone"));
                msg.setSubject(rs.getString("Subject"));
                msg.setMessage(rs.getString("Message"));
                
                Timestamp timestamp = rs.getTimestamp("CreatedAt");
                if (timestamp != null) {
                    msg.setCreatedAt(timestamp.toLocalDateTime());
                }
                
                msg.setStatus(rs.getString("Status"));
                messages.add(msg);
            }

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, e.getMessage(), e);
        } finally {
            DBContext.close(conn, ps, rs);
        }

        return messages;
    }

    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM ContactMessages WHERE Status = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "countByStatus error: " + e.getMessage(), e);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return 0;
    }

    public boolean updateContactStatus(int contactID, String status) {
        String sql = "UPDATE ContactMessages SET Status = ? WHERE ContactID = ?";
        
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, contactID);

            ps.executeUpdate();
            return true;

        } catch (SQLException | ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "updateContactStatus error: " + e.getMessage(), e);
            return false;
        } finally {
            DBContext.close(conn, ps, null);
        }
    }
}
