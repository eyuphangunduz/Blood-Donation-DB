USE BloodDonation;
GO

-- 1. Critical stock detection
SELECT h.HospitalName, c.CityName, bi.BloodGroup, bi.Units, bi.CriticalLevel
FROM BloodInventory AS bi
JOIN Hospitals AS h ON h.HospitalID = bi.HospitalID
JOIN Cities    AS c ON c.CityID = h.CityID
WHERE bi.Units <= bi.CriticalLevel
ORDER BY bi.Units;

-- 2. Donor history reporting
SELECT d.TCKN,
       d.DonorName + ' ' + d.Surname AS FullName,
       d.BloodGroup,
       dn.DonationDate,
       dn.Units,
       h.HospitalName,
       c.CityName
FROM Donors    AS d
JOIN Donations AS dn ON dn.DonorID = d.DonorID
JOIN Hospitals AS h  ON h.HospitalID = dn.HospitalID
JOIN Cities    AS c  ON c.CityID = h.CityID
ORDER BY d.DonorID, dn.DonationDate;

-- 3. Blood group distribution analysis
SELECT BloodGroup,
       COUNT(*) AS DonorCount,
       CAST(100.0 * COUNT(*) / SUM(COUNT(*)) OVER () AS DECIMAL(5, 1)) AS Percentage
FROM Donors
GROUP BY BloodGroup
ORDER BY DonorCount DESC;

-- 4. Location-based inventory evaluation
SELECT c.Region, c.CityName, bi.BloodGroup, SUM(bi.Units) AS TotalUnits
FROM BloodInventory AS bi
JOIN Hospitals AS h ON h.HospitalID = bi.HospitalID
JOIN Cities    AS c ON c.CityID = h.CityID
GROUP BY c.Region, c.CityName, bi.BloodGroup
ORDER BY c.Region, c.CityName, TotalUnits DESC;
GO