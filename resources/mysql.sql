CREATE DATABASE IF NOT EXISTS testdb2;
USE testdb2;

CREATE TABLE `FLIGHTS` (
  `flightId` int(10) AUTO_INCREMENT,
  `airline` varchar(100),
  `arrivalDate` DATE,
  `departureDate` DATE,
  `dest` varchar(100),
  `rom` varchar(100),
  `price` int(10),
  PRIMARY KEY (flightId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `FLIGHTS` (`airline`, `arrivalDate`, `departureDate`, `dest`, `rom`, `price`) VALUES
('Emirates', '2007-11-06', '2007-11-06', 'DXB', 'CMB', 100),
('Asiana', '2007-11-06', '2007-11-06', 'DXB', 'CMB', 200),
('Qatar', '2007-11-06', '2007-11-06', 'DXB', 'CMB', 300);

CREATE TABLE `CARS` (
  `company` varchar(100),
  `arrivalDate` DATE,
  `departureDate` DATE,
  `vehicleType` varchar(100),
  `price` int(10),
  PRIMARY KEY (company)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `CARS` (`company`, `arrivalDate`, `departureDate`, `vehicleType`, `price`) VALUES
('DriveSG', '2007-11-06', '2007-11-06', 'Car', 10),
('DreamCar', '2007-11-06', '2007-11-06', 'Car', 20),
('Sixt', '2007-11-06', '2007-11-06', 'Car', 30);