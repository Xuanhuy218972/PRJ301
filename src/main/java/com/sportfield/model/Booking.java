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

    // Payment fields
    private String paymentMethod;  // VNPAY, MOMO
    private String paymentStatus;  // UNPAID, DEPOSITED, PAID
    private BigDecimal paidAmount;  // Actual amount paid so far

    private String customerName;
    private String customerPhone;
    private BigDecimal refundAmount;
    private String cancelReason;

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

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public BigDecimal getPaidAmount() {
        return paidAmount;
    }

    public void setPaidAmount(BigDecimal paidAmount) {
        this.paidAmount = paidAmount;
    }

    /**
     * Calculates remaining amount to be collected.
     * totalPrice - paidAmount
     */
    public BigDecimal getRemainingAmount() {
        BigDecimal total = totalPrice != null ? totalPrice : BigDecimal.ZERO;
        BigDecimal paid = paidAmount != null ? paidAmount : BigDecimal.ZERO;
        return total.subtract(paid);
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

    public BigDecimal getRefundAmount() {
        return refundAmount;
    }

    public void setRefundAmount(BigDecimal refundAmount) {
        this.refundAmount = refundAmount;
    }

    public String getCancelReason() {
        return cancelReason;
    }

    public void setCancelReason(String cancelReason) {
        this.cancelReason = cancelReason;
    }

    @Override
    public String toString() {
        return "Booking{" +
                "bookingID=" + bookingID +
                ", customerID=" + customerID +
                ", bookingType='" + bookingType + '\'' +
                ", totalPrice=" + totalPrice +
                ", deposit=" + deposit +
                ", paymentMethod='" + paymentMethod + '\'' +
                ", paymentStatus='" + paymentStatus + '\'' +
                ", paidAmount=" + paidAmount +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
