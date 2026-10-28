CREATE TABLE Cities (
    CityID INT IDENTITY(1,1) PRIMARY KEY,
    CityName VARCHAR(50) NOT NULL,
    Region VARCHAR(50) NOT NULL
);

CREATE TABLE Hospitals (
    HospitalID INT IDENTITY(1,1) PRIMARY KEY,
    HospitalName VARCHAR(100) NOT NULL,
    hospitalAddress VARCHAR(255) NOT NULL,
    Phone VARCHAR(20) NOT NULL,
    HospitalType VARCHAR(30) NOT NULL,
    CityID INT FOREIGN KEY REFERENCES Cities(CityID)
);

CREATE TABLE Donors (
    DonorID INT IDENTITY(1,1) PRIMARY KEY,
    TCKN CHAR(11) UNIQUE NOT NULL,
    DonorName VARCHAR(50) NOT NULL,
    Surname VARCHAR(50) NOT NULL,
    BirthDate DATE NOT NULL,
    BloodGroup VARCHAR(5) NOT NULL,
    Phone VARCHAR(20) NOT NULL,
    Email VARCHAR(100),
    DonorType VARCHAR(30) NOT NULL
);

CREATE TABLE Donations (
    DonationID INT IDENTITY(1,1) PRIMARY KEY,
    DonationDate DATETIME NOT NULL,
    Units INT NOT NULL,
    Notes VARCHAR(MAX),
    DonorID INT FOREIGN KEY REFERENCES Donors(DonorID),
    HospitalID INT FOREIGN KEY REFERENCES Hospitals(HospitalID)
);

CREATE TABLE BloodInventory (
    InventoryID INT IDENTITY(1,1) PRIMARY KEY,
    HospitalID INT FOREIGN KEY REFERENCES Hospitals(HospitalID),
    BloodGroup VARCHAR(5) NOT NULL,
    Units INT NOT NULL,
    CriticalLevel INT NOT NULL,
    LastUpdated DATETIME NOT NULL,
    CONSTRAINT UQ_Hospital_BloodGroup UNIQUE (HospitalID, BloodGroup)
);

CREATE TABLE BloodUnit (
    UnitID INT IDENTITY(1,1) PRIMARY KEY,
    BloodGroup VARCHAR(5) NOT NULL,
    ExpirationDate DATE NOT NULL,
    TestStatus VARCHAR(30) NOT NULL,
    UnitStatus VARCHAR(20) NOT NULL,
    ComponentType VARCHAR(30) NOT NULL,
    DonationID INT FOREIGN KEY REFERENCES Donations(DonationID)
);

CREATE TABLE UnitUsage (
    UsageID INT IDENTITY(1,1) PRIMARY KEY,
    UsageDate DATETIME NOT NULL,
    Department VARCHAR(50) NOT NULL,
    PatientID INT NOT NULL,
    UnitID INT FOREIGN KEY REFERENCES BloodUnit(UnitID)
);