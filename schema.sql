-- =====================================================
-- PROJECT : Healthcare Billing & Claims Analysis
-- Domain: Healthcare Finance
-- Objective: Analyze billing patterns, insurance claims,
--            revenue cycle, and payment trends
-- =====================================================

CREATE DATABASE HealthcareBillingDB;
GO
USE HealthcareBillingDB;
GO

-- =====================================================
-- TABLES
-- =====================================================
CREATE TABLE Patients (
    PatientID INT PRIMARY KEY,
    PatientName VARCHAR(100),
    Age INT,
    Gender VARCHAR(10),
    InsuranceType VARCHAR(30) -- Government, Private, Self-Pay
);

CREATE TABLE InsuranceProviders (
    ProviderID INT PRIMARY KEY,
    ProviderName VARCHAR(50),
    InsuranceType VARCHAR(30),
    CoveragePercent DECIMAL(5,2)
);

CREATE TABLE Services (
    ServiceID INT PRIMARY KEY,
    ServiceName VARCHAR(100),
    ServiceCategory VARCHAR(50),
    StandardCharge DECIMAL(10,2)
);

CREATE TABLE Claims (
    ClaimID INT PRIMARY KEY,
    PatientID INT FOREIGN KEY REFERENCES Patients(PatientID),
    ProviderID INT FOREIGN KEY REFERENCES InsuranceProviders(ProviderID),
    ServiceID INT FOREIGN KEY REFERENCES Services(ServiceID),
    ClaimDate DATE,
    BilledAmount DECIMAL(10,2),
    ApprovedAmount DECIMAL(10,2),
    PatientResponsibility DECIMAL(10,2),
    ClaimStatus VARCHAR(20), -- Approved, Denied, Pending, Partial
    PaymentDate DATE,
    DenialReason VARCHAR(100)
);
