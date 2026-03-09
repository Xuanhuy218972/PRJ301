package com.sportfield.model;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;

/**
 * DTO for displaying hot slots on the homepage
 */
public class HotSlotDTO {
    private int slotID;
    private int fieldID;
    private String fieldName;
    private int fieldType;
    private LocalTime startTime;
    private LocalTime endTime;
    private LocalDate date;
    private String displayDate;
    private BigDecimal price;
    private boolean isGoldenHour;
    private boolean isToday;
    private boolean isTomorrow;
    private String imageURL;

    public HotSlotDTO() {
    }

    public HotSlotDTO(int slotID, int fieldID, String fieldName, int fieldType, 
            LocalTime startTime, LocalTime endTime, LocalDate date, String displayDate, 
            BigDecimal price, boolean isGoldenHour, boolean isToday, boolean isTomorrow, String imageURL) {
        this.slotID = slotID;
        this.fieldID = fieldID;
        this.fieldName = fieldName;
        this.fieldType = fieldType;
        this.startTime = startTime;
        this.endTime = endTime;
        this.date = date;
        this.displayDate = displayDate;
        this.price = price;
        this.isGoldenHour = isGoldenHour;
        this.isToday = isToday;
        this.isTomorrow = isTomorrow;
        this.imageURL = imageURL;
    }

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

    public String getFieldName() {
        return fieldName;
    }

    public void setFieldName(String fieldName) {
        this.fieldName = fieldName;
    }

    public int getFieldType() {
        return fieldType;
    }

    public void setFieldType(int fieldType) {
        this.fieldType = fieldType;
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

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public String getDisplayDate() {
        return displayDate;
    }

    public void setDisplayDate(String displayDate) {
        this.displayDate = displayDate;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public boolean isIsGoldenHour() {
        return isGoldenHour;
    }

    public void setIsGoldenHour(boolean isGoldenHour) {
        this.isGoldenHour = isGoldenHour;
    }

    public boolean isIsToday() {
        return isToday;
    }

    public void setIsToday(boolean isToday) {
        this.isToday = isToday;
    }

    public boolean isIsTomorrow() {
        return isTomorrow;
    }

    public void setIsTomorrow(boolean isTomorrow) {
        this.isTomorrow = isTomorrow;
    }

    public String getImageURL() {
        return imageURL;
    }

    public void setImageURL(String imageURL) {
        this.imageURL = imageURL;
    }

    @Override
    public String toString() {
        return "HotSlotDTO{" + "slotID=" + slotID + ", fieldID=" + fieldID + ", fieldName=" + fieldName + ", fieldType=" + fieldType + ", startTime=" + startTime + ", endTime=" + endTime + ", date=" + date + ", displayDate=" + displayDate + ", price=" + price + ", isGoldenHour=" + isGoldenHour + ", isToday=" + isToday + ", isTomorrow=" + isTomorrow + ", imageURL=" + imageURL + '}';
    }
}
