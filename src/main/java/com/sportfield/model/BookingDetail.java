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
