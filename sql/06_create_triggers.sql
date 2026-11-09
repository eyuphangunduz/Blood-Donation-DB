USE BloodDonation;
GO

CREATE OR ALTER TRIGGER trg_UpdateInventoryOnDonation
ON Donations
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE bi
    SET bi.Units = bi.Units + n.AddedUnits,
        bi.LastUpdated = GETDATE()
    FROM BloodInventory AS bi
    JOIN (SELECT i.HospitalID, d.BloodGroup, SUM(i.Units) AS AddedUnits
          FROM inserted AS i
          JOIN Donors AS d ON d.TCKN = i.DonorTCKN
          GROUP BY i.HospitalID, d.BloodGroup) AS n
      ON n.HospitalID = bi.HospitalID AND n.BloodGroup = bi.BloodGroup;

    INSERT INTO BloodInventory (HospitalID, BloodGroup, Units, CriticalLevel, LastUpdated)
    SELECT i.HospitalID, d.BloodGroup, SUM(i.Units), 1, GETDATE()
    FROM inserted AS i
    JOIN Donors AS d ON d.TCKN = i.DonorTCKN
    WHERE NOT EXISTS (SELECT 1 FROM BloodInventory AS bi
                      WHERE bi.HospitalID = i.HospitalID AND bi.BloodGroup = d.BloodGroup)
    GROUP BY i.HospitalID, d.BloodGroup;
END;
GO

CREATE OR ALTER TRIGGER trg_CheckExpirationDate
ON BloodUnit
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE bu
    SET bu.UnitStatus = 'Expired'
    FROM BloodUnit AS bu
    INNER JOIN inserted AS i ON bu.UnitID = i.UnitID
    WHERE bu.ExpirationDate < CAST(GETDATE() AS DATE)
      AND bu.UnitStatus IN ('Available', 'Reserved');
END;
GO

CREATE OR ALTER TRIGGER trg_CheckDonationRules
ON Donations
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM inserted i
               JOIN Donors d ON d.TCKN = i.DonorTCKN
               WHERE i.DonationDate <  DATEADD(YEAR, 18, d.BirthDate)
                  OR i.DonationDate >= DATEADD(YEAR, 66, d.BirthDate))
    BEGIN
        ROLLBACK;
        THROW 50001, 'Donor must be between 18 and 65 years old.', 1;
    END;

    IF EXISTS (SELECT 1 FROM inserted i
               JOIN Donations dn ON dn.DonorTCKN = i.DonorTCKN AND dn.DonationID <> i.DonationID
               WHERE ABS(DATEDIFF(DAY, dn.DonationDate, i.DonationDate)) < 90)
    BEGIN
        ROLLBACK;
        THROW 50002, 'At least 90 days must pass between two donations.', 1;
    END;

    IF EXISTS (SELECT 1 FROM inserted i
               JOIN Donations dn ON dn.DonorTCKN = i.DonorTCKN
               WHERE dn.DonationDate >  DATEADD(YEAR, -1, i.DonationDate)
                 AND dn.DonationDate <= i.DonationDate
               GROUP BY i.DonationID
               HAVING COUNT(*) > 4)
    BEGIN
        ROLLBACK;
        THROW 50003, 'A donor can donate at most 4 times in 12 months.', 1;
    END;
END;
GO