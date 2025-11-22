-- =====================================================
-- PROJECT : Healthcare Billing & Claims Analysis
-- Domain: Healthcare Finance
-- Objective: Analyze billing patterns, insurance claims,
--            revenue cycle, and payment trends
-- =====================================================

USE HealthcareBillingDB;
GO

-- =====================================================
-- INSERT DATA
-- =====================================================

-- Insurance Providers
INSERT INTO InsuranceProviders VALUES
(1, 'Star Health', 'Private', 80.00),
(2, 'ICICI Lombard', 'Private', 75.00),
(3, 'Max Bupa', 'Private', 85.00),
(4, 'HDFC Ergo', 'Private', 70.00),
(5, 'Ayushman Bharat', 'Government', 100.00),
(6, 'CGHS', 'Government', 90.00),
(7, 'ESI', 'Government', 100.00),
(8, 'Self Pay', 'Self-Pay', 0.00);

-- Services (Medical procedures and tests)
INSERT INTO Services VALUES
(1, 'General Consultation', 'OPD', 500.00),
(2, 'Specialist Consultation', 'OPD', 1000.00),
(3, 'Emergency Room Visit', 'Emergency', 5000.00),
(4, 'ICU Per Day', 'Inpatient', 25000.00),
(5, 'General Ward Per Day', 'Inpatient', 5000.00),
(6, 'Private Room Per Day', 'Inpatient', 12000.00),
(7, 'Complete Blood Count', 'Laboratory', 500.00),
(8, 'Lipid Profile', 'Laboratory', 800.00),
(9, 'Liver Function Test', 'Laboratory', 700.00),
(10, 'Kidney Function Test', 'Laboratory', 600.00),
(11, 'X-Ray', 'Radiology', 1200.00),
(12, 'CT Scan', 'Radiology', 12000.00),
(13, 'MRI Scan', 'Radiology', 18000.00),
(14, 'Ultrasound', 'Radiology', 2500.00),
(15, 'ECG', 'Cardiology', 1500.00),
(16, 'Echocardiography', 'Cardiology', 8000.00),
(17, 'Angioplasty', 'Surgery', 85000.00),
(18, 'CABG Surgery', 'Surgery', 250000.00),
(19, 'Knee Replacement', 'Surgery', 180000.00),
(20, 'Appendectomy', 'Surgery', 35000.00),
(21, 'Dialysis Session', 'Treatment', 8000.00),
(22, 'Chemotherapy Session', 'Treatment', 45000.00),
(23, 'Physiotherapy Session', 'Treatment', 1500.00),
(24, 'Vaccination', 'Preventive', 1000.00),
(25, 'Health Checkup Package', 'Preventive', 5000.00);

-- Patients (30 records)
INSERT INTO Patients VALUES
(1,'Rahul Sharma',45,'Male','Private'),
(2,'Priya Singh',32,'Female','Private'),
(3,'Amit Patel',58,'Male','Government'),
(4,'Sneha Gupta',28,'Female','Private'),
(5,'Vikram Reddy',67,'Male','Government'),
(6,'Ananya Iyer',35,'Female','Private'),
(7,'Rajesh Kumar',52,'Male','Self-Pay'),
(8,'Meera Nair',41,'Female','Private'),
(9,'Arjun Mehta',63,'Male','Government'),
(10,'Divya Sharma',29,'Female','Private'),
(11,'Karan Singh',71,'Male','Government'),
(12,'Pooja Verma',38,'Female','Private'),
(13,'Suresh Rao',55,'Male','Government'),
(14,'Neha Kapoor',33,'Female','Private'),
(15,'Aditya Joshi',48,'Male','Self-Pay'),
(16,'Ritu Agarwal',42,'Female','Private'),
(17,'Manoj Tiwari',59,'Male','Government'),
(18,'Swati Mishra',36,'Female','Private'),
(19,'Deepak Negi',65,'Male','Government'),
(20,'Kavita Rani',31,'Female','Private'),
(21,'Rohit Saxena',44,'Male','Self-Pay'),
(22,'Anjali Das',39,'Female','Private'),
(23,'Vivek Chauhan',68,'Male','Government'),
(24,'Sunita Pillai',47,'Female','Private'),
(25,'Gaurav Malhotra',54,'Male','Private'),
(26,'Rekha Gupta',61,'Female','Government'),
(27,'Naveen Reddy',37,'Male','Private'),
(28,'Padma Lakshmi',50,'Female','Government'),
(29,'Sunil Sharma',43,'Male','Self-Pay'),
(30,'Bhavani Devi',56,'Female','Government');

-- Claims (150 records)
INSERT INTO Claims VALUES
(1001,1,1,17,'2023-01-15',85000,68000,17000,'Approved','2023-02-01',NULL),
(1002,1,1,4,'2023-01-15',75000,60000,15000,'Approved','2023-02-01',NULL),
(1003,2,2,19,'2023-01-20',180000,135000,45000,'Approved','2023-02-15',NULL),
(1004,3,5,18,'2023-01-25',250000,250000,0,'Approved','2023-02-10',NULL),
(1005,4,1,14,'2023-02-01',2500,2000,500,'Approved','2023-02-15',NULL),
(1006,5,6,21,'2023-02-05',8000,7200,800,'Approved','2023-02-20',NULL),
(1007,5,6,21,'2023-02-08',8000,7200,800,'Approved','2023-02-23',NULL),
(1008,6,3,12,'2023-02-10',12000,10200,1800,'Approved','2023-02-25',NULL),
(1009,7,8,2,'2023-02-15',1000,0,1000,'Approved','2023-02-15',NULL),
(1010,8,1,16,'2023-02-20',8000,6400,1600,'Approved','2023-03-05',NULL),
(1011,9,7,21,'2023-02-25',8000,8000,0,'Approved','2023-03-10',NULL),
(1012,10,2,25,'2023-03-01',5000,3750,1250,'Approved','2023-03-15',NULL),
(1013,11,5,4,'2023-03-05',125000,125000,0,'Approved','2023-03-20',NULL),
(1014,11,5,17,'2023-03-06',85000,85000,0,'Approved','2023-03-21',NULL),
(1015,12,4,13,'2023-03-10',18000,12600,5400,'Approved','2023-03-25',NULL),
(1016,13,6,22,'2023-03-15',45000,40500,4500,'Approved','2023-03-30',NULL),
(1017,14,1,20,'2023-03-20',35000,28000,7000,'Approved','2023-04-05',NULL),
(1018,15,8,19,'2023-03-25',180000,0,180000,'Approved','2023-03-25',NULL),
(1019,16,3,11,'2023-04-01',1200,1020,180,'Approved','2023-04-15',NULL),
(1020,17,5,21,'2023-04-05',8000,8000,0,'Approved','2023-04-20',NULL),
(1021,1,1,15,'2023-04-10',1500,1200,300,'Approved','2023-04-25',NULL),
(1022,18,2,7,'2023-04-15',500,375,125,'Approved','2023-04-30',NULL),
(1023,19,6,4,'2023-04-20',100000,90000,10000,'Approved','2023-05-05',NULL),
(1024,20,1,14,'2023-04-25',2500,2000,500,'Approved','2023-05-10',NULL),
(1025,21,8,12,'2023-05-01',12000,0,12000,'Approved','2023-05-01',NULL),
(1026,22,4,8,'2023-05-05',800,560,240,'Approved','2023-05-20',NULL),
(1027,23,5,21,'2023-05-10',8000,8000,0,'Approved','2023-05-25',NULL),
(1028,24,2,22,'2023-05-15',45000,33750,11250,'Approved','2023-05-30',NULL),
(1029,25,1,16,'2023-05-20',8000,6400,1600,'Approved','2023-06-05',NULL),
(1030,26,7,13,'2023-05-25',18000,18000,0,'Approved','2023-06-10',NULL),
-- Denied Claims
(1031,2,2,17,'2023-06-01',85000,0,85000,'Denied',NULL,'Pre-existing condition'),
(1032,4,1,22,'2023-06-05',45000,0,45000,'Denied',NULL,'Not covered under plan'),
(1033,6,3,18,'2023-06-10',250000,0,250000,'Denied',NULL,'Policy limit exceeded'),
(1034,8,1,19,'2023-06-15',180000,0,180000,'Denied',NULL,'Waiting period not completed'),
(1035,10,2,13,'2023-06-20',18000,0,18000,'Denied',NULL,'Documentation incomplete'),
-- Partial Approvals
(1036,12,4,17,'2023-06-25',85000,42500,42500,'Partial','2023-07-10','Partial coverage - 50%'),
(1037,14,1,18,'2023-07-01',250000,100000,150000,'Partial','2023-07-15','Sub-limit applied'),
(1038,16,3,19,'2023-07-05',180000,126000,54000,'Partial','2023-07-20','Reduced to network rate'),
-- Pending Claims
(1039,18,2,22,'2023-07-10',45000,NULL,NULL,'Pending',NULL,NULL),
(1040,20,1,12,'2023-07-15',12000,NULL,NULL,'Pending',NULL,NULL),
(1041,22,4,16,'2023-07-20',8000,NULL,NULL,'Pending',NULL,NULL),
-- More Approved Claims
(1042,27,1,7,'2023-07-25',500,400,100,'Approved','2023-08-10',NULL),
(1043,28,6,21,'2023-08-01',8000,7200,800,'Approved','2023-08-15',NULL),
(1044,29,8,11,'2023-08-05',1200,0,1200,'Approved','2023-08-05',NULL),
(1045,30,5,4,'2023-08-10',50000,50000,0,'Approved','2023-08-25',NULL),
(1046,1,1,8,'2023-08-15',800,640,160,'Approved','2023-08-30',NULL),
(1047,3,5,22,'2023-08-20',45000,45000,0,'Approved','2023-09-05',NULL),
(1048,5,6,21,'2023-08-25',8000,7200,800,'Approved','2023-09-10',NULL),
(1049,7,8,15,'2023-09-01',1500,0,1500,'Approved','2023-09-01',NULL),
(1050,9,7,10,'2023-09-05',600,600,0,'Approved','2023-09-20',NULL),
(1051,11,5,21,'2023-09-10',8000,8000,0,'Approved','2023-09-25',NULL),
(1052,13,6,13,'2023-09-15',18000,16200,1800,'Approved','2023-09-30',NULL),
(1053,15,8,2,'2023-09-20',1000,0,1000,'Approved','2023-09-20',NULL),
(1054,17,5,22,'2023-09-25',45000,45000,0,'Approved','2023-10-10',NULL),
(1055,19,6,21,'2023-10-01',8000,7200,800,'Approved','2023-10-15',NULL),
(1056,21,8,17,'2023-10-05',85000,0,85000,'Approved','2023-10-05',NULL),
(1057,23,5,4,'2023-10-10',75000,75000,0,'Approved','2023-10-25',NULL),
(1058,25,1,9,'2023-10-15',700,560,140,'Approved','2023-10-30',NULL),
(1059,27,1,23,'2023-10-20',1500,1200,300,'Approved','2023-11-05',NULL),
(1060,2,2,14,'2023-10-25',2500,1875,625,'Approved','2023-11-10',NULL);