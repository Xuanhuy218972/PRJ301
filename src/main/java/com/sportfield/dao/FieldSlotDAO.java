package com.sportfield.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

import com.sportfield.model.FieldSlot;
import com.sportfield.utils.DBContext;

public class FieldSlotDAO {

    public List<FieldSlot> getByFieldID(int fieldID) {
        List<FieldSlot> slots = new ArrayList<>();
        String sql = "SELECT * FROM FieldSlots WHERE FieldID = ? ORDER BY StartTime";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setInt(1, fieldID);
                rs = ps.executeQuery();

                while (rs.next()) {
                    FieldSlot slot = new FieldSlot();
                    slot.setSlotID(rs.getInt("SlotID"));
                    slot.setFieldID(rs.getInt("FieldID"));
                    slot.setStartTime(rs.getTime("StartTime").toLocalTime());
                    slot.setEndTime(rs.getTime("EndTime").toLocalTime());
                    slot.setPrice(rs.getBigDecimal("Price"));
                    slot.setStatus(rs.getString("Status"));
                    slots.add(slot);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return slots;
    }

    public FieldSlot getByID(int slotID) {
        String sql = "SELECT * FROM FieldSlots WHERE SlotID = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setInt(1, slotID);
                rs = ps.executeQuery();

                if (rs.next()) {
                    FieldSlot slot = new FieldSlot();
                    slot.setSlotID(rs.getInt("SlotID"));
                    slot.setFieldID(rs.getInt("FieldID"));
                    slot.setStartTime(rs.getTime("StartTime").toLocalTime());
                    slot.setEndTime(rs.getTime("EndTime").toLocalTime());
                    slot.setPrice(rs.getBigDecimal("Price"));
                    slot.setStatus(rs.getString("Status"));
                    return slot;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }
        return null;
    }

    public boolean insert(FieldSlot slot) {
        String sql = "INSERT INTO FieldSlots (FieldID, StartTime, EndTime, Price, Status) VALUES (?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setInt(1, slot.getFieldID());
                ps.setTime(2, Time.valueOf(slot.getStartTime()));
                ps.setTime(3, Time.valueOf(slot.getEndTime()));
                ps.setBigDecimal(4, slot.getPrice());
                ps.setString(5, slot.getStatus());

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

    public boolean update(FieldSlot slot) {
        String sql = "UPDATE FieldSlots SET StartTime = ?, EndTime = ?, Price = ?, Status = ? WHERE SlotID = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setTime(1, Time.valueOf(slot.getStartTime()));
                ps.setTime(2, Time.valueOf(slot.getEndTime()));
                ps.setBigDecimal(3, slot.getPrice());
                ps.setString(4, slot.getStatus());
                ps.setInt(5, slot.getSlotID());

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

    public boolean delete(int slotID) {
        String sql = "DELETE FROM FieldSlots WHERE SlotID = ?";
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(sql);
                ps.setInt(1, slotID);

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

    public boolean deleteByFieldID(int fieldID) {
        String sql = "DELETE FROM FieldSlots WHERE FieldID = ?";
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
}
