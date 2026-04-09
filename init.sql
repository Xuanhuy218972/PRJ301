-- PostgreSQL Schema for SportFieldHub
-- Run this script to initialize the database

-- Drop tables if exist (for clean setup)
DROP TABLE IF EXISTS ContactMessages CASCADE;
DROP TABLE IF EXISTS BookingDetails CASCADE;
DROP TABLE IF EXISTS Bookings CASCADE;
DROP TABLE IF EXISTS FieldSlots CASCADE;
DROP TABLE IF EXISTS Fields CASCADE;
DROP TABLE IF EXISTS Users CASCADE;

-- Create Users table
CREATE TABLE Users (
    UserID SERIAL PRIMARY KEY,
    Username VARCHAR(50) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Phone VARCHAR(20),
    Role VARCHAR(20) DEFAULT 'CUSTOMER' CHECK (Role IN ('CUSTOMER', 'OWNER', 'ADMIN')),
    Avatar VARCHAR(255),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Address VARCHAR(255),
    Gender VARCHAR(10),
    DateOfBirth DATE
);

-- Create Fields table
CREATE TABLE Fields (
    FieldID SERIAL PRIMARY KEY,
    OwnerID INTEGER REFERENCES Users(UserID),
    FieldName VARCHAR(100) NOT NULL,
    FieldType INTEGER NOT NULL,
    PricePerHour DECIMAL(10,2) NOT NULL,
    ImageURL VARCHAR(255),
    Status VARCHAR(20) DEFAULT 'ACTIVE' CHECK (Status IN ('ACTIVE', 'INACTIVE', 'MAINTENANCE')),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create FieldSlots table
CREATE TABLE FieldSlots (
    SlotID SERIAL PRIMARY KEY,
    FieldID INTEGER REFERENCES Fields(FieldID) ON DELETE CASCADE,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    Status VARCHAR(20) DEFAULT 'ACTIVE' CHECK (Status IN ('ACTIVE', 'INACTIVE'))
);

-- Create Bookings table
CREATE TABLE Bookings (
    BookingID SERIAL PRIMARY KEY,
    CustomerID INTEGER REFERENCES Users(UserID),
    BookingType VARCHAR(20) DEFAULT 'RETAIL' CHECK (BookingType IN ('RETAIL', 'TOURNAMENT')),
    TotalPrice DECIMAL(10,2) NOT NULL,
    Deposit DECIMAL(10,2) DEFAULT 0,
    Status VARCHAR(20) DEFAULT 'PENDING' CHECK (Status IN ('PENDING', 'CONFIRMED', 'COMPLETED', 'CANCELLED')),
    Note TEXT,
    PaymentMethod VARCHAR(20) DEFAULT 'VNPAY' CHECK (PaymentMethod IN ('VNPAY', 'CASH', 'TRANSFER')),
    PaymentStatus VARCHAR(20) DEFAULT 'UNPAID' CHECK (PaymentStatus IN ('UNPAID', 'DEPOSITED', 'PAID')),
    PaidAmount DECIMAL(10,2) DEFAULT 0,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create BookingDetails table
CREATE TABLE BookingDetails (
    DetailID SERIAL PRIMARY KEY,
    BookingID INTEGER REFERENCES Bookings(BookingID) ON DELETE CASCADE,
    SlotID INTEGER REFERENCES FieldSlots(SlotID),
    BookingDate DATE NOT NULL,
    Price DECIMAL(10,2) NOT NULL
);

-- Create ContactMessages table
CREATE TABLE ContactMessages (
    MessageID SERIAL PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Phone VARCHAR(20),
    Subject VARCHAR(200) NOT NULL,
    Message TEXT NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Status VARCHAR(20) DEFAULT 'NEW' CHECK (Status IN ('NEW', 'READ', 'REPLIED', 'CLOSED'))
);

-- Create indexes for better performance
CREATE INDEX idx_fields_owner ON Fields(OwnerID);
CREATE INDEX idx_fields_status ON Fields(Status);
CREATE INDEX idx_fieldslots_field ON FieldSlots(FieldID);
CREATE INDEX idx_bookings_customer ON Bookings(CustomerID);
CREATE INDEX idx_bookings_status ON Bookings(Status);
CREATE INDEX idx_bookingdetails_booking ON BookingDetails(BookingID);
CREATE INDEX idx_bookingdetails_slot ON BookingDetails(SlotID);
CREATE INDEX idx_users_role ON Users(Role);
CREATE INDEX idx_contact_status ON ContactMessages(Status);

-- Insert default admin user (password: admin)
INSERT INTO Users (Username, Password, FullName, Email, Phone, Role, CreatedAt)
VALUES ('admin', 'admin', 'System Administrator', 'admin@sportfieldhub.com', '0123456789', 'ADMIN', CURRENT_TIMESTAMP);

-- Insert sample owner
INSERT INTO Users (Username, Password, FullName, Email, Phone, Role, CreatedAt)
VALUES ('owner1', 'owner1', 'Field Owner', 'owner@test.com', '0987654321', 'OWNER', CURRENT_TIMESTAMP);

-- Insert sample customer
INSERT INTO Users (Username, Password, FullName, Email, Phone, Role, CreatedAt)
VALUES ('customer1', 'customer1', 'Test Customer', 'customer@test.com', '0123456789', 'CUSTOMER', CURRENT_TIMESTAMP);

-- Insert sample fields
INSERT INTO Fields (OwnerID, FieldName, FieldType, PricePerHour, ImageURL, Status, CreatedAt)
VALUES 
    (2, 'Sân bóng đá số 1', 1, 300000, 'https://example.com/field1.jpg', 'ACTIVE', CURRENT_TIMESTAMP),
    (2, 'Sân bóng đá số 2', 1, 350000, 'https://example.com/field2.jpg', 'ACTIVE', CURRENT_TIMESTAMP),
    (2, 'Sân cầu lông A', 2, 150000, 'https://example.com/badminton1.jpg', 'ACTIVE', CURRENT_TIMESTAMP);

-- Insert sample field slots (for field 1 - soccer)
INSERT INTO FieldSlots (FieldID, StartTime, EndTime, Price, Status)
VALUES 
    (1, '06:00:00', '07:00:00', 300000, 'ACTIVE'),
    (1, '07:00:00', '08:00:00', 300000, 'ACTIVE'),
    (1, '08:00:00', '09:00:00', 300000, 'ACTIVE'),
    (1, '09:00:00', '10:00:00', 300000, 'ACTIVE'),
    (1, '10:00:00', '11:00:00', 300000, 'ACTIVE'),
    (1, '11:00:00', '12:00:00', 300000, 'ACTIVE'),
    (1, '12:00:00', '13:00:00', 300000, 'ACTIVE'),
    (1, '13:00:00', '14:00:00', 300000, 'ACTIVE'),
    (1, '14:00:00', '15:00:00', 300000, 'ACTIVE'),
    (1, '15:00:00', '16:00:00', 300000, 'ACTIVE'),
    (1, '16:00:00', '17:00:00', 350000, 'ACTIVE'),
    (1, '17:00:00', '18:00:00', 350000, 'ACTIVE'),
    (1, '18:00:00', '19:00:00', 350000, 'ACTIVE'),
    (1, '19:00:00', '20:00:00', 400000, 'ACTIVE'),
    (1, '20:00:00', '21:00:00', 400000, 'ACTIVE'),
    (1, '21:00:00', '22:00:00', 400000, 'ACTIVE');

-- Insert sample field slots (for field 3 - badminton)
INSERT INTO FieldSlots (FieldID, StartTime, EndTime, Price, Status)
VALUES 
    (3, '06:00:00', '07:00:00', 150000, 'ACTIVE'),
    (3, '07:00:00', '08:00:00', 150000, 'ACTIVE'),
    (3, '08:00:00', '09:00:00', 150000, 'ACTIVE'),
    (3, '09:00:00', '10:00:00', 150000, 'ACTIVE'),
    (3, '10:00:00', '11:00:00', 150000, 'ACTIVE'),
    (3, '11:00:00', '12:00:00', 150000, 'ACTIVE'),
    (3, '12:00:00', '13:00:00', 150000, 'ACTIVE'),
    (3, '13:00:00', '14:00:00', 150000, 'ACTIVE'),
    (3, '14:00:00', '15:00:00', 150000, 'ACTIVE'),
    (3, '15:00:00', '16:00:00', 150000, 'ACTIVE'),
    (3, '16:00:00', '17:00:00', 180000, 'ACTIVE'),
    (3, '17:00:00', '18:00:00', 180000, 'ACTIVE'),
    (3, '18:00:00', '19:00:00', 180000, 'ACTIVE'),
    (3, '19:00:00', '20:00:00', 200000, 'ACTIVE'),
    (3, '20:00:00', '21:00:00', 200000, 'ACTIVE'),
    (3, '21:00:00', '22:00:00', 200000, 'ACTIVE');
