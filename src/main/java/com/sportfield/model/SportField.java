/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.sportfield.model;

/**
 *
 * @author hxhbang
 */
public class SportField {

    private int fieldID;
    private int ownerID;
    private String name;
    private String fieldType;
    private String image;
    private String status;

    public SportField() {
    }

    public SportField(int fieldID, int ownerID, String name, String fieldType, String image, String status) {
        this.fieldID = fieldID;
        this.ownerID = ownerID;
        this.name = name;
        this.fieldType = fieldType;
        this.image = image;
        this.status = status;
    }

    public int getFieldID() {
        return fieldID;
    }

    public void setFieldID(int fieldID) {
        this.fieldID = fieldID;
    }

    public int getOwnerID() {
        return ownerID;
    }

    public void setOwnerID(int ownerID) {
        this.ownerID = ownerID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getFieldType() {
        return fieldType;
    }

    public void setFieldType(String fieldType) {
        this.fieldType = fieldType;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "SportField{" + "fieldID=" + fieldID + ", name=" + name + ", status=" + status + '}';
    }
}
