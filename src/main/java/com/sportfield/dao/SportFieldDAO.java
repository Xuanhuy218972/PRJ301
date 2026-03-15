package com.sportfield.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.sportfield.model.SportField;
import com.sportfield.utils.DBContext;

public class SportFieldDAO {

    private static final Logger LOGGER = Logger.getLogger(SportFieldDAO.class.getName());

    public List<SportField> getAll() {
        List<SportField> fields = new ArrayList<>();
        String sql = "SELECT * FROM Fields ORDER BY CreatedAt DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                rs = ps.executeQuery();
                while (rs.next()) {
                    fields.add(mapField(rs));
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "[SportFieldDAO] getAll error", e);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return fields;
    }

    public List<SportField> getActiveFields() {
        List<SportField> fields = new ArrayList<>();
        String sql = "SELECT * FROM Fields WHERE Status = 'ACTIVE' ORDER BY CreatedAt DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                rs = ps.executeQuery();
                while (rs.next()) {
                    fields.add(mapField(rs));
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "[SportFieldDAO] getActiveFields error", e);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return fields;
    }

    public List<SportField> getActiveFieldsByType(int fieldType) {
        List<SportField> fields = new ArrayList<>();
        String sql = "SELECT * FROM Fields WHERE Status = 'ACTIVE' AND FieldType = ? ORDER BY CreatedAt DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setInt(1, fieldType);
                rs = ps.executeQuery();
                while (rs.next()) {
                    fields.add(mapField(rs));
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "[SportFieldDAO] getActiveFieldsByType error", e);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return fields;
    }

    public SportField getByID(int fieldID) {
        String sql = "SELECT * FROM Fields WHERE FieldID = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setInt(1, fieldID);
                rs = ps.executeQuery();
                if (rs.next()) {
                    return mapField(rs);
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "[SportFieldDAO] getByID error", e);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return null;
    }

    public boolean insert(SportField field) {
        String sql = "INSERT INTO Fields (OwnerID, FieldName, FieldType, PricePerHour, ImageURL, Status, CreatedAt) VALUES (?, ?, ?, ?, ?, ?, GETDATE())";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                if (field.getOwnerID() != null) {
                    ps.setInt(1, field.getOwnerID());
                } else {
                    ps.setNull(1, Types.INTEGER);
                }
                ps.setString(2, field.getFieldName());
                ps.setInt(3, field.getFieldType());
                ps.setBigDecimal(4, field.getPricePerHour());
                ps.setString(5, field.getImageURL());
                ps.setString(6, field.getStatus());
                int rows = ps.executeUpdate();
                return rows > 0;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "[SportFieldDAO] insert error", e);
        } finally {
            DBContext.close(conn, ps, null);
        }
        return false;
    }

    public boolean update(SportField field) {
        String sql = "UPDATE Fields SET OwnerID = ?, FieldName = ?, FieldType = ?, PricePerHour = ?, ImageURL = ?, Status = ? WHERE FieldID = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                if (field.getOwnerID() != null) {
                    ps.setInt(1, field.getOwnerID());
                } else {
                    ps.setNull(1, Types.INTEGER);
                }
                ps.setString(2, field.getFieldName());
                ps.setInt(3, field.getFieldType());
                ps.setBigDecimal(4, field.getPricePerHour());
                ps.setString(5, field.getImageURL());
                ps.setString(6, field.getStatus());
                ps.setInt(7, field.getFieldID());
                int rows = ps.executeUpdate();
                return rows > 0;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "[SportFieldDAO] update error", e);
        } finally {
            DBContext.close(conn, ps, null);
        }
        return false;
    }

    public boolean delete(int fieldID) {
        String sql = "DELETE FROM Fields WHERE FieldID = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setInt(1, fieldID);
                int rows = ps.executeUpdate();
                return rows > 0;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "[SportFieldDAO] delete error", e);
        } finally {
            DBContext.close(conn, ps, null);
        }
        return false;
    }

    public List<SportField> getFieldsByOwner(int ownerID) {
        List<SportField> fields = new ArrayList<>();
        String sql = "SELECT * FROM Fields WHERE OwnerID = ? ORDER BY CreatedAt DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setInt(1, ownerID);
                rs = ps.executeQuery();
                while (rs.next()) {
                    fields.add(mapField(rs));
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "[SportFieldDAO] getFieldsByOwner error", e);
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return fields;
    }

    public boolean updateStatus(int fieldID, String status) {
        String sql = "UPDATE Fields SET Status = ? WHERE FieldID = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setString(1, status);
                ps.setInt(2, fieldID);
                int rows = ps.executeUpdate();
                return rows > 0;
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "[SportFieldDAO] updateStatus error", e);
        } finally {
            DBContext.close(conn, ps, null);
        }
        return false;
    }

    private SportField mapField(ResultSet rs) throws Exception {
        SportField field = new SportField();
        field.setFieldID(rs.getInt("FieldID"));
        
        Object ownerIdObj = rs.getObject("OwnerID");
        if (ownerIdObj != null) {
            field.setOwnerID(((Number) ownerIdObj).intValue());
        }
        
        field.setFieldName(rs.getString("FieldName"));
        field.setFieldType(rs.getInt("FieldType"));
        field.setPricePerHour(rs.getBigDecimal("PricePerHour"));
        field.setImageURL(rs.getString("ImageURL"));
        field.setStatus(rs.getString("Status"));
        java.sql.Timestamp timestamp = rs.getTimestamp("CreatedAt");
        if (timestamp != null) {
            field.setCreatedAt(timestamp.toLocalDateTime());
        }
        return field;
    }
}
