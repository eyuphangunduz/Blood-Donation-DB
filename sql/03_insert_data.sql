USE BloodDonation;
GO
SET NOCOUNT ON;
GO

IF OBJECT_ID('trg_UpdateInventoryOnDonation', 'TR') IS NOT NULL
    DISABLE TRIGGER trg_UpdateInventoryOnDonation ON Donations;
IF OBJECT_ID('trg_CheckExpirationDate', 'TR') IS NOT NULL
    DISABLE TRIGGER trg_CheckExpirationDate ON BloodUnit;
GO

DELETE FROM UnitUsage;
DELETE FROM BloodUnit;
DELETE FROM Donations;
DELETE FROM BloodInventory;
DELETE FROM Donors;
DELETE FROM Hospitals;
DELETE FROM Cities;

IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID('Cities') AND last_value IS NOT NULL)
    DBCC CHECKIDENT ('Cities', RESEED, 0) WITH NO_INFOMSGS;
IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID('Hospitals') AND last_value IS NOT NULL)
    DBCC CHECKIDENT ('Hospitals', RESEED, 0) WITH NO_INFOMSGS;
IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID('Donations') AND last_value IS NOT NULL)
    DBCC CHECKIDENT ('Donations', RESEED, 0) WITH NO_INFOMSGS;
IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID('BloodInventory') AND last_value IS NOT NULL)
    DBCC CHECKIDENT ('BloodInventory', RESEED, 0) WITH NO_INFOMSGS;
IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID('BloodUnit') AND last_value IS NOT NULL)
    DBCC CHECKIDENT ('BloodUnit', RESEED, 0) WITH NO_INFOMSGS;
IF EXISTS (SELECT 1 FROM sys.identity_columns WHERE object_id = OBJECT_ID('UnitUsage') AND last_value IS NOT NULL)
    DBCC CHECKIDENT ('UnitUsage', RESEED, 0) WITH NO_INFOMSGS;
GO

INSERT INTO Cities (CityName, Region)
SELECT CityName, Region
FROM (VALUES
 (1,'Adana','Mediterranean'),(2,'Adiyaman','Southeastern Anatolia'),(3,'Afyonkarahisar','Aegean'),
 (4,'Agri','Eastern Anatolia'),(5,'Amasya','Black Sea'),(6,'Ankara','Central Anatolia'),
 (7,'Antalya','Mediterranean'),(8,'Artvin','Black Sea'),(9,'Aydin','Aegean'),
 (10,'Balikesir','Marmara'),(11,'Bilecik','Marmara'),(12,'Bingol','Eastern Anatolia'),
 (13,'Bitlis','Eastern Anatolia'),(14,'Bolu','Black Sea'),(15,'Burdur','Mediterranean'),
 (16,'Bursa','Marmara'),(17,'Canakkale','Marmara'),(18,'Cankiri','Central Anatolia'),
 (19,'Corum','Black Sea'),(20,'Denizli','Aegean'),(21,'Diyarbakir','Southeastern Anatolia'),
 (22,'Edirne','Marmara'),(23,'Elazig','Eastern Anatolia'),(24,'Erzincan','Eastern Anatolia'),
 (25,'Erzurum','Eastern Anatolia'),(26,'Eskisehir','Central Anatolia'),(27,'Gaziantep','Southeastern Anatolia'),
 (28,'Giresun','Black Sea'),(29,'Gumushane','Black Sea'),(30,'Hakkari','Eastern Anatolia'),
 (31,'Hatay','Mediterranean'),(32,'Isparta','Mediterranean'),(33,'Mersin','Mediterranean'),
 (34,'Istanbul','Marmara'),(35,'Izmir','Aegean'),(36,'Kars','Eastern Anatolia'),
 (37,'Kastamonu','Black Sea'),(38,'Kayseri','Central Anatolia'),(39,'Kirklareli','Marmara'),
 (40,'Kirsehir','Central Anatolia'),(41,'Kocaeli','Marmara'),(42,'Konya','Central Anatolia'),
 (43,'Kutahya','Aegean'),(44,'Malatya','Eastern Anatolia'),(45,'Manisa','Aegean'),
 (46,'Kahramanmaras','Mediterranean'),(47,'Mardin','Southeastern Anatolia'),(48,'Mugla','Aegean'),
 (49,'Mus','Eastern Anatolia'),(50,'Nevsehir','Central Anatolia'),(51,'Nigde','Central Anatolia'),
 (52,'Ordu','Black Sea'),(53,'Rize','Black Sea'),(54,'Sakarya','Marmara'),
 (55,'Samsun','Black Sea'),(56,'Siirt','Southeastern Anatolia'),(57,'Sinop','Black Sea'),
 (58,'Sivas','Central Anatolia'),(59,'Tekirdag','Marmara'),(60,'Tokat','Black Sea'),
 (61,'Trabzon','Black Sea'),(62,'Tunceli','Eastern Anatolia'),(63,'Sanliurfa','Southeastern Anatolia'),
 (64,'Usak','Aegean'),(65,'Van','Eastern Anatolia'),(66,'Yozgat','Central Anatolia'),
 (67,'Zonguldak','Black Sea'),(68,'Aksaray','Central Anatolia'),(69,'Bayburt','Black Sea'),
 (70,'Karaman','Central Anatolia'),(71,'Kirikkale','Central Anatolia'),(72,'Batman','Southeastern Anatolia'),
 (73,'Sirnak','Southeastern Anatolia'),(74,'Bartin','Black Sea'),(75,'Ardahan','Eastern Anatolia'),
 (76,'Igdir','Eastern Anatolia'),(77,'Yalova','Marmara'),(78,'Karabuk','Black Sea'),
 (79,'Kilis','Southeastern Anatolia'),(80,'Osmaniye','Mediterranean'),(81,'Duzce','Black Sea')
) AS v (Plate, CityName, Region)
ORDER BY Plate;
GO

INSERT INTO Hospitals (HospitalName, hospitalAddress, Phone, HospitalType, CityID)
SELECT HospitalName, Address, Phone, HospitalType, CityID
FROM (VALUES
 ( 1, 'Cerrahpasa Medical Faculty Hospital', 'University', 34, 'Hospital Street No: 1, Istanbul',  '02120000001'),
 ( 2, 'Ankara City Hospital',                'State',       6, 'Hospital Street No: 2, Ankara',    '03120000002'),
 ( 3, 'Izmir Private Kent Hospital',         'Private',    35, 'Hospital Street No: 3, Izmir',     '02320000003'),
 ( 4, 'Istanbul State Hospital 1',           'State',      34, 'Hospital Street No: 4, Istanbul',  '02120000004'),
 ( 5, 'Istanbul State Hospital 2',           'State',      34, 'Hospital Street No: 5, Istanbul',  '02160000005'),
 ( 6, 'Istanbul Private Hospital',           'Private',    34, 'Hospital Street No: 6, Istanbul',  '02160000006'),
 ( 7, 'Bursa State Hospital',                'State',      16, 'Hospital Street No: 7, Bursa',     '02240000007'),
 ( 8, 'Kocaeli Private Hospital',            'Private',    41, 'Hospital Street No: 8, Kocaeli',   '02620000008'),
 ( 9, 'Izmir State Hospital',                'State',      35, 'Hospital Street No: 9, Izmir',     '02320000009'),
 (10, 'Manisa State Hospital',               'State',      45, 'Hospital Street No: 10, Manisa',   '02360000010'),
 (11, 'Ankara Private Hospital',             'Private',     6, 'Hospital Street No: 11, Ankara',   '03120000011'),
 (12, 'Konya State Hospital',                'State',      42, 'Hospital Street No: 12, Konya',    '03320000012'),
 (13, 'Antalya State Hospital',              'State',       7, 'Hospital Street No: 13, Antalya',  '02420000013'),
 (14, 'Antalya Private Hospital',            'Private',     7, 'Hospital Street No: 14, Antalya',  '02420000014'),
 (15, 'Adana State Hospital',                'State',       1, 'Hospital Street No: 15, Adana',    '03220000015'),
 (16, 'Samsun State Hospital',               'State',      55, 'Hospital Street No: 16, Samsun',   '03620000016'),
 (17, 'Trabzon Private Hospital',            'Private',    61, 'Hospital Street No: 17, Trabzon',  '04620000017'),
 (18, 'Gaziantep State Hospital',            'State',      27, 'Hospital Street No: 18, Gaziantep','03420000018'),
 (19, 'Diyarbakir Private Hospital',         'Private',    21, 'Hospital Street No: 19, Diyarbakir','04120000019'),
 (20, 'Erzurum State Hospital',              'State',      25, 'Hospital Street No: 20, Erzurum',  '04420000020')
) AS v (Ord, HospitalName, HospitalType, CityID, Address, Phone)
ORDER BY Ord;
GO

DECLARE @Today       DATE = CAST(GETDATE() AS DATE);
DECLARE @WindowEnd   DATE = DATEADD(DAY, -1, @Today);
DECLARE @WindowStart DATE = DATEADD(DAY, -365, @Today);

DROP TABLE IF EXISTS #QSex, #QAge, #QBlood, #QType, #QRegion;

CREATE TABLE #QSex (Ord INT, Sex CHAR(1), Cnt INT);
INSERT INTO #QSex VALUES (1, 'M', 846), (2, 'F', 154);

CREATE TABLE #QAge (Ord INT, AgeBand TINYINT, MinAge INT, MaxAge INT, Cnt INT);
INSERT INTO #QAge VALUES (1, 1, 18, 24, 213), (2, 2, 25, 44, 522), (3, 3, 45, 65, 265);

CREATE TABLE #QBlood (Ord INT, BloodGroup VARCHAR(3), Cnt INT, Share DECIMAL(5, 3));
INSERT INTO #QBlood VALUES (1, 'A+', 372, 0.371), (2, 'A-', 50, 0.050), (3, 'B+', 144, 0.144),
                           (4, 'B-', 19, 0.019), (5, 'AB+', 66, 0.066), (6, 'AB-', 9, 0.009),
                           (7, 'O+', 298, 0.297), (8, 'O-', 42, 0.042);

CREATE TABLE #QType (Ord INT, DonorType VARCHAR(11), Cnt INT);
INSERT INTO #QType VALUES (1, 'Volunteer', 900), (2, 'Replacement', 100);

CREATE TABLE #QRegion (Ord INT, Region VARCHAR(25), Cnt INT);
INSERT INTO #QRegion VALUES (1, 'Marmara', 291), (2, 'Aegean', 158), (3, 'Central Anatolia', 148),
                            (4, 'Mediterranean', 143), (5, 'Black Sea', 101),
                            (6, 'Southeastern Anatolia', 81), (7, 'Eastern Anatolia', 78);

DROP TABLE IF EXISTS #MaleName, #FemaleName, #Surname;
SELECT Ord, Name INTO #MaleName FROM (VALUES
 (1,'Mehmet'),(2,'Mustafa'),(3,'Ahmet'),(4,'Ali'),(5,'Huseyin'),(6,'Hasan'),(7,'Ibrahim'),
 (8,'Ismail'),(9,'Osman'),(10,'Yusuf'),(11,'Murat'),(12,'Omer'),(13,'Ramazan'),(14,'Halil'),
 (15,'Suleyman'),(16,'Abdullah'),(17,'Mahmut'),(18,'Salih'),(19,'Recep'),(20,'Kemal'),
 (21,'Emre'),(22,'Burak'),(23,'Can'),(24,'Cem'),(25,'Serkan'),(26,'Onur'),(27,'Fatih'),
 (28,'Kadir'),(29,'Hakan'),(30,'Erkan'),(31,'Volkan'),(32,'Tolga'),(33,'Ugur'),(34,'Baris'),
 (35,'Gokhan'),(36,'Emir'),(37,'Yigit'),(38,'Eren'),(39,'Berk'),(40,'Kerem')
) AS v (Ord, Name);

SELECT Ord, Name INTO #FemaleName FROM (VALUES
 (1,'Fatma'),(2,'Ayse'),(3,'Emine'),(4,'Hatice'),(5,'Zeynep'),(6,'Elif'),(7,'Meryem'),
 (8,'Serife'),(9,'Zehra'),(10,'Sultan'),(11,'Hanife'),(12,'Merve'),(13,'Ozlem'),(14,'Esra'),
 (15,'Busra'),(16,'Gamze'),(17,'Derya'),(18,'Ebru'),(19,'Sibel'),(20,'Tugba'),(21,'Seda'),
 (22,'Pinar'),(23,'Gizem'),(24,'Ece'),(25,'Defne'),(26,'Nur'),(27,'Asli'),(28,'Melek'),
 (29,'Yasemin'),(30,'Hulya'),(31,'Dilek'),(32,'Selin'),(33,'Ceren'),(34,'Damla'),(35,'Irem'),
 (36,'Buse'),(37,'Kubra'),(38,'Sevgi'),(39,'Songul'),(40,'Nazli')
) AS v (Ord, Name);

SELECT Ord, Surname INTO #Surname FROM (VALUES
 (1,'Yilmaz'),(2,'Kaya'),(3,'Demir'),(4,'Sahin'),(5,'Celik'),(6,'Yildiz'),(7,'Yildirim'),
 (8,'Ozturk'),(9,'Aydin'),(10,'Ozdemir'),(11,'Arslan'),(12,'Dogan'),(13,'Kilic'),(14,'Aslan'),
 (15,'Cetin'),(16,'Kara'),(17,'Koc'),(18,'Kurt'),(19,'Ozkan'),(20,'Simsek'),(21,'Polat'),
 (22,'Ozer'),(23,'Korkmaz'),(24,'Cakir'),(25,'Erdogan'),(26,'Yavuz'),(27,'Can'),(28,'Acar'),
 (29,'Sen'),(30,'Aktas'),(31,'Guler'),(32,'Yalcin'),(33,'Gunes'),(34,'Bozkurt'),(35,'Bulut'),
 (36,'Keskin'),(37,'Unal'),(38,'Turan'),(39,'Gul'),(40,'Ozgur'),(41,'Ince'),(42,'Tekin'),
 (43,'Kaplan'),(44,'Ucar'),(45,'Sari'),(46,'Avci'),(47,'Tunc'),(48,'Karaca'),(49,'Coskun'),
 (50,'Akin')
) AS v (Ord, Surname);

DECLARE @MaleCnt    INT = (SELECT COUNT(*) FROM #MaleName);
DECLARE @FemaleCnt  INT = (SELECT COUNT(*) FROM #FemaleName);
DECLARE @SurnameCnt INT = (SELECT COUNT(*) FROM #Surname);

DROP TABLE IF EXISTS #D;
CREATE TABLE #D (
    N INT PRIMARY KEY,
    kSex FLOAT, kAge FLOAT, kBlood FLOAT, kType FLOAT, kRegion FLOAT, kHosp FLOAT,
    rBirth FLOAT, rFirst FLOAT, rLast FLOAT, rPhone FLOAT, rTckn FLOAT,
    rEmail FLOAT, rCount FLOAT, rLatest FLOAT,
    Sex CHAR(1), AgeBand TINYINT, BloodGroup VARCHAR(3), DonorType VARCHAR(11),
    Region VARCHAR(25), HospitalID INT, BirthDate DATE, WinLen INT, DonationCount TINYINT,
    TCKN CHAR(11), Name VARCHAR(50), Surname VARCHAR(50), Phone VARCHAR(20), Email VARCHAR(100)
);

INSERT INTO #D (N, kSex, kAge, kBlood, kType, kRegion, kHosp, rBirth, rFirst, rLast,
                rPhone, rTckn, rEmail, rCount, rLatest)
SELECT TOP (1000)
       ROW_NUMBER() OVER (ORDER BY (SELECT NULL)),
       RAND(CHECKSUM(NEWID())), RAND(CHECKSUM(NEWID())), RAND(CHECKSUM(NEWID())),
       RAND(CHECKSUM(NEWID())), RAND(CHECKSUM(NEWID())), RAND(CHECKSUM(NEWID())),
       RAND(CHECKSUM(NEWID())), RAND(CHECKSUM(NEWID())), RAND(CHECKSUM(NEWID())),
       RAND(CHECKSUM(NEWID())), RAND(CHECKSUM(NEWID())), RAND(CHECKSUM(NEWID())),
       RAND(CHECKSUM(NEWID())), RAND(CHECKSUM(NEWID()))
FROM sys.all_objects AS a CROSS JOIN sys.all_objects AS b;

WITH r AS (SELECT N, ROW_NUMBER() OVER (ORDER BY kSex) AS Rn FROM #D),
     q AS (SELECT Sex, Cnt, SUM(Cnt) OVER (ORDER BY Ord ROWS UNBOUNDED PRECEDING) AS ToRn FROM #QSex)
UPDATE d SET Sex = q.Sex
FROM #D AS d JOIN r ON r.N = d.N JOIN q ON r.Rn BETWEEN q.ToRn - q.Cnt + 1 AND q.ToRn;

WITH r AS (SELECT N, ROW_NUMBER() OVER (ORDER BY kAge) AS Rn FROM #D),
     q AS (SELECT AgeBand, Cnt, SUM(Cnt) OVER (ORDER BY Ord ROWS UNBOUNDED PRECEDING) AS ToRn FROM #QAge)
UPDATE d SET AgeBand = q.AgeBand
FROM #D AS d JOIN r ON r.N = d.N JOIN q ON r.Rn BETWEEN q.ToRn - q.Cnt + 1 AND q.ToRn;

WITH r AS (SELECT N, ROW_NUMBER() OVER (ORDER BY kBlood) AS Rn FROM #D),
     q AS (SELECT BloodGroup, Cnt, SUM(Cnt) OVER (ORDER BY Ord ROWS UNBOUNDED PRECEDING) AS ToRn FROM #QBlood)
UPDATE d SET BloodGroup = q.BloodGroup
FROM #D AS d JOIN r ON r.N = d.N JOIN q ON r.Rn BETWEEN q.ToRn - q.Cnt + 1 AND q.ToRn;

WITH r AS (SELECT N, ROW_NUMBER() OVER (ORDER BY kType) AS Rn FROM #D),
     q AS (SELECT DonorType, Cnt, SUM(Cnt) OVER (ORDER BY Ord ROWS UNBOUNDED PRECEDING) AS ToRn FROM #QType)
UPDATE d SET DonorType = q.DonorType
FROM #D AS d JOIN r ON r.N = d.N JOIN q ON r.Rn BETWEEN q.ToRn - q.Cnt + 1 AND q.ToRn;

WITH r AS (SELECT N, ROW_NUMBER() OVER (ORDER BY kRegion) AS Rn FROM #D),
     q AS (SELECT Region, Cnt, SUM(Cnt) OVER (ORDER BY Ord ROWS UNBOUNDED PRECEDING) AS ToRn FROM #QRegion)
UPDATE d SET Region = q.Region
FROM #D AS d JOIN r ON r.N = d.N JOIN q ON r.Rn BETWEEN q.ToRn - q.Cnt + 1 AND q.ToRn;

WITH h AS (SELECT h.HospitalID, c.Region,
                  ROW_NUMBER() OVER (PARTITION BY c.Region ORDER BY h.HospitalID) AS HRn,
                  COUNT(*)     OVER (PARTITION BY c.Region)                       AS HCnt
           FROM Hospitals AS h JOIN Cities AS c ON c.CityID = h.CityID),
     dr AS (SELECT N, Region, ROW_NUMBER() OVER (PARTITION BY Region ORDER BY kHosp) AS DRn FROM #D)
UPDATE d SET HospitalID = h.HospitalID
FROM #D AS d
JOIN dr ON dr.N = d.N
JOIN h  ON h.Region = dr.Region AND h.HRn = ((dr.DRn - 1) % h.HCnt) + 1;

UPDATE d
SET BirthDate = DATEADD(DAY, -CAST(FLOOR(d.rBirth * (DATEDIFF(DAY, x.Oldest, x.Youngest) + 1)) AS INT), x.Youngest)
FROM #D AS d
JOIN #QAge AS q ON q.AgeBand = d.AgeBand
CROSS APPLY (SELECT DATEADD(YEAR, -q.MinAge, DATEADD(DAY, -1, @Today))      AS Youngest,
                    DATEADD(DAY, 1, DATEADD(YEAR, -(q.MaxAge + 1), @Today)) AS Oldest) AS x;

UPDATE #D
SET WinLen = DATEDIFF(DAY,
                      CASE WHEN DATEADD(YEAR, 18, BirthDate) > @WindowStart
                           THEN DATEADD(YEAR, 18, BirthDate) ELSE @WindowStart END,
                      @WindowEnd);

UPDATE #D
SET DonationCount = CASE WHEN DonorType = 'Replacement' THEN 1
                         WHEN rCount < 0.55 THEN 1
                         WHEN rCount < 0.80 THEN 2
                         WHEN rCount < 0.92 THEN 3
                         WHEN Sex = 'F'     THEN 3
                         ELSE 4 END;

UPDATE d
SET Name = CASE d.Sex
               WHEN 'M' THEN (SELECT m.Name FROM #MaleName   AS m WHERE m.Ord = 1 + CAST(FLOOR(d.rFirst * @MaleCnt)   AS INT))
               ELSE          (SELECT f.Name FROM #FemaleName AS f WHERE f.Ord = 1 + CAST(FLOOR(d.rFirst * @FemaleCnt) AS INT))
           END,
    Surname = (SELECT s.Surname FROM #Surname AS s WHERE s.Ord = 1 + CAST(FLOOR(d.rLast * @SurnameCnt) AS INT))
FROM #D AS d;

UPDATE d
SET TCKN = CONCAT(p.Prefix, (s.DigitSum + 1) % 10)
FROM #D AS d
CROSS APPLY (SELECT CAST(1000000000
                         + CAST(d.N - 1 AS BIGINT) * 8000000
                         + CAST(FLOOR(d.rTckn * 8000000) AS BIGINT) AS VARCHAR(10)) AS Prefix) AS p
CROSS APPLY (SELECT CAST(SUBSTRING(p.Prefix, 1, 1) AS INT) + CAST(SUBSTRING(p.Prefix, 2, 1) AS INT)
                  + CAST(SUBSTRING(p.Prefix, 3, 1) AS INT) + CAST(SUBSTRING(p.Prefix, 4, 1) AS INT)
                  + CAST(SUBSTRING(p.Prefix, 5, 1) AS INT) + CAST(SUBSTRING(p.Prefix, 6, 1) AS INT)
                  + CAST(SUBSTRING(p.Prefix, 7, 1) AS INT) + CAST(SUBSTRING(p.Prefix, 8, 1) AS INT)
                  + CAST(SUBSTRING(p.Prefix, 9, 1) AS INT) + CAST(SUBSTRING(p.Prefix, 10, 1) AS INT)
                  AS DigitSum) AS s;

UPDATE #D
SET Phone = CONCAT('0500', RIGHT(CONCAT('0000000', CAST(FLOOR(rPhone * 10000000) AS INT)), 7)),
    Email = CASE WHEN rEmail < 0.60
                 THEN LOWER(CONCAT(Name, '.', Surname, N, '@example.com')) END;

INSERT INTO Donors (TCKN, DonorName, Surname, BirthDate, BloodGroup, Phone, Email, DonorType)
SELECT TCKN, Name, Surname, BirthDate, BloodGroup, Phone, Email, DonorType
FROM #D;

DROP TABLE IF EXISTS #DS;
CREATE TABLE #DS (N INT, Seq INT, Gap INT, DayOffset INT, rTime FLOAT, DonationDate DATETIME);

INSERT INTO #DS (N, Seq, Gap, rTime)
SELECT d.N, s.Seq,
       CASE WHEN s.Seq = 1 THEN 0
            ELSE CASE d.Sex WHEN 'M' THEN 90 ELSE 120 END + CAST(FLOOR(RAND(CHECKSUM(NEWID())) * 90) AS INT)
       END,
       RAND(CHECKSUM(NEWID()))
FROM #D AS d
JOIN (VALUES (1), (2), (3), (4)) AS s (Seq) ON s.Seq <= d.DonationCount;

UPDATE s
SET DayOffset = x.NewOffset
FROM #DS AS s
JOIN (SELECT N, Seq,
             SUM(Gap) OVER (PARTITION BY N ORDER BY Seq ROWS UNBOUNDED PRECEDING) AS NewOffset
      FROM #DS) AS x
  ON x.N = s.N AND x.Seq = s.Seq;

DELETE s
FROM #DS AS s JOIN #D AS d ON d.N = s.N
WHERE s.DayOffset > d.WinLen;

WITH m AS (SELECT N, MAX(DayOffset) AS MaxOffset FROM #DS GROUP BY N)
UPDATE s
SET DonationDate = DATEADD(MINUTE, 510 + CAST(FLOOR(s.rTime * 540) AS INT),
                           CAST(DATEADD(DAY, -(x.Shift + s.DayOffset), @WindowEnd) AS DATETIME))
FROM #DS AS s
JOIN #D  AS d ON d.N = s.N
JOIN m        ON m.N = s.N
CROSS APPLY (SELECT CAST(FLOOR(d.rLatest * (d.WinLen - m.MaxOffset + 1)) AS INT) AS Shift) AS x;

INSERT INTO Donations (DonationDate, Units, Notes, DonorTCKN, HospitalID)
SELECT s.DonationDate, 1,
       CASE WHEN d.DonorType = 'Replacement' THEN 'Replacement donation for a patient'
            ELSE 'Routine donation' END,
       d.TCKN, d.HospitalID
FROM #DS AS s JOIN #D AS d ON d.N = s.N
ORDER BY s.DonationDate;

DROP TABLE IF EXISTS #DonR, #U;

SELECT dn.DonationID, dn.HospitalID, d.BloodGroup,
       CAST(dn.DonationDate AS DATE) AS CollDate,
       RAND(CHECKSUM(NEWID())) AS rPlasma,
       RAND(CHECKSUM(NEWID())) AS rPlatelet,
       RAND(CHECKSUM(NEWID())) AS rTest
INTO #DonR
FROM Donations AS dn JOIN Donors AS d ON d.TCKN = dn.DonorTCKN;

CREATE TABLE #U (
    DonationID INT, HospitalID INT, ComponentType VARCHAR(9), BloodGroup VARCHAR(3),
    CollDate DATE, ExpirationDate DATE, TestStatus VARCHAR(7), UnitStatus VARCHAR(9),
    rUse FLOAT, rReserve FLOAT, rDay FLOAT, rTime FLOAT, rDept FLOAT, rPatient FLOAT,
    UsageDate DATETIME, Department VARCHAR(20), PatientID INT
);

INSERT INTO #U (DonationID, HospitalID, ComponentType, BloodGroup, CollDate, ExpirationDate, TestStatus,
                rUse, rReserve, rDay, rTime, rDept, rPatient)
SELECT r.DonationID, r.HospitalID, c.ComponentType, r.BloodGroup, r.CollDate,
       CASE c.ComponentType
            WHEN 'Red_Cells' THEN DATEADD(DAY, 42, r.CollDate)
            WHEN 'Platelets' THEN DATEADD(DAY, 5, r.CollDate)
            ELSE                  DATEADD(MONTH, 36, r.CollDate)
       END,
       CASE WHEN r.CollDate >= DATEADD(DAY, -2, @Today) THEN 'Pending'
            WHEN r.rTest < 0.015 THEN 'Failed'
            ELSE 'Tested' END,
       RAND(CHECKSUM(NEWID())), RAND(CHECKSUM(NEWID())), RAND(CHECKSUM(NEWID())),
       RAND(CHECKSUM(NEWID())), RAND(CHECKSUM(NEWID())), RAND(CHECKSUM(NEWID()))
FROM #DonR AS r
JOIN (VALUES ('Red_Cells'), ('Plasma'), ('Platelets')) AS c (ComponentType)
  ON  c.ComponentType = 'Red_Cells'
  OR (c.ComponentType = 'Plasma'    AND r.rPlasma   < 0.90)
  OR (c.ComponentType = 'Platelets' AND r.rPlatelet < 0.30);

UPDATE u
SET UnitStatus = CASE
        WHEN u.TestStatus = 'Failed'  THEN 'Discarded'
        WHEN u.TestStatus = 'Pending' THEN 'Available'
        WHEN u.ExpirationDate < @Today
             THEN CASE WHEN u.rUse < CASE u.ComponentType WHEN 'Platelets' THEN 0.85 ELSE 0.95 END
                       THEN 'Used' ELSE 'Expired' END
        WHEN u.rUse < p.UsedShare THEN 'Used'
        WHEN u.rReserve < 0.05    THEN 'Reserved'
        ELSE 'Available'
    END
FROM #U AS u
CROSS APPLY (SELECT DATEDIFF(DAY, u.CollDate, @Today) AS AgeDays) AS a
CROSS APPLY (SELECT CASE u.ComponentType
                         WHEN 'Red_Cells' THEN CASE WHEN a.AgeDays / 30.0  > 0.95 THEN 0.95 ELSE a.AgeDays / 30.0  END
                         WHEN 'Platelets' THEN CASE WHEN a.AgeDays / 4.0   > 0.85 THEN 0.85 ELSE a.AgeDays / 4.0   END
                         ELSE                  CASE WHEN a.AgeDays / 365.0 > 0.70 THEN 0.70 ELSE a.AgeDays / 365.0 END
                    END AS UsedShare) AS p;

DROP TABLE IF EXISTS #Dept;
CREATE TABLE #Dept (ComponentType VARCHAR(9), Department VARCHAR(20), FromPct INT, ToPct INT);
INSERT INTO #Dept VALUES
 ('Red_Cells', 'General Surgery',  0, 21), ('Red_Cells', 'Intensive Care', 22, 39),
 ('Red_Cells', 'Hematology',      40, 53), ('Red_Cells', 'Oncology',       54, 65),
 ('Red_Cells', 'Emergency',       66, 75), ('Red_Cells', 'Orthopedics',    76, 83),
 ('Red_Cells', 'Cardiology',      84, 90), ('Red_Cells', 'Obstetrics',     91, 95),
 ('Red_Cells', 'Pediatrics',      96, 99),
 ('Plasma',    'Intensive Care',   0, 29), ('Plasma',    'General Surgery', 30, 54),
 ('Plasma',    'Cardiology',      55, 74), ('Plasma',    'Emergency',       75, 89),
 ('Plasma',    'Obstetrics',      90, 94), ('Plasma',    'Pediatrics',      95, 99),
 ('Platelets', 'Hematology',       0, 39), ('Platelets', 'Oncology',        40, 69),
 ('Platelets', 'Intensive Care',  70, 84), ('Platelets', 'Cardiology',      85, 94),
 ('Platelets', 'Pediatrics',      95, 99);

UPDATE u
SET UsageDate  = DATEADD(MINUTE, CAST(FLOOR(u.rTime * 1440) AS INT),
                         CAST(DATEADD(DAY,
                                      CAST(FLOOR(u.rDay * (DATEDIFF(DAY, f.FirstDay, l.LastDay) + 1)) AS INT),
                                      f.FirstDay) AS DATETIME)),
    Department = dp.Department,
    PatientID  = u.HospitalID * 1000 + 1 + CAST(FLOOR(u.rPatient * 30) AS INT)
FROM #U AS u
CROSS APPLY (SELECT DATEADD(DAY, 1, u.CollDate) AS FirstDay) AS f
CROSS APPLY (SELECT CASE WHEN u.ExpirationDate < @WindowEnd THEN u.ExpirationDate ELSE @WindowEnd END AS LastDay) AS l
JOIN #Dept AS dp
  ON dp.ComponentType = u.ComponentType
 AND CAST(FLOOR(u.rDept * 100) AS INT) BETWEEN dp.FromPct AND dp.ToPct
WHERE u.UnitStatus = 'Used';

INSERT INTO BloodUnit (BloodGroup, ExpirationDate, TestStatus, UnitStatus, ComponentType, DonationID)
SELECT BloodGroup, ExpirationDate, TestStatus, UnitStatus, ComponentType, DonationID
FROM #U
ORDER BY DonationID, CASE ComponentType WHEN 'Red_Cells' THEN 1 WHEN 'Plasma' THEN 2 ELSE 3 END;

INSERT INTO UnitUsage (UsageDate, Department, PatientID, UnitID)
SELECT u.UsageDate, u.Department, u.PatientID, b.UnitID
FROM #U AS u
JOIN BloodUnit AS b ON b.DonationID = u.DonationID AND b.ComponentType = u.ComponentType
WHERE u.UnitStatus = 'Used'
ORDER BY u.UsageDate;

INSERT INTO BloodInventory (HospitalID, BloodGroup, Units, CriticalLevel, LastUpdated)
SELECT h.HospitalID, q.BloodGroup,
       CAST(ROUND(t.Target * f.Factor, 0) AS INT),
       CASE WHEN CEILING(t.Target * 3.0 / 7) < 1 THEN 1 ELSE CEILING(t.Target * 3.0 / 7) END,
       DATEADD(MINUTE, -CAST(FLOOR(f.rUpd * 1440) AS INT), GETDATE())
FROM Hospitals AS h
CROSS JOIN #QBlood AS q
CROSS APPLY (SELECT CEILING(CASE h.HospitalType WHEN 'University' THEN 300
                                                WHEN 'State'      THEN 150
                                                ELSE 60 END * q.Share) AS Target) AS t
CROSS APPLY (SELECT RAND(CHECKSUM(NEWID(), h.HospitalID, q.Ord))     AS r1,
                    RAND(CHECKSUM(NEWID(), q.Ord, h.HospitalID, 7))  AS rUpd) AS rnd
CROSS APPLY (SELECT CASE WHEN q.BloodGroup LIKE '%-'
                         THEN 0.2 + rnd.r1 * 1.1
                         ELSE 0.3 + rnd.r1 * 1.2
                    END AS Factor, rnd.rUpd) AS f;

SELECT 'Cities' AS TableName, COUNT(*) AS RowCnt FROM Cities
UNION ALL SELECT 'Hospitals',      COUNT(*) FROM Hospitals
UNION ALL SELECT 'Donors',         COUNT(*) FROM Donors
UNION ALL SELECT 'Donations',      COUNT(*) FROM Donations
UNION ALL SELECT 'BloodInventory', COUNT(*) FROM BloodInventory
UNION ALL SELECT 'BloodUnit',      COUNT(*) FROM BloodUnit
UNION ALL SELECT 'UnitUsage',      COUNT(*) FROM UnitUsage;

WITH tgt AS (
    SELECT * FROM (VALUES
        ('Sex (by first name)', 'M', 84.6), ('Sex (by first name)', 'F', 15.4),
        ('Age group', '18-24', 21.3), ('Age group', '25-44', 52.3), ('Age group', '45-65', 26.5),
        ('Blood group', 'A+', 37.1), ('Blood group', 'A-', 5.0), ('Blood group', 'B+', 14.4),
        ('Blood group', 'B-', 1.9), ('Blood group', 'AB+', 6.6), ('Blood group', 'AB-', 0.9),
        ('Blood group', 'O+', 29.7), ('Blood group', 'O-', 4.2),
        ('Region', 'Marmara', 29.1), ('Region', 'Aegean', 15.8), ('Region', 'Central Anatolia', 14.8),
        ('Region', 'Mediterranean', 14.3), ('Region', 'Black Sea', 10.1),
        ('Region', 'Southeastern Anatolia', 8.1), ('Region', 'Eastern Anatolia', 7.8),
        ('Donor type', 'Volunteer', 90.0), ('Donor type', 'Replacement', 10.0)
    ) AS t (Attribute, Value, TargetPct)
),
act AS (
    SELECT 'Sex (by first name)' AS Attribute,
           CASE WHEN EXISTS (SELECT 1 FROM #MaleName AS m WHERE m.Name = d.DonorName) THEN 'M' ELSE 'F' END AS Value
    FROM Donors AS d
    UNION ALL
    SELECT 'Age group',
           CASE WHEN a.Age <= 24 THEN '18-24' WHEN a.Age <= 44 THEN '25-44' ELSE '45-65' END
    FROM Donors AS d
    CROSS APPLY (SELECT DATEDIFF(YEAR, d.BirthDate, GETDATE())
                        - CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, d.BirthDate, GETDATE()), d.BirthDate)
                                    > CAST(GETDATE() AS DATE) THEN 1 ELSE 0 END AS Age) AS a
    UNION ALL
    SELECT 'Blood group', BloodGroup FROM Donors
    UNION ALL
    SELECT 'Region', c.Region
    FROM Donors AS d
    CROSS APPLY (SELECT TOP (1) dn.HospitalID FROM Donations AS dn
                 WHERE dn.DonorTCKN = d.TCKN ORDER BY dn.DonationDate) AS f
    JOIN Hospitals AS h ON h.HospitalID = f.HospitalID
    JOIN Cities    AS c ON c.CityID = h.CityID
    UNION ALL
    SELECT 'Donor type', DonorType FROM Donors
)
SELECT t.Attribute, t.Value, t.TargetPct,
       CAST(100.0 * COUNT(a.Value) / (SELECT COUNT(*) FROM Donors) AS DECIMAL(5, 1)) AS ActualPct,
       CAST(100.0 * COUNT(a.Value) / (SELECT COUNT(*) FROM Donors) - t.TargetPct AS DECIMAL(5, 1)) AS Difference
FROM tgt AS t
LEFT JOIN act AS a ON a.Attribute = t.Attribute AND a.Value = t.Value
GROUP BY t.Attribute, t.Value, t.TargetPct
ORDER BY t.Attribute, t.TargetPct DESC;

SELECT 'Donation before the donor turned 18' AS RuleCheck, COUNT(*) AS Violations
FROM Donations AS dn JOIN Donors AS d ON d.TCKN = dn.DonorTCKN
WHERE CAST(dn.DonationDate AS DATE) < DATEADD(YEAR, 18, d.BirthDate)
UNION ALL
SELECT 'Two donations less than 90 days apart', COUNT(*)
FROM (SELECT DonationDate,
             LAG(DonationDate) OVER (PARTITION BY DonorTCKN ORDER BY DonationDate) AS PrevDate
      FROM Donations) AS x
WHERE x.PrevDate IS NOT NULL AND DATEDIFF(DAY, x.PrevDate, x.DonationDate) < 90
UNION ALL
SELECT 'More than 4 donations in 12 months', COUNT(*)
FROM (SELECT DonorTCKN FROM Donations GROUP BY DonorTCKN HAVING COUNT(*) > 4) AS x
UNION ALL
SELECT 'Unit blood group differs from donor', COUNT(*)
FROM BloodUnit AS bu
JOIN Donations AS dn ON dn.DonationID = bu.DonationID
JOIN Donors    AS d  ON d.TCKN = dn.DonorTCKN
WHERE bu.BloodGroup <> d.BloodGroup
UNION ALL
SELECT 'Used before collection or after expiration', COUNT(*)
FROM UnitUsage AS uu
JOIN BloodUnit AS bu ON bu.UnitID = uu.UnitID
JOIN Donations AS dn ON dn.DonationID = bu.DonationID
WHERE uu.UsageDate <= dn.DonationDate OR CAST(uu.UsageDate AS DATE) > bu.ExpirationDate
UNION ALL
SELECT 'Used status without usage record (or the opposite)', COUNT(*)
FROM BloodUnit AS bu LEFT JOIN UnitUsage AS uu ON uu.UnitID = bu.UnitID
WHERE (bu.UnitStatus = 'Used' AND uu.UnitID IS NULL)
   OR (bu.UnitStatus <> 'Used' AND uu.UnitID IS NOT NULL)
UNION ALL
SELECT 'Used unit without a passed test', COUNT(*)
FROM UnitUsage AS uu JOIN BloodUnit AS bu ON bu.UnitID = uu.UnitID
WHERE bu.TestStatus <> 'Tested'
UNION ALL
SELECT 'Available unit already expired', COUNT(*)
FROM BloodUnit
WHERE UnitStatus IN ('Available', 'Reserved') AND ExpirationDate < CAST(GETDATE() AS DATE);

DROP TABLE IF EXISTS #QSex, #QAge, #QBlood, #QType, #QRegion, #MaleName, #FemaleName, #Surname,
                     #D, #DS, #DonR, #U, #Dept;
GO

IF OBJECT_ID('trg_UpdateInventoryOnDonation', 'TR') IS NOT NULL
    ENABLE TRIGGER trg_UpdateInventoryOnDonation ON Donations;
IF OBJECT_ID('trg_CheckExpirationDate', 'TR') IS NOT NULL
    ENABLE TRIGGER trg_CheckExpirationDate ON BloodUnit;
GO