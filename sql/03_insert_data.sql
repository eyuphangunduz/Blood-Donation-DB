USE BloodDonation;
GO

INSERT INTO Cities (CityName, Region) VALUES 
('Istanbul', 'Marmara'),
('Ankara', 'Central Anatolia'),
('Izmir', 'Aegean');

INSERT INTO Hospitals (HospitalName, hospitalAddress, Phone, HospitalType, CityID) VALUES 
('Cerrahpasa Medical Faculty Hospital', 'Fatih, Istanbul', '02124143000', 'University', 1),
('Ankara City Hospital', 'Cankaya, Ankara', '03125524300', 'State', 2),
('Izmir Private Kent Hospital', 'Cigli, Izmir', '02323867050', 'Private', 3);

INSERT INTO Donors (TCKN, DonorName, Surname, BirthDate, BloodGroup, Phone, Email, DonorType) VALUES 
('55544433322', 'Can', 'Kaya', '1988-11-15', 'AB+', '05359998877', 'can.kaya@example.com', 'Volunteer'),
('77788899911', 'Elif', 'Ozturk', '1997-03-24', 'O-', '05362223344', 'elif.ozturk@example.com', 'Volunteer'),
('12345678901', 'Ahmet', 'Yilmaz', '1995-05-12', 'A+', '05321112233', 'ahmet@example.com', 'Volunteer'),
('98765432109', 'Mehmet', 'Demir', '1990-08-20', 'O+', '05334445566', 'mehmet@example.com', 'Replacement');

INSERT INTO Donations (DonationDate, Units, Notes, DonorID, HospitalID) VALUES 
(GETDATE(), 1, 'Routine donation', 1, 1),
(GETDATE(), 1, 'Emergency operation request', 2, 2),
(GETDATE(), 1, 'First time donor', 3, 1),
(GETDATE(), 1, 'Regular donation', 4, 3);

INSERT INTO BloodInventory (HospitalID, BloodGroup, Units, CriticalLevel, LastUpdated) VALUES 
(1, 'A+', 15, 5, GETDATE()),
(1, 'O+', 8, 5, GETDATE()),
(1, 'AB+', 10, 3, GETDATE()),
(2, 'B+', 4, 5, GETDATE()),
(3, 'O-', 6, 2, GETDATE());

INSERT INTO BloodUnit (BloodGroup, ExpirationDate, TestStatus, UnitStatus, ComponentType, DonationID) VALUES 
('AB+', '2026-12-10', 'Tested', 'Available', 'Platelets', 1),
('O-', '2026-11-30', 'Tested', 'Available', 'Red_Cells', 2),
('A+', '2026-12-01', 'Tested', 'Available', 'Red_Cells', 3),
('O+', '2026-11-25', 'Tested', 'Available', 'Plasma', 4);

INSERT INTO UnitUsage (UsageDate, Department, PatientID, UnitID) VALUES 
(GETDATE(), 'Emergency Surgery', 101, 3);