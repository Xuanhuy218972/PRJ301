package com.sportfield.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Model class for Fields table
 * @author hxhbang
 */
public class SportField {
    private int fieldID;
    private Integer ownerID;
    private String fieldName;
    private int fieldType;
    private BigDecimal pricePerHour;
    private String imageURL;
    private String status; // ACTIVE, MAINTENANCE, HIDDEN
    private LocalDateTime createdAt;

    public SportField() {
    }

    public SportField(int fieldID, Integer ownerID, String fieldName, int fieldType, BigDecimal pricePerHour, 
                      String imageURL, String status, LocalDateTime createdAt) {
        this.fieldID = fieldID;
        this.ownerID = ownerID;
        this.fieldName = fieldName;
        this.fieldType = fieldType;
        this.pricePerHour = pricePerHour;
        this.imageURL = imageURL;
        this.status = status;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getFieldID() {
        return fieldID;
    }

    public void setFieldID(int fieldID) {
        this.fieldID = fieldID;
    }

    public Integer getOwnerID() {
        return ownerID;
    }

    public void setOwnerID(Integer ownerID) {
        this.ownerID = ownerID;
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

    public BigDecimal getPricePerHour() {
        return pricePerHour;
    }

    public void setPricePerHour(BigDecimal pricePerHour) {
        this.pricePerHour = pricePerHour;
    }

    public String getImageURL() {
        return imageURL;
    }

    public void setImageURL(String imageURL) {
        this.imageURL = imageURL;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "SportField{" +
                "fieldID=" + fieldID +
                ", ownerID=" + ownerID +
                ", fieldName='" + fieldName + '\'' +
                ", fieldType=" + fieldType +
                ", pricePerHour=" + pricePerHour +
                ", status='" + status + '\'' +
                '}';
    }
}
