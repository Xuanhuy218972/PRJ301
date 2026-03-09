package com.sportfield.model;

import java.util.List;

public class SearchResultDTO {
    private SportField field;
    private List<FieldSlot> availableSlots;

    public SearchResultDTO() {
    }

    public SearchResultDTO(SportField field, List<FieldSlot> availableSlots) {
        this.field = field;
        this.availableSlots = availableSlots;
    }

    public SportField getField() {
        return field;
    }

    public void setField(SportField field) {
        this.field = field;
    }

    public List<FieldSlot> getAvailableSlots() {
        return availableSlots;
    }

    public void setAvailableSlots(List<FieldSlot> availableSlots) {
        this.availableSlots = availableSlots;
    }
}
