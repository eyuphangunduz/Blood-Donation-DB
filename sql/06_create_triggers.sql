CREATE TRIGGER trg_UpdateInventoryOnDonation
ON Donations
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE bi
    SET bi.Units = bi.Units + i.Units,
        bi.LastUpdated = GETDATE()
    FROM BloodInventory bi
    INNER JOIN inserted i ON bi.HospitalID = i.HospitalID;
END;
GO

CREATE TRIGGER trg_CheckExpirationDate
ON BloodUnit
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE bu
    SET bu.UnitStatus = 'Expired'
    FROM BloodUnit bu
    INNER JOIN inserted i ON bu.UnitID = i.UnitID
    WHERE bu.ExpirationDate < CAST(GETDATE() AS DATE)
      AND bu.UnitStatus <> 'Expired';
END;
GO