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
          JOIN Donors AS d ON d.DonorID = i.DonorID
          GROUP BY i.HospitalID, d.BloodGroup) AS n
      ON n.HospitalID = bi.HospitalID AND n.BloodGroup = bi.BloodGroup;

    INSERT INTO BloodInventory (HospitalID, BloodGroup, Units, CriticalLevel, LastUpdated)
    SELECT i.HospitalID, d.BloodGroup, SUM(i.Units), 1, GETDATE()
    FROM inserted AS i
    JOIN Donors AS d ON d.DonorID = i.DonorID
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
      AND bu.UnitStatus <> 'Expired';
END;
GO