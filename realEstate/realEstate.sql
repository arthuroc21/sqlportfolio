DROP DATABASE IF EXISTS real_estate;
CREATE DATABASE IF NOT EXISTS real_estate;
USE real_estate;

DROP TABLE IF EXISTS office;
CREATE TABLE IF NOT EXISTS office (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    office_name VARCHAR(50) NOT NULL,
    state VARCHAR(5) NOT NULL
);

DROP TABLE IF EXISTS employee;
CREATE TABLE IF NOT EXISTS employee (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(50) NOT NULL,
    office_name VARCHAR(50) NOT NULL,
    office_id INT NOT NULL,
    FOREIGN KEY (office_id) REFERENCES office (id)
);

DROP TABLE IF EXISTS property;
CREATE TABLE IF NOT EXISTS property (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    property_name VARCHAR(50) NOT NULL,
    state VARCHAR(5) NOT NULL,
    cost FLOAT NOT NULL
);

DROP TABLE IF EXISTS owners;
CREATE TABLE IF NOT EXISTS owners (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(50) NOT NULL,
    property_name VARCHAR(50) NOT NULL,
    percent_owned FLOAT NOT NULL,
    property_id INT NOT NULL,
    FOREIGN KEY (property_id) REFERENCES property (id)
);

DROP TABLE IF EXISTS property_office;
CREATE TABLE IF NOT EXISTS property_office (
    property_name VARCHAR(50) NOT NULL,
    office_name VARCHAR(50) NOT NULL,
    property_id INT NOT NULL,
    office_id INT NOT NULL,
    FOREIGN KEY (property_id) REFERENCES property (id),
    FOREIGN KEY (office_id) REFERENCES office (id)
);

DROP TABLE IF EXISTS property_message;
CREATE TABLE IF NOT EXISTS property_message (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    message_date DATE NOT NULL,
    message_time TIME NOT NULL,
    message_text VARCHAR(100) NOT NULL
);

DELIMITER $$
CREATE PROCEDURE populateOfficeTable()
BEGIN
INSERT INTO office (office_name, state)
     VALUES  ('Office 1', 'NSW')
            ,('Office 2', 'NSW')
            ,('Office 3', 'QLD')
            ,('Office 4', 'SA')
            ,('Office 5', 'TAS');
END
$$

DELIMITER $$
CREATE PROCEDURE populateEmployeeTable()
BEGIN
INSERT INTO employee (full_name, office_name, office_id)
     VALUES  ('Sarah Smith', 'Office 1', 1)
            ,('Jeff Walton', 'Office 2', 2)
            ,('Elena Madsen', 'Office 3', 3)
            ,('Rudolf Smith', 'Office 4', 4)
            ,('Gilbert Anderson', 'Office 1', 1);
END
$$

DELIMITER $$
CREATE PROCEDURE populatePropertyTable()
BEGIN
INSERT INTO property (property_name, state, cost)
     VALUES  ('Property 1', 'NSW', 1000000)
            ,('Property 2', 'QLD', 2000000)
            ,('Property 3', 'SA', 3000000)
            ,('Property 4', 'TAS', 4000000)
            ,('Property 5', 'VIC', 5000000)
            ,('Property 6', 'WA', 6000000)
            ,('Property 7', 'NSW', 7000000)
            ,('Property 8', 'QLD', 8000000)
            ,('Property 9', 'SA', 9000000)
            ,('Property 10', 'TAS', 10000000)
            ,('Property 11', 'NSW', 11000000)
            ,('Property 12', 'NSW', 12000000)
            ,('Property 13', 'NSW', 13000000)
            ,('Property 14', 'QLD', 14000000)
            ,('Property 15', 'QLD', 15000000);
END
$$

DELIMITER $$
CREATE PROCEDURE populateOwnersTable()
BEGIN
INSERT INTO owners (full_name, property_name, percent_owned, property_id)
     VALUES  ('John Doe', 'Property 1', 55, 1)
            ,('Kara Sanchez', 'Property 1', 45, 1)
            ,('Dillon James', 'Property 2', 100, 2)
            ,('Dillon James', 'Property 3', 100, 3)
            ,('Maria Lee', 'Property 4', 100, 4)
            ,('Maria Lee', 'Property 6', 25, 6)
            ,('Maria Lee', 'Property 7', 40, 7)
            ,('Emilia McKinley', 'Property 6', 75, 6)
            ,('Emilia McKinley', 'Property 7', 60, 7);
END
$$

DELIMITER $$
CREATE PROCEDURE populatePropertyOfficeTable()
BEGIN
INSERT INTO property_office (property_name, office_name, property_id, office_id)
     VALUES  ('Property 1', 'Office 1', 1, 1)
            ,('Property 2', 'Office 2', 2, 2)
            ,('Property 3', 'Office 3', 3, 3)
            ,('Property 4', 'Office 4', 4, 4)
            ,('Property 5', 'Office 1', 5, 1)
            ,('Property 6', 'Office 2', 6, 2)
            ,('Property 7', 'Office 3', 7, 3)
            ,('Property 8', 'Office 4', 8, 4)
            ,('Property 9', 'Office 1', 9, 1)
            ,('Property 10', 'Office 2', 10, 2)
            ,('Property 11', 'Office 1', 11, 1)
            ,('Property 12', 'Office 1', 12, 1)
            ,('Property 13', 'Office 1', 13, 1)
            ,('Property 14', 'Office 2', 14, 2)
            ,('Property 15', 'Office 2', 15, 2);
END
$$

DELIMITER $$
CREATE PROCEDURE populateAllTables()
BEGIN
CALL populateOfficeTable();
CALL populateEmployeeTable();
CALL populatePropertyTable();
CALL populateOwnersTable();
CALL populatePropertyOfficeTable();
END
$$

CREATE OR REPLACE VIEW property_report AS
SELECT property.property_name, property.state, property.cost, office.office_name, owners.full_name, owners.percent_owned FROM property
INNER JOIN property_office
ON property.id = property_office.property_id
INNER JOIN office
ON property_office.office_id = office.id
LEFT JOIN owners
ON owners.property_id = property.id
ORDER BY property.id ASC;

CREATE OR REPLACE VIEW maria_property AS
SELECT property.property_name, property.state, property.cost, office.office_name, owners.full_name, owners.percent_owned FROM property
INNER JOIN property_office
ON property.id = property_office.property_id
INNER JOIN office
ON property_office.office_id = office.id
LEFT JOIN owners
ON owners.property_id = property.id
WHERE owners.full_name IN ("Maria Lee")
ORDER BY property.id ASC;

DELIMITER $$
CREATE PROCEDURE retrieveProperty ()
BEGIN
SELECT property.property_name, property.state, property.cost, office.office_name, owners.full_name, owners.percent_owned FROM property
INNER JOIN property_office
ON property.id = property_office.property_id
INNER JOIN office
ON property_office.office_id = office.id
LEFT JOIN owners
ON owners.property_id = property.id
ORDER BY property.id ASC;
END
$$

DELIMITER $$
CREATE PROCEDURE updatePropertyCost (IN input_id INT, IN input_cost FLOAT)
BEGIN
UPDATE property
SET cost = input_cost
WHERE id = input_id;
END
$$

DELIMITER $$
CREATE TRIGGER validateCost
BEFORE INSERT ON property
FOR EACH ROW
BEGIN
IF NEW.cost < 0 THEN
SET NEW.cost = 0;
END IF;
END
$$

DELIMITER $$
CREATE TRIGGER updatePropertyCost
BEFORE UPDATE ON property
FOR EACH ROW
BEGIN
IF NEW.cost < 0 THEN
SET NEW.cost = 0;
INSERT INTO property_message (message_date, message_time, message_text)
VALUES (CURDATE(), CURTIME(), CONCAT("Invalid cost entered for property id ", new.id));
END IF;
END
$$

DELIMITER ;

CALL populateAllTables();