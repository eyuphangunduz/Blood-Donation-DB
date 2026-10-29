USE BloodDonation;
GO

CREATE TABLE Cities (
    CityID INT IDENTITY(1,1) PRIMARY KEY,
    CityName VARCHAR(50) NOT NULL UNIQUE,
    Region VARCHAR(50) NOT NULL
);

CREATE TABLE Hospitals (
    HospitalID INT IDENTITY(1,1) PRIMARY KEY,
    HospitalName VARCHAR(100) NOT NULL,
    hospitalAddress VARCHAR(255) NOT NULL,
    Phone VARCHAR(20) NOT NULL,
    HospitalType VARCHAR(30) NOT NULL CHECK (HospitalType IN ('State', 'Private', 'University')),
    CityID INT NOT NULL FOREIGN KEY REFERENCES Cities(CityID)
);

CREATE TABLE Donors (
    TCKN CHAR(11) PRIMARY KEY,
    DonorName VARCHAR(50) NOT NULL,
    Surname VARCHAR(50) NOT NULL,
    BirthDate DATE NOT NULL CHECK (BirthDate <= DATEADD(YEAR, -18, CAST(GETDATE() AS DATE))),
    BloodGroup VARCHAR(5) NOT NULL CHECK (BloodGroup IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')),
    Phone VARCHAR(20) NOT NULL,
    Email VARCHAR(100),
    DonorType VARCHAR(30) NOT NULL CHECK (DonorType IN ('Volunteer', 'Replacement'))
);

CREATE TABLE Donations (
    DonationID INT IDENTITY(1,1) PRIMARY KEY,
    DonationDate DATETIME NOT NULL CHECK (DonationDate <= GETDATE()),
    Units INT NOT NULL CHECK (Units > 0),
    Notes VARCHAR(MAX),
    DonorTCKN CHAR(11) NOT NULL FOREIGN KEY REFERENCES Donors(TCKN),
    HospitalID INT NOT NULL FOREIGN KEY REFERENCES Hospitals(HospitalID)
);

CREATE TABLE BloodInventory (
    InventoryID INT IDENTITY(1,1) PRIMARY KEY,
    HospitalID INT NOT NULL FOREIGN KEY REFERENCES Hospitals(HospitalID),
    BloodGroup VARCHAR(5) NOT NULL CHECK (BloodGroup IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')),
    Units INT NOT NULL CHECK (Units >= 0),
    CriticalLevel INT NOT NULL CHECK (CriticalLevel > 0),
    LastUpdated DATETIME NOT NULL,
    CONSTRAINT UQ_Hospital_BloodGroup UNIQUE (HospitalID, BloodGroup)
);

CREATE TABLE BloodUnit (
    UnitID INT IDENTITY(1,1) PRIMARY KEY,
    BloodGroup VARCHAR(5) NOT NULL CHECK (BloodGroup IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')),
    ExpirationDate DATE NOT NULL,
    TestStatus VARCHAR(30) NOT NULL,
    UnitStatus VARCHAR(20) NOT NULL,
    ComponentType VARCHAR(30) NOT NULL CHECK (ComponentType IN ('Red_Cells', 'Plasma', 'Platelets')),
    DonationID INT NOT NULL FOREIGN KEY REFERENCES Donations(DonationID)
);

CREATE TABLE UnitUsage (
    UsageID INT IDENTITY(1,1) PRIMARY KEY,
    UsageDate DATETIME NOT NULL,
    Department VARCHAR(50) NOT NULL,
    PatientID INT NOT NULL CHECK (PatientID > 0),
    UnitID INT NOT NULL UNIQUE FOREIGN KEY REFERENCES BloodUnit(UnitID)
);