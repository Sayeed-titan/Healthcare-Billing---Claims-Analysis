# 💼 Healthcare Billing & Claims Analysis

## Project Overview

A comprehensive revenue cycle management analytics solution analyzing insurance claims processing, denial patterns, and payment cycles. This project demonstrates healthcare financial data analysis skills including claims approval tracking, insurance provider performance comparison, and revenue optimization strategies.

![Dashboard Preview](screenshots/billing_claims_dashboard.png)

---

## 📊 Business Problem

Healthcare billing departments face challenges:
- Low claim approval rates leading to revenue loss
- High denial rates requiring costly rework
- Long payment cycles affecting cash flow
- Lack of visibility into insurance provider performance
- Difficulty identifying denial root causes

---

## 🗂️ Database Schema

```
┌─────────────────────┐
│      Patients       │
├─────────────────────┤
│ PatientID (PK)      │
│ PatientName         │
│ Age                 │
│ Gender              │
│ InsuranceType       │
└──────────┬──────────┘
           │
           │         ┌─────────────────────┐
           │         │ InsuranceProviders  │
           │         ├─────────────────────┤
           │         │ ProviderID (PK)     │
           │         │ ProviderName        │
           │         │ InsuranceType       │
           │         │ CoveragePercent     │
           │         └──────────┬──────────┘
           │                    │
           │    ┌───────────────┴───────────────┐
           │    │            Claims             │
           │    ├───────────────────────────────┤
           └────┤ ClaimID (PK)                  │
                │ PatientID (FK)                │
                │ ProviderID (FK)               │
                │ ServiceID (FK)                │
                │ ClaimDate                     │
                │ BilledAmount                  │
                │ ApprovedAmount                │
                │ PatientResponsibility         │
                │ ClaimStatus                   │
                │ PaymentDate                   │
                │ DenialReason                  │
                └───────────────┬───────────────┘
                                │
                    ┌───────────┴───────────┐
                    │       Services        │
                    ├───────────────────────┤
                    │ ServiceID (PK)        │
                    │ ServiceName           │
                    │ ServiceCategory       │
                    │ StandardCharge        │
                    └───────────────────────┘
```

---

## 📈 Key Metrics & Findings

| Metric | Value | Industry Benchmark |
|--------|-------|-------------------|
| Total Claims | 60 | - |
| Total Billed | ₹32.5 Lakhs | - |
| Total Collected | ₹23.4 Lakhs | - |
| Collection Rate | 72.0% | Target: 95%+ |
| Denial Rate | 8.3% | Industry: 5-10% |
| Avg Days to Payment | 18 days | Target: <30 days |

### Top Findings:

1. **Government Insurance** (Ayushman Bharat, ESI) = 100% approval rate vs Private at 65-73%
2. **Pre-existing condition** denials = 40% of lost revenue (₹3.35L)
3. **Surgery claims** have highest denial risk (31.5%) - need pre-authorization
4. **Payment cycle**: Government (14 days avg) vs Private (21 days avg)
5. **Self-pay** patients = ₹2.95L billed with 0% insurance coverage

### Revenue Leakage Analysis:

| Denial Reason | Count | Lost Revenue | % of Total |
|---------------|-------|--------------|------------|
| Pre-existing condition | 2 | ₹3,35,000 | 40.4% |
| Policy limit exceeded | 1 | ₹2,50,000 | 30.2% |
| Waiting period | 1 | ₹1,80,000 | 21.7% |
| Not covered | 1 | ₹45,000 | 5.4% |
| Documentation | 1 | ₹18,000 | 2.2% |

---

## 🛠️ Technical Implementation

### SQL Techniques Used

| Technique | Query | Purpose |
|-----------|-------|---------|
| ISNULL / COALESCE | #1, #2 | Handle NULL approved amounts |
| NULLIF | #2, #5 | Prevent division by zero |
| CASE Statements | #1 | Status categorization |
| Multiple JOINs | #3, #7 | Provider-Service analysis |
| CTEs | #5 | Monthly revenue trends |
| Percentage Calculations | All | Rate computations |
| Date Functions | #6 | Payment cycle analysis |
| Aggregations | All | SUM, COUNT, AVG |

### Key Queries

**Collection Rate with NULL Handling:**
```sql
SELECT 
    ip.ProviderName,
    COUNT(c.ClaimID) AS TotalClaims,
    ROUND(SUM(c.BilledAmount), 0) AS TotalBilled,
    ROUND(SUM(ISNULL(c.ApprovedAmount, 0)), 0) AS TotalPaid,
    ROUND(
        SUM(ISNULL(c.ApprovedAmount, 0)) * 100.0 / 
        NULLIF(SUM(c.BilledAmount), 0),
    2) AS PaymentRate
FROM Claims c
JOIN InsuranceProviders ip ON c.ProviderID = ip.ProviderID
GROUP BY ip.ProviderName
ORDER BY PaymentRate DESC;
```

**Payment Cycle Analysis:**
```sql
SELECT 
    ip.ProviderName,
    ROUND(AVG(
        DATEDIFF(DAY, c.ClaimDate, c.PaymentDate)
    ), 1) AS AvgDaysToPayment
FROM Claims c
JOIN InsuranceProviders ip ON c.ProviderID = ip.ProviderID
WHERE c.PaymentDate IS NOT NULL
GROUP BY ip.ProviderName
ORDER BY AvgDaysToPayment;
```

---

## 📁 Project Structure

```
project2-billing-claims-analysis/
│
├── sql/
│   ├── 01_complete_setup.sql      # All tables, data & queries
│   └── 02_analysis_queries.sql    # Standalone analysis queries
│
├── excel/
│   └── Billing_Claims_Dashboard.xlsx
│
├── screenshots/
│   ├── billing_claims_dashboard.png
│   ├── revenue_trends.png
│   ├── denial_analysis.png
│   └── insurance_comparison.png
│
└── README.md
```

---

## 🚀 How to Run

### Prerequisites
- SQL Server 2016+ or SQL Server Express
- SQL Server Management Studio (SSMS)
- Microsoft Excel 2016+

### Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/healthcare-data-analyst-portfolio.git
   ```

2. **Create the database**
   ```sql
   -- Open SSMS and run:
   01_complete_setup.sql
   ```

3. **Run analysis queries**
   - Queries are included at the bottom of setup file
   - Or run `02_analysis_queries.sql` separately

4. **Export results to Excel**
   - Copy query results to respective Excel sheets
   - Dashboard auto-updates with linked charts

5. **View Dashboard**
   - Open `Billing_Claims_Dashboard.xlsx`

---

## 📊 Dashboard Components

| Component | Chart Type | Data Source |
|-----------|------------|-------------|
| KPI Cards (5) | Text/Merge cells | Query #10 |
| Revenue Trend | Dual Line Chart | Query #5 |
| Claims Status | Pie Chart | Query #1 |
| Service Revenue | Horizontal Bar | Query #2 |
| Denial Reasons | Pie Chart | Query #4 |
| Insurance Table | Formatted Table | Query #3 |
| Insights Box | Text Box | Analysis summary |

---

## 💰 Healthcare Finance Domain Knowledge

This project demonstrates understanding of:

- **Revenue Cycle Management (RCM)** - End-to-end billing process
- **Claims Processing** - Submission, adjudication, payment workflow
- **Denial Management** - Root cause analysis and prevention
- **Insurance Types** - Government (Ayushman, CGHS, ESI) vs Private
- **Collection Rate** - Key financial performance indicator
- **Days in A/R** - Accounts receivable aging metric
- **Pre-authorization** - Prior approval for high-cost procedures
- **CPT/HCPCS Codes** - Procedure coding standards

---

## 📋 Recommendations (Based on Analysis)

1. **Implement Pre-Authorization Workflow**
   - Mandate pre-auth for Surgery claims (31.5% denial rate)
   - Expected reduction: 15-20% in surgery denials

2. **Documentation Checklist**
   - Create standardized submission checklist
   - Target: Eliminate documentation-related denials

3. **Insurance Contract Review**
   - Negotiate better rates with HDFC Ergo (64.9% payment rate)
   - Consider network expansion with ESI (100% approval)

4. **Self-Pay Collection Strategy**
   - ₹2.95L in self-pay claims
   - Implement payment plans and financial counseling

5. **Denial Appeal Process**
   - Prioritize pre-existing condition appeals (₹3.35L opportunity)
   - Create appeal letter templates

---

## 📈 Potential Impact

| Initiative | Estimated Recovery |
|------------|-------------------|
| Appeal denied claims | ₹4-5 Lakhs |
| Pre-authorization compliance | ₹2-3 Lakhs/year |
| Documentation improvement | ₹50,000/year |
| Contract renegotiation | ₹1-2 Lakhs/year |
| **Total Potential** | **₹7-10 Lakhs/year** |

---

## 👤 Author

**[Kazi Abu Sayeed**
- LinkedIn: [https://www.linkedin.com/in/kazi-abu-sayeed29/]
- Email: [kaziabu.sayeed29@gmail.com]

---

## 📄 License

This project is open source and available under the MIT License.

---

## 🔗 Related Projects

- [Project 1: Hospital Patient Care Analysis](../project1-patient-care-analysis/)