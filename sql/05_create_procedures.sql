CREATE PROCEDURE sp_RegisterDonor
    @DonorName VARCHAR(50),
    @Surname VARCHAR(50),
    @BirthDate DATE,
    @BloodGroup VARCHAR(5),
    @Phone VARCHAR(20),
    @Email VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO Donors (DonorName, Surname, BirthDate, BloodGroup, Phone, Email)
    VALUES (@DonorName, @Surname, @BirthDate, @BloodGroup, @Phone, @Email);
    
    PRINT 'Donor registered successfully.';
END;
GO

CREATE PROCEDURE sp_RecordDonation
    @DonorID INT,
    @HospitalID INT,
    @DonationDate DATE,
    @Units INT,
    @Notes VARCHAR(250)
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO Donations (DonorID, HospitalID, DonationDate, Units, Notes)
    VALUES (@DonorID, @HospitalID, @DonationDate, @Units, @Notes);
    
    PRINT 'Donation recorded successfully.';
END;
GO