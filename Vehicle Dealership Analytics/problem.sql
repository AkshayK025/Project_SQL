
-- Problem Statements
/*
"   Q1. Find customers who purchased the same vehicle model 
more than once in the same year."

"Q2. Identify vehicles not serviced in the last 12 months."

"  Q3. Get top 3 dealers per region based on profit (revenue - 
cost) for Q1 2025."

"   Q4. Calculate the month-over-month % growth in service 
appointments in 2024."

"   Q5. Flag older records where customer email and phone are 
duplicated."

"Q6. Find customers who bought both Toyota Corolla and Honda Civic"

"Q7. Get the latest service record for each vehicle along with 
cost."

*/

--Database
CREATE DATABASE vechicle;
use vechicle;

-- Tables
SHOW Tables; 

-- Select Tables
SELECT * FROM customers;
SELECT * FROM dealers;
SELECT * FROM models;
SELECT * FROM purchases;
SELECT * FROM service_appointments;
SELECT * FROM services;
SELECT * FROM vehicles;




-- 1. Customers
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20)
);

INSERT INTO customers VALUES
(1, 'Alice Smith', 'alice@example.com', '1234567890'),
(2, 'Bob Johnson', 'bob@example.com', '2345678901'),
(3, 'Carol King', 'alice@example.com', '1234567890'), -- Duplicate for Q5
(4, 'Dan Lee', 'dan@example.com', '3456789012');

-- 2. Dealers
CREATE TABLE dealers (
    dealer_id INT PRIMARY KEY,
    dealer_name VARCHAR(100),
    region VARCHAR(50)
);

INSERT INTO dealers VALUES
(1, 'AutoWorld', 'North'),
(2, 'SpeedMotors', 'South'),
(3, 'CarZone', 'North'),
(4, 'DriveAway', 'West');

-- 3. Models
CREATE TABLE models (
    model_id INT PRIMARY KEY,
    brand VARCHAR(50),
    model_name VARCHAR(50)
);

INSERT INTO models VALUES
(1, 'Toyota', 'Corolla'),
(2, 'Honda', 'Civic'),
(3, 'Ford', 'F-150'),
(4, 'Chevrolet', 'Bolt');

-- 4. Vehicles
CREATE TABLE vehicles (
    vehicle_id INT PRIMARY KEY,
    model_id INT,
    vin VARCHAR(17), -- unique vehicle identifier
    FOREIGN KEY (model_id) REFERENCES models(model_id)
);

INSERT INTO vehicles VALUES
(1, 1, 'VIN001'),
(2, 2, 'VIN002'),
(3, 1, 'VIN003'),
(4, 3, 'VIN004'),
(5, 4, 'VIN005'),
(6, 2, 'VIN006');

-- 5. Purchases
CREATE TABLE purchases (
    purchase_id INT PRIMARY KEY,
    customer_id INT,
    vehicle_id INT,
    dealer_id INT,
    purchase_date DATE,
    cost DECIMAL(10,2),
    revenue DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id),
    FOREIGN KEY (dealer_id) REFERENCES dealers(dealer_id)
);

INSERT INTO purchases VALUES
(1, 1, 1, 1, '2024-01-10', 18000, 20000), -- Alice, Corolla
(2, 1, 3, 2, '2024-06-15', 18500, 20500), -- Alice, Corolla again (same year)
(3, 2, 2, 2, '2024-02-20', 19000, 21000), -- Bob, Civic
(4, 2, 6, 2, '2025-02-01', 19500, 21500), -- Bob, Civic again (new year)
(5, 3, 5, 3, '2023-10-01', 22000, 24000), -- Carol, Bolt
(6, 4, 4, 4, '2025-03-15', 25000, 27000); -- Dan, F-150
-- Make sure a customer buys both Corolla and Civic
-- Assume customer_id 1 exists
-- Assume vehicle_id 10 is a Corolla, and vehicle_id 11 is a Civic


-- 6. Service Records
CREATE TABLE services (
    service_id INT PRIMARY KEY,
    vehicle_id INT,
    service_date DATE,
    cost DECIMAL(8,2),
    description VARCHAR(100),
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id)
);

INSERT INTO services VALUES
(1, 1, '2024-06-01', 200.00, 'Oil Change'),
(2, 2, '2023-01-15', 150.00, 'Tire Rotation'),
(3, 3, '2023-06-20', 180.00, 'Brake Check'),
(4, 5, '2024-10-10', 250.00, 'Battery Replacement');

-- 7. Service Appointments
CREATE TABLE service_appointments (
    appointment_id INT PRIMARY KEY,
    vehicle_id INT,
    appointment_date DATE,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id)
);

INSERT INTO service_appointments VALUES
(1, 1, '2024-01-10'),
(2, 2, '2024-02-10'),
(3, 1, '2024-03-10'),
(4, 3, '2024-03-15'),
(5, 5, '2024-04-01'),
(6, 3, '2024-05-20'),
(7, 5, '2024-06-10'),
(8, 1, '2024-06-25');





