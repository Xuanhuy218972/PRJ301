package com.sportfield.model;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Model class for BookingDetails table
 * @author hxhbang
 */
public class BookingDetail {
    private int detailID;
    private int bookingID;
    private int slotID;
    private LocalDate bookingDate;
    private BigDecimal price;
    private String fieldName;
    private String slotStartTime;
    private String slotEndTime;
    private String customerName;
    private String customerPhone;
    private String bookingStatus;
    private String paymentStatus;
    private BigDecimal paidAmount;

    public BookingDetail() {
    }

    public BookingDetail(int detailID, int bookingID, int slotID, LocalDate bookingDate, BigDecimal price) {
        this.detailID = detailID;
        this.bookingID = bookingID;
        this.slotID = slotID;
        this.bookingDate = bookingDate;
        this.price = price;
    }

    // Getters and Setters
    public int getDetailID() {
        return detailID;
    }

    public void setDetailID(int detailID) {
        this.detailID = detailID;
    }

    public int getBookingID() {
        return bookingID;
    }

    public void setBookingID(int bookingID) {
        this.bookingID = bookingID;
    }

    public int getSlotID() {
        return slotID;
    }

    public void setSlotID(int slotID) {
        this.slotID = slotID;
    }

    public LocalDate getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(LocalDate bookingDate) {
        this.bookingDate = bookingDate;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getFieldName() {
        return fieldName;
    }

    public void setFieldName(String fieldName) {
        this.fieldName = fieldName;
    }

    public String getSlotStartTime() {
        return slotStartTime;
    }

    public void setSlotStartTime(String slotStartTime) {
        this.slotStartTime = slotStartTime;
    }

    public String getSlotEndTime() {
        return slotEndTime;
    }

    public void setSlotEndTime(String slotEndTime) {
        this.slotEndTime = slotEndTime;
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

    public String getBookingStatus() {
        return bookingStatus;
    }

    public void setBookingStatus(String bookingStatus) {
        this.bookingStatus = bookingStatus;
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

    @Override
    public String toString() {
        return "BookingDetail{" +
                "detailID=" + detailID +
                ", bookingID=" + bookingID +
                ", slotID=" + slotID +
                ", bookingDate=" + bookingDate +
                ", price=" + price +
                '}';
    }
}
