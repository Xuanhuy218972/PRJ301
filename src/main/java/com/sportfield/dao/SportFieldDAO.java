package com.sportfield.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.sportfield.model.SportField;
import com.sportfield.utils.DBContext;

public class SportFieldDAO {

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
                    SportField field = new SportField();
                    field.setFieldID(rs.getInt("FieldID"));
                    field.setFieldName(rs.getString("FieldName"));
                    field.setFieldType(rs.getInt("FieldType"));
                    field.setPricePerHour(rs.getBigDecimal("PricePerHour"));
                    field.setImageURL(rs.getString("ImageURL"));
                    field.setStatus(rs.getString("Status"));
                    java.sql.Timestamp timestamp = rs.getTimestamp("CreatedAt");
                    if (timestamp != null) {
                        field.setCreatedAt(timestamp.toLocalDateTime());
                    }
                    fields.add(field);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
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
                    SportField field = new SportField();
                    field.setFieldID(rs.getInt("FieldID"));
                    field.setFieldName(rs.getString("FieldName"));
                    field.setFieldType(rs.getInt("FieldType"));
                    field.setPricePerHour(rs.getBigDecimal("PricePerHour"));
                    field.setImageURL(rs.getString("ImageURL"));
                    field.setStatus(rs.getString("Status"));
                    java.sql.Timestamp timestamp = rs.getTimestamp("CreatedAt");
                    if (timestamp != null) {
                        field.setCreatedAt(timestamp.toLocalDateTime());
                    }
                    fields.add(field);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
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
                    SportField field = new SportField();
                    field.setFieldID(rs.getInt("FieldID"));
                    field.setFieldName(rs.getString("FieldName"));
                    field.setFieldType(rs.getInt("FieldType"));
                    field.setPricePerHour(rs.getBigDecimal("PricePerHour"));
                    field.setImageURL(rs.getString("ImageURL"));
                    field.setStatus(rs.getString("Status"));
                    java.sql.Timestamp timestamp = rs.getTimestamp("CreatedAt");
                    if (timestamp != null) {
                        field.setCreatedAt(timestamp.toLocalDateTime());
                    }
                    fields.add(field);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
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
                    SportField field = new SportField();
                    field.setFieldID(rs.getInt("FieldID"));
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
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return null;
    }

    public boolean insert(SportField field) {
        String sql = "INSERT INTO Fields (FieldName, FieldType, PricePerHour, ImageURL, Status, CreatedAt) VALUES (?, ?, ?, ?, ?, GETDATE())";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setString(1, field.getFieldName());
                ps.setInt(2, field.getFieldType());
                ps.setBigDecimal(3, field.getPricePerHour());
                ps.setString(4, field.getImageURL());
                ps.setString(5, field.getStatus());

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

    public boolean update(SportField field) {
        String sql = "UPDATE Fields SET FieldName = ?, FieldType = ?, PricePerHour = ?, ImageURL = ?, Status = ? WHERE FieldID = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setString(1, field.getFieldName());
                ps.setInt(2, field.getFieldType());
                ps.setBigDecimal(3, field.getPricePerHour());
                ps.setString(4, field.getImageURL());
                ps.setString(5, field.getStatus());
                ps.setInt(6, field.getFieldID());

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
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, null);
        }
        return false;
    }

    public List<SportField> getFieldsByOwner(int ownerID) {
        return getAll();
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
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, null);
        }
        return false;
    }
}
