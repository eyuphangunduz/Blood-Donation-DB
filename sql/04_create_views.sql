USE BloodDonation;
GO

CREATE OR ALTER VIEW vw_AvailableBloodUnits AS
SELECT 
    bu.UnitID,
    bu.BloodGroup,
    bu.ComponentType,
    bu.ExpirationDate,
    h.HospitalName,
    c.CityName
FROM BloodUnit bu
INNER JOIN Donations d ON bu.DonationID = d.DonationID
INNER JOIN Hospitals h ON d.HospitalID = h.HospitalID
INNER JOIN Cities c ON h.CityID = c.CityID
WHERE bu.TestStatus = 'Tested' AND bu.UnitStatus = 'Available';
GO

CREATE OR ALTER VIEW vw_DonorDonationHistory AS
SELECT 
    d.TCKN,
    d.DonorName + ' ' + d.Surname AS FullName,
    d.BloodGroup,
    don.DonationDate,
    don.Units,
    h.HospitalName,
    don.Notes
FROM Donors d
INNER JOIN Donations don ON d.TCKN = don.DonorTCKN
INNER JOIN Hospitals h ON don.HospitalID = h.HospitalID;
GO

CREATE OR ALTER VIEW vw_HospitalInventoryStatus AS
SELECT 
    h.HospitalName,
    bi.BloodGroup,
    bi.Units AS CurrentStock,
    bi.CriticalLevel,
    CASE 
        WHEN bi.Units <= bi.CriticalLevel THEN 'CRITICAL'
        ELSE 'SUFFICIENT'
    END AS StockStatus,
    bi.LastUpdated
FROM BloodInventory bi
INNER JOIN Hospitals h ON bi.HospitalID = h.HospitalID;
GO