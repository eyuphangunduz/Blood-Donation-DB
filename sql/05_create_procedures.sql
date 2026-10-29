USE BloodDonation;
GO

CREATE OR ALTER PROCEDURE sp_RegisterDonor
    @TCKN       CHAR(11),
    @DonorName  VARCHAR(50),
    @Surname    VARCHAR(50),
    @BirthDate  DATE,
    @BloodGroup VARCHAR(5),
    @Phone      VARCHAR(20),
    @Email      VARCHAR(100),
    @DonorType  VARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Donors (TCKN, DonorName, Surname, BirthDate, BloodGroup, Phone, Email, DonorType)
    VALUES (@TCKN, @DonorName, @Surname, @BirthDate, @BloodGroup, @Phone, @Email, @DonorType);

    PRINT 'Donor registered successfully.';
END;
GO

CREATE OR ALTER PROCEDURE sp_RecordDonation
    @DonorTCKN    CHAR(11),
    @HospitalID   INT,
    @DonationDate DATE,
    @Units        INT,
    @Notes        VARCHAR(250)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Donations (DonorTCKN, HospitalID, DonationDate, Units, Notes)
    VALUES (@DonorTCKN, @HospitalID, @DonationDate, @Units, @Notes);

    PRINT 'Donation recorded successfully.';
END;
GO