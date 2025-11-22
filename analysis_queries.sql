-- =====================================================
-- PROJECT : Healthcare Billing & Claims Analysis
-- Domain: Healthcare Finance
-- Objective: Analyze billing patterns, insurance claims,
--            revenue cycle, and payment trends
-- =====================================================

USE HealthcareBillingDB;
GO

-- =====================================================
-- ANALYSIS QUERIES
-- =====================================================

-- QUERY 1: Claims Summary Dashboard
SELECT 
    ClaimStatus,
    COUNT(*) AS ClaimCount,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Claims), 2) AS Percentage,
    ROUND(SUM(BilledAmount), 0) AS TotalBilled,
    ROUND(SUM(ISNULL(ApprovedAmount, 0)), 0) AS TotalApproved,
    ROUND(SUM(ISNULL(PatientResponsibility, 0)), 0) AS TotalPatientPay
FROM Claims
GROUP BY ClaimStatus
ORDER BY ClaimCount DESC;


-- QUERY 2: Revenue by Service Category
SELECT 
    s.ServiceCategory,
    COUNT(c.ClaimID) AS TotalClaims,
    ROUND(SUM(c.BilledAmount), 0) AS TotalBilled,
    ROUND(SUM(ISNULL(c.ApprovedAmount, 0)), 0) AS TotalApproved,
    ROUND(AVG(c.BilledAmount), 0) AS AvgBillAmount,
    ROUND(
        SUM(ISNULL(c.ApprovedAmount, 0)) * 100.0 / NULLIF(SUM(c.BilledAmount), 0),
    2) AS ApprovalRate
FROM Claims c
JOIN Services s ON c.ServiceID = s.ServiceID
GROUP BY s.ServiceCategory
ORDER BY TotalBilled DESC;


-- QUERY 3: Insurance Provider Performance
SELECT 
    ip.ProviderName,
    ip.InsuranceType,
    ip.CoveragePercent AS ExpectedCoverage,
    COUNT(c.ClaimID) AS TotalClaims,
    ROUND(SUM(c.BilledAmount), 0) AS TotalBilled,
    ROUND(SUM(ISNULL(c.ApprovedAmount, 0)), 0) AS TotalPaid,
    ROUND(
        SUM(ISNULL(c.ApprovedAmount, 0)) * 100.0 / NULLIF(SUM(c.BilledAmount), 0),
    2) AS ActualPaymentRate,
    SUM(CASE WHEN c.ClaimStatus = 'Denied' THEN 1 ELSE 0 END) AS DeniedClaims,
    ROUND(
        SUM(CASE WHEN c.ClaimStatus = 'Denied' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
    2) AS DenialRate
FROM InsuranceProviders ip
LEFT JOIN Claims c ON ip.ProviderID = c.ProviderID
GROUP BY ip.ProviderID, ip.ProviderName, ip.InsuranceType, ip.CoveragePercent
ORDER BY TotalBilled DESC;


-- QUERY 4: Denial Reason Analysis
SELECT 
    DenialReason,
    COUNT(*) AS DenialCount,
    ROUND(SUM(BilledAmount), 0) AS LostRevenue,
    ROUND(AVG(BilledAmount), 0) AS AvgClaimAmount
FROM Claims
WHERE ClaimStatus IN ('Denied', 'Partial')
    AND DenialReason IS NOT NULL
GROUP BY DenialReason
ORDER BY LostRevenue DESC;


-- QUERY 5: Monthly Revenue Trend
WITH MonthlyRevenue AS (
    SELECT 
        FORMAT(ClaimDate, 'yyyy-MM') AS Month,
        SUM(BilledAmount) AS Billed,
        SUM(ISNULL(ApprovedAmount, 0)) AS Collected
    FROM Claims
    GROUP BY FORMAT(ClaimDate, 'yyyy-MM')
)
SELECT 
    Month,
    ROUND(Billed, 0) AS BilledAmount,
    ROUND(Collected, 0) AS CollectedAmount,
    ROUND(Collected * 100.0 / NULLIF(Billed, 0), 2) AS CollectionRate,
    ROUND(Billed - Collected, 0) AS OutstandingAmount
FROM MonthlyRevenue
ORDER BY Month;


-- QUERY 6: Payment Cycle Analysis (Days to Payment)
SELECT 
    ip.ProviderName,
    COUNT(c.ClaimID) AS PaidClaims,
    ROUND(AVG(DATEDIFF(DAY, c.ClaimDate, c.PaymentDate)), 1) AS AvgDaysToPayment,
    MIN(DATEDIFF(DAY, c.ClaimDate, c.PaymentDate)) AS MinDays,
    MAX(DATEDIFF(DAY, c.ClaimDate, c.PaymentDate)) AS MaxDays
FROM Claims c
JOIN InsuranceProviders ip ON c.ProviderID = ip.ProviderID
WHERE c.PaymentDate IS NOT NULL
GROUP BY ip.ProviderID, ip.ProviderName
ORDER BY AvgDaysToPayment;


-- QUERY 7: High-Value Claims Analysis
SELECT TOP 10
    c.ClaimID,
    p.PatientName,
    s.ServiceName,
    ip.ProviderName,
    c.BilledAmount,
    ISNULL(c.ApprovedAmount, 0) AS ApprovedAmount,
    c.ClaimStatus,
    c.DenialReason
FROM Claims c
JOIN Patients p ON c.PatientID = p.PatientID
JOIN Services s ON c.ServiceID = s.ServiceID
JOIN InsuranceProviders ip ON c.ProviderID = ip.ProviderID
ORDER BY c.BilledAmount DESC;


-- QUERY 8: Patient Financial Responsibility Analysis
SELECT 
    p.InsuranceType,
    COUNT(DISTINCT p.PatientID) AS Patients,
    COUNT(c.ClaimID) AS TotalClaims,
    ROUND(SUM(c.BilledAmount), 0) AS TotalBilled,
    ROUND(SUM(ISNULL(c.PatientResponsibility, 0)), 0) AS TotalPatientPay,
    ROUND(AVG(ISNULL(c.PatientResponsibility, 0)), 0) AS AvgOutOfPocket,
    ROUND(
        SUM(ISNULL(c.PatientResponsibility, 0)) * 100.0 / NULLIF(SUM(c.BilledAmount), 0),
    2) AS PatientPayPercent
FROM Patients p
JOIN Claims c ON p.PatientID = c.PatientID
GROUP BY p.InsuranceType
ORDER BY TotalBilled DESC;


-- QUERY 9: Service Utilization with Pricing Analysis
SELECT 
    s.ServiceName,
    s.ServiceCategory,
    s.StandardCharge,
    COUNT(c.ClaimID) AS TimesUsed,
    ROUND(AVG(c.BilledAmount), 0) AS AvgBilledAmount,
    ROUND(AVG(c.BilledAmount) - s.StandardCharge, 0) AS PriceVariance
FROM Services s
LEFT JOIN Claims c ON s.ServiceID = c.ServiceID
GROUP BY s.ServiceID, s.ServiceName, s.ServiceCategory, s.StandardCharge
ORDER BY TimesUsed DESC;


-- QUERY 10: KPI Summary for Dashboard
SELECT 'Total Claims' AS Metric, CAST(COUNT(*) AS VARCHAR) AS Value FROM Claims
UNION ALL
SELECT 'Total Billed', '₹' + FORMAT(SUM(BilledAmount), 'N0') FROM Claims
UNION ALL
SELECT 'Total Collected', '₹' + FORMAT(SUM(ISNULL(ApprovedAmount,0)), 'N0') FROM Claims
UNION ALL
SELECT 'Collection Rate', CAST(ROUND(SUM(ISNULL(ApprovedAmount,0))*100.0/SUM(BilledAmount),1) AS VARCHAR) + '%' FROM Claims
UNION ALL
SELECT 'Denial Rate', CAST(ROUND(SUM(CASE WHEN ClaimStatus='Denied' THEN 1 ELSE 0 END)*100.0/COUNT(*),1) AS VARCHAR) + '%' FROM Claims
UNION ALL
SELECT 'Avg Days to Payment', CAST(ROUND(AVG(DATEDIFF(DAY,ClaimDate,PaymentDate)*1.0),0) AS VARCHAR) + ' days' FROM Claims WHERE PaymentDate IS NOT NULL;