package com.sportfield.model;

import java.time.LocalDate;

public class BookingIntent {

    private int fieldType;   // 5, 7, or 11
    private LocalDate date;  // resolved absolute date
    private int startHour;   // e.g. 12
    private int endHour;     // e.g. 18

    public BookingIntent() {}

    public BookingIntent(int fieldType, LocalDate date, int startHour, int endHour) {
        this.fieldType = fieldType;
        this.date = date;
        this.startHour = startHour;
        this.endHour = endHour;
    }

    public int getFieldType() { return fieldType; }
    public void setFieldType(int fieldType) { this.fieldType = fieldType; }

    public LocalDate getDate() { return date; }
    public void setDate(LocalDate date) { this.date = date; }

    public int getStartHour() { return startHour; }
    public void setStartHour(int startHour) { this.startHour = startHour; }

    public int getEndHour() { return endHour; }
    public void setEndHour(int endHour) { this.endHour = endHour; }
}
