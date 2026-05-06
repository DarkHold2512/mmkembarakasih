-- Database: `mmkembarakasih`
CREATE DATABASE IF NOT EXISTS `mmkembarakasih` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `mmkembarakasih`;

-- 1. LEVEL TABLE (Reference Table)
CREATE TABLE `level` (
  `LevelID` int(11) NOT NULL,
  `LevelName` varchar(50) NOT NULL,
  PRIMARY KEY (`LevelID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `level` (`LevelID`, `LevelName`) VALUES
(1, 'Administrator'),
(2, 'Staff'),
(3, 'Customer');

-- 2. USER TABLE (Uses Manual/String ID)
CREATE TABLE `user` (
  `UserID` varchar(255) NOT NULL,
  `FullName` varchar(255) NOT NULL,
  `PassportNo` varchar(50) DEFAULT NULL,
  `PassportExpiryDate` date DEFAULT NULL,
  `PhoneNo` varchar(255) NOT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `pwd` varchar(255) NOT NULL,
  `Address` varchar(255) NOT NULL,
  `MaritialStatus` varchar(255) NOT NULL,
  `PassportImg` varchar(255) NOT NULL,
  `LevelID` int(11) DEFAULT NULL,
  PRIMARY KEY (`UserID`),
  UNIQUE KEY `Email` (`Email`),
  KEY `LevelID` (`LevelID`),
  CONSTRAINT `user_ibfk_1` FOREIGN KEY (`LevelID`) REFERENCES `level` (`LevelID`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 3. PACKAGE TABLE (Auto-Increment ID)
CREATE TABLE `package` (
  `PackageID` int(11) NOT NULL AUTO_INCREMENT,
  `Destination` varchar(100) NOT NULL,
  `BasePrice` decimal(10,2) NOT NULL,
  `StartDate` date NOT NULL,
  `EndDate` date NOT NULL,
  `FlightNo` varchar(50) DEFAULT NULL,
  `AirlineName` varchar(100) DEFAULT NULL,
  `HotelName` varchar(255) DEFAULT NULL,
  `InsuranceProviderName` varchar(255) DEFAULT NULL,
  `MaxCapacity` int(11) DEFAULT NULL,
  `iternary_pdf` varchar(255) NOT NULL,
  PRIMARY KEY (`PackageID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 4. BOOKING TABLE (References user.UserID as varchar)
CREATE TABLE `booking` (
  `BookingID` int(11) NOT NULL AUTO_INCREMENT,
  `BookingDate` date NOT NULL,
  `BookingStatus` varchar(50) DEFAULT NULL,
  `TotalAmount` decimal(10,2) DEFAULT NULL,
  `BookerID` varchar(255) DEFAULT NULL, -- Fixed: Changed to varchar to match user.UserID
  `StaffID` varchar(255) DEFAULT NULL,  -- Fixed: Changed to varchar to match user.UserID
  `PackageID` int(11) DEFAULT NULL,
  PRIMARY KEY (`BookingID`),
  KEY `BookerID` (`BookerID`),
  KEY `StaffID` (`StaffID`),
  KEY `PackageID` (`PackageID`),
  CONSTRAINT `booking_ibfk_1` FOREIGN KEY (`BookerID`) REFERENCES `user` (`UserID`) ON DELETE CASCADE,
  CONSTRAINT `booking_ibfk_2` FOREIGN KEY (`StaffID`) REFERENCES `user` (`UserID`) ON DELETE SET NULL,
  CONSTRAINT `booking_ibfk_3` FOREIGN KEY (`PackageID`) REFERENCES `package` (`PackageID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 5. PARTICIPANT TABLE (Composite Key with Manual ID)
CREATE TABLE `participant` (
  `ParticipantID` varchar(255) NOT NULL,
  `FullName` varchar(255) NOT NULL,
  `PassportNo` varchar(50) DEFAULT NULL,
  `PassportExpiryDate` date DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `PhoneNo` varchar(255) NOT NULL,
  `Address` varchar(255) NOT NULL,
  `MaritialStatus` varchar(255) NOT NULL,
  `PassportImg` varchar(255) NOT NULL,
  `BookingID` int(11) NOT NULL,
  PRIMARY KEY (`ParticipantID`,`BookingID`),
  KEY `BookingID` (`BookingID`),
  CONSTRAINT `participant_ibfk_1` FOREIGN KEY (`BookingID`) REFERENCES `booking` (`BookingID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- 6. PAYMENT TABLE
CREATE TABLE `payment` (
  `PaymentID` int(11) NOT NULL AUTO_INCREMENT,
  `Amount` decimal(10,2) NOT NULL,
  `PaymentDate` date NOT NULL,
  `PaymentMethod` varchar(50) DEFAULT NULL,
  `PaymentProofPDF` varchar(255) NOT NULL,
  `BookingID` int(11) DEFAULT NULL,
  PRIMARY KEY (`PaymentID`),
  KEY `BookingID` (`BookingID`),
  CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`BookingID`) REFERENCES `booking` (`BookingID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;