package com.sportfield.model;

import java.math.BigDecimal;
import java.time.LocalTime;

/**
 * Model class for FieldSlots table
 * @author hxhbang
 */
public class FieldSlot {
    private int slotID;
    private int fieldID;
    private LocalTime startTime;
    private LocalTime endTime;
    private BigDecimal price;
    private String status; // ACTIVE, INACTIVE

    public FieldSlot() {
    }

    public FieldSlot(int slotID, int fieldID, LocalTime startTime, LocalTime endTime, 
                     BigDecimal price, String status) {
        this.slotID = slotID;
        this.fieldID = fieldID;
        this.startTime = startTime;
        this.endTime = endTime;
        this.price = price;
        this.status = status;
    }

    // Getters and Setters
    public int getSlotID() {
        return slotID;
    }

    public void setSlotID(int slotID) {
        this.slotID = slotID;
    }

    public int getFieldID() {
        return fieldID;
    }

    public void setFieldID(int fieldID) {
        this.fieldID = fieldID;
    }

    public LocalTime getStartTime() {
        return startTime;
    }

    public void setStartTime(LocalTime startTime) {
        this.startTime = startTime;
    }

    public LocalTime getEndTime() {
        return endTime;
    }

    public void setEndTime(LocalTime endTime) {
        this.endTime = endTime;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "FieldSlot{" +
                "slotID=" + slotID +
                ", fieldID=" + fieldID +
                ", startTime=" + startTime +
                ", endTime=" + endTime +
                ", price=" + price +
                ", status='" + status + '\'' +
                '}';
    }
}
