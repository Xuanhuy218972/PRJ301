package com.sportfield.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Model class for Bookings table
 * @author hxhbang
 */
public class Booking {
    private int bookingID;
    private int customerID;
    private String bookingType; // RETAIL, EVENT
    private BigDecimal totalPrice;
    private BigDecimal deposit;
    private String status; // PENDING, CONFIRMED, COMPLETED, CANCELLED
    private String note;
    private LocalDateTime createdAt;

    private String customerName;
    private String customerPhone;

    public Booking() {
    }

    public Booking(int bookingID, int customerID, String bookingType, BigDecimal totalPrice, 
                   BigDecimal deposit, String status, String note, LocalDateTime createdAt) {
        this.bookingID = bookingID;
        this.customerID = customerID;
        this.bookingType = bookingType;
        this.totalPrice = totalPrice;
        this.deposit = deposit;
        this.status = status;
        this.note = note;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getBookingID() {
        return bookingID;
    }

    public void setBookingID(int bookingID) {
        this.bookingID = bookingID;
    }

    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public String getBookingType() {
        return bookingType;
    }

    public void setBookingType(String bookingType) {
        this.bookingType = bookingType;
    }

    public BigDecimal getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }

    public BigDecimal getDeposit() {
        return deposit;
    }

    public void setDeposit(BigDecimal deposit) {
        this.deposit = deposit;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerPhone() {
        return customerPhone;
    }

    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }

    @Override
    public String toString() {
        return "Booking{" +
                "bookingID=" + bookingID +
                ", customerID=" + customerID +
                ", bookingType='" + bookingType + '\'' +
                ", totalPrice=" + totalPrice +
                ", deposit=" + deposit +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
