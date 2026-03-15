package com.sportfield.model;

import java.math.BigDecimal;

public class SlotResult {

    private int fieldID;
    private int slotID;
    private String fieldName;
    private int fieldType;
    private String startTime;    // "HH:mm"
    private String endTime;      // "HH:mm"
    private BigDecimal price;
    private String bookingDate;  // "yyyy-MM-dd"

    public SlotResult() {}

    public SlotResult(int fieldID, int slotID, String fieldName, int fieldType,
                      String startTime, String endTime, BigDecimal price, String bookingDate) {
        this.fieldID = fieldID;
        this.slotID = slotID;
        this.fieldName = fieldName;
        this.fieldType = fieldType;
        this.startTime = startTime;
        this.endTime = endTime;
        this.price = price;
        this.bookingDate = bookingDate;
    }

    public int getFieldID() { return fieldID; }
    public void setFieldID(int fieldID) { this.fieldID = fieldID; }

    public int getSlotID() { return slotID; }
    public void setSlotID(int slotID) { this.slotID = slotID; }

    public String getFieldName() { return fieldName; }
    public void setFieldName(String fieldName) { this.fieldName = fieldName; }

    public int getFieldType() { return fieldType; }
    public void setFieldType(int fieldType) { this.fieldType = fieldType; }

    public String getStartTime() { return startTime; }
    public void setStartTime(String startTime) { this.startTime = startTime; }

    public String getEndTime() { return endTime; }
    public void setEndTime(String endTime) { this.endTime = endTime; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public String getBookingDate() { return bookingDate; }
    public void setBookingDate(String bookingDate) { this.bookingDate = bookingDate; }
}
