package com.sportfield.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.DayOfWeek;

import com.sportfield.model.FieldSlot;
import com.sportfield.model.HotSlotDTO;
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

    public List<HotSlotDTO> getHotSlots() {
        List<HotSlotDTO> hotSlots = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        LocalDate today = LocalDate.now();
        LocalDate tomorrow = today.plusDays(1);
        
        // Waterfall query logic to fetch slots that are active and not booked
        String query = 
            "WITH AvailableSlots AS ( " +
            "    SELECT fs.SlotID, fs.FieldID, f.FieldName, f.FieldType, f.ImageURL, " +
            "           fs.StartTime, fs.EndTime, fs.Price, " +
            "           CASE WHEN fs.StartTime >= '16:00:00' AND fs.StartTime < '21:00:00' THEN 1 ELSE 0 END AS IsGoldenHour, " +
            "           d.DateValue " +
            "    FROM FieldSlots fs " +
            "    JOIN Fields f ON fs.FieldID = f.FieldID AND f.Status = 'ACTIVE' " +
            "    CROSS JOIN ( " +
            "        SELECT CAST(GETDATE() AS DATE) AS DateValue " +
            "        UNION ALL SELECT CAST(DATEADD(day, 1, GETDATE()) AS DATE) " +
            "        UNION ALL SELECT CAST(DATEADD(day, 2, GETDATE()) AS DATE) " +
            "        UNION ALL SELECT CAST(DATEADD(day, 3, GETDATE()) AS DATE) " +
            "        UNION ALL SELECT CAST(DATEADD(day, 4, GETDATE()) AS DATE) " +
            "        UNION ALL SELECT CAST(DATEADD(day, 5, GETDATE()) AS DATE) " +
            "        UNION ALL SELECT CAST(DATEADD(day, 6, GETDATE()) AS DATE) " +
            "        UNION ALL SELECT CAST(DATEADD(day, 7, GETDATE()) AS DATE) " +
            "    ) d " +
            "    WHERE fs.Status = 'ACTIVE' AND NOT EXISTS ( " +
            "        SELECT 1 FROM BookingDetails bd " +
            "        JOIN Bookings b ON bd.BookingID = b.BookingID " +
            "        WHERE bd.SlotID = fs.SlotID AND bd.BookingDate = d.DateValue " +
            "        AND b.Status IN ('PENDING', 'CONFIRMED', 'COMPLETED') " +
            "    ) " +
            "), " +
            "RankedSlots AS ( " +
            "    SELECT *, " +
            "    CASE " +
            "        WHEN IsGoldenHour = 1 AND DateValue <= CAST(DATEADD(day, 1, GETDATE()) AS DATE) THEN 1 " +
            "        WHEN IsGoldenHour = 1 AND DateValue > CAST(DATEADD(day, 1, GETDATE()) AS DATE) AND DateValue <= CAST(DATEADD(day, 7, GETDATE()) AS DATE) THEN 2 " +
            "        WHEN IsGoldenHour = 0 AND DateValue <= CAST(DATEADD(day, 1, GETDATE()) AS DATE) THEN 3 " +
            "        ELSE 4 " +
            "    END AS PriorityTier " +
            "    FROM AvailableSlots " +
            ") " +
            "SELECT TOP 6 * FROM RankedSlots " +
            "WHERE PriorityTier <= 3 " +
            "ORDER BY PriorityTier ASC, DateValue ASC, StartTime ASC";

        try {
            conn = DBContext.getConnection();
            if (conn != null) {
                ps = conn.prepareStatement(query);
                rs = ps.executeQuery();

                while (rs.next()) {
                    HotSlotDTO slot = new HotSlotDTO();
                    slot.setSlotID(rs.getInt("SlotID"));
                    slot.setFieldID(rs.getInt("FieldID"));
                    slot.setFieldName(rs.getString("FieldName"));
                    slot.setFieldType(rs.getInt("FieldType"));
                    slot.setStartTime(rs.getTime("StartTime").toLocalTime());
                    slot.setEndTime(rs.getTime("EndTime").toLocalTime());
                    slot.setPrice(rs.getBigDecimal("Price"));
                    slot.setIsGoldenHour(rs.getInt("IsGoldenHour") == 1);
                    slot.setImageURL(rs.getString("ImageURL"));
                    
                    java.sql.Date sqlDate = rs.getDate("DateValue");
                    LocalDate date = sqlDate.toLocalDate();
                    slot.setDate(date);
                    
                    boolean isToday = date.equals(today);
                    boolean isTomorrow = date.equals(tomorrow);
                    
                    slot.setIsToday(isToday);
                    slot.setIsTomorrow(isTomorrow);
                    
                    // Logic display date
                    if (isToday) {
                        slot.setDisplayDate("Hôm nay");
                    } else if (isTomorrow) {
                        slot.setDisplayDate("Ngày mai");
                    } else {
                        // format Thứ 6 (15/03)
                        String dayOfWeek = getVietnameseDayOfWeek(date.getDayOfWeek());
                        String md = date.format(DateTimeFormatter.ofPattern("dd/MM"));
                        slot.setDisplayDate(dayOfWeek + " (" + md + ")");
                    }

                    hotSlots.add(slot);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            DBContext.close(conn, ps, rs);
        }

        return hotSlots;
    }

    private String getVietnameseDayOfWeek(DayOfWeek dow) {
        switch (dow) {
            case MONDAY: return "Thứ 2";
            case TUESDAY: return "Thứ 3";
            case WEDNESDAY: return "Thứ 4";
            case THURSDAY: return "Thứ 5";
            case FRIDAY: return "Thứ 6";
            case SATURDAY: return "Thứ 7";
            case SUNDAY: return "CN";
            default: return "";
        }
    }
}
