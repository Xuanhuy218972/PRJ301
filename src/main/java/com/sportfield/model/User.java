package com.sportfield.model;

import java.sql.Timestamp;

public class User {
    private int userID;
    private String username;
    private String password;
    private String fullName;
    private String email;
    private String phone;
    private String role;
    private double walletBalance;
    private String avatar;
    private Timestamp createdAt;
    private String address;
    private String gender;
    private String dateOfBirth;

    public User() {
    }

    public User(int userID, String username, String password, String fullName, String email, String phone, String role, double walletBalance, String avatar, Timestamp createdAt, String address, String gender, String dateOfBirth) {
        this.userID = userID;
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.role = role;
        this.walletBalance = walletBalance;
        this.avatar = avatar;
        this.createdAt = createdAt;
        this.address = address;
        this.gender = gender;
        this.dateOfBirth = dateOfBirth;
    }

    public User(String username, String password, String fullName, String email, String phone) {
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
    }

    public int getUserID() { return userID; }
    public void setUserID(int userID) { this.userID = userID; }
    
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    
    public double getWalletBalance() { return walletBalance; }
    public void setWalletBalance(double walletBalance) { this.walletBalance = walletBalance; }
    
    public String getAvatar() { return avatar; }
    public void setAvatar(String avatar) { this.avatar = avatar; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    
    public String getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(String dateOfBirth) { this.dateOfBirth = dateOfBirth; }
}
