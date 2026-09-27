-- LAB3 PUSHKIN DANIIL
CREATE TABLE norm_airline (
    airline_id INT PRIMARY KEY,
    airline_name VARCHAR(100) NOT NULL
);

CREATE TABLE norm_airport (
    airport_id INT PRIMARY KEY,
    airport_name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL
);

CREATE TABLE norm_passenger (
    passport_number VARCHAR(20) PRIMARY KEY,
    passenger_full_name VARCHAR(100) NOT NULL
);

CREATE TABLE norm_flight (
    flight_number VARCHAR(20) PRIMARY KEY,
    departure_airport_id INT NOT NULL,
    arrival_airport_id INT NOT NULL,
    airline_id INT NOT NULL,
    FOREIGN KEY (departure_airport_id) REFERENCES norm_airport(airport_id),
    FOREIGN KEY (arrival_airport_id) REFERENCES norm_airport(airport_id),
    FOREIGN KEY (airline_id) REFERENCES norm_airline(airline_id)
);

CREATE TABLE norm_booking (
    booking_id INT PRIMARY KEY,
    flight_number VARCHAR(20) NOT NULL,
    FOREIGN KEY (flight_number) REFERENCES norm_flight(flight_number)
);

CREATE TABLE norm_booking_passenger (
    booking_id INT NOT NULL,
    passport_number VARCHAR(20) NOT NULL,
    seat_number VARCHAR(10) NOT NULL,
    ticket_price DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (booking_id, passport_number),
    FOREIGN KEY (booking_id) REFERENCES norm_booking(booking_id),
    FOREIGN KEY (passport_number) REFERENCES norm_passenger(passport_number)
);

-- Insert 5 rows of sample data for Normalization Task 5
INSERT INTO norm_airline VALUES
(1, 'Air Astana'),
(2, 'FlyArystan');

INSERT INTO norm_airport VALUES
(1, 'Almaty International Airport', 'Almaty'),
(2, 'Nursultan Nazarbayev International Airport', 'Astana'),
(3, 'Shymkent International Airport', 'Shymkent');

INSERT INTO norm_passenger VALUES
('P1001', 'Aidar Karimov'),
('P1002', 'Mira Lee'),
('P1003', 'Daniyar Kim'),
('P1004', 'Sofia Park'),
('P1005', 'Timur Sadyk');

INSERT INTO norm_flight VALUES
('KC101', 1, 2, 1),
('FS202', 2, 1, 2),
('KC303', 1, 3, 1);

INSERT INTO norm_booking VALUES
(1001, 'KC101'),
(1002, 'FS202'),
(1003, 'KC303');

INSERT INTO norm_booking_passenger VALUES
(1001, 'P1001', '12A', 55000.00),
(1001, 'P1002', '12B', 55000.00),
(1002, 'P1003', '18C', 42000.00),
(1003, 'P1004', '7A', 47000.00),
(1003, 'P1005', '20D', 39000.00);


-- ==========================================
-- DDL TASKS: Tasks 1-9
-- ==========================================

CREATE TABLE airline_info (
    airline_id INT NOT NULL,
    airline_code VARCHAR(30) NOT NULL,
    airline_name VARCHAR(50) NOT NULL,
    airline_country VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    info VARCHAR(50) NOT NULL,
    PRIMARY KEY (airline_id)
);

CREATE TABLE airport (
    airport_id INT NOT NULL,
    airport_name VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    PRIMARY KEY (airport_id)
);

CREATE TABLE baggage_check (
    baggage_check_id INT NOT NULL,
    check_result VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    booking_id INT NOT NULL,
    passenger_id INT NOT NULL,
    PRIMARY KEY (baggage_check_id)
);

CREATE TABLE baggage (
    baggage_id INT NOT NULL,
    weight_in_kg DECIMAL(4,2) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    booking_id INT NOT NULL,
    PRIMARY KEY (baggage_id)
);

CREATE TABLE boarding_pass (
    boarding_pass_id INT NOT NULL,
    booking_id INT NOT NULL,
    seat VARCHAR(50) NOT NULL,
    boarding_time TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    PRIMARY KEY (boarding_pass_id)
);

CREATE TABLE booking_flight (
    booking_flight_id INT NOT NULL,
    booking_id INT NOT NULL,
    flight_id INT NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    PRIMARY KEY (booking_flight_id)
);

CREATE TABLE booking (
    booking_id INT NOT NULL,
    flight_id INT NOT NULL,
    passenger_id INT NOT NULL,
    booking_platform VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    status VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (booking_id)
);

CREATE TABLE flights (
    flight_id INT NOT NULL,
    sch_departure_time TIMESTAMP NOT NULL,
    sch_arrival_time TIMESTAMP NOT NULL,
    departing_airport_id INT NOT NULL,
    arriving_airport_id INT NOT NULL,
    departing_gate VARCHAR(50) NOT NULL,
    arriving_gate VARCHAR(50) NOT NULL,
    airline_id INT NOT NULL,
    act_departure_time TIMESTAMP NOT NULL,
    act_arrival_time TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    PRIMARY KEY (flight_id)
);

CREATE TABLE passengers (
    passenger_id INT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(50) NOT NULL,
    country_of_citizenship VARCHAR(50) NOT NULL,
    country_of_residence VARCHAR(50) NOT NULL,
    passport_number VARCHAR(20) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    PRIMARY KEY (passenger_id)
);

CREATE TABLE security_check (
    security_check_id INT NOT NULL,
    check_result VARCHAR(20) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    passenger_id INT NOT NULL,
    PRIMARY KEY (security_check_id)
);

-- Task 5: Rename airline_info to airline
ALTER TABLE airline_info RENAME TO airline;

-- Task 6: Rename price to ticket_price in booking table
ALTER TABLE booking RENAME COLUMN price TO ticket_price;

-- Task 7: Change data type of departing_gate to text
ALTER TABLE flights ALTER COLUMN departing_gate TYPE TEXT; 
-- (Note: If using MySQL, use MODIFY COLUMN departing_gate TEXT NOT NULL;)

-- Task 8: Drop the column info from the airline table
ALTER TABLE airline DROP COLUMN info;

-- Task 9: Make relationships (Foreign Keys)
ALTER TABLE security_check ADD CONSTRAINT fk_security_passenger FOREIGN KEY (passenger_id) REFERENCES passengers(passenger_id);
ALTER TABLE booking ADD CONSTRAINT fk_booking_passenger FOREIGN KEY (passenger_id) REFERENCES passengers(passenger_id);
ALTER TABLE baggage_check ADD CONSTRAINT fk_baggage_check_passenger FOREIGN KEY (passenger_id) REFERENCES passengers(passenger_id);

ALTER TABLE baggage_check ADD CONSTRAINT fk_baggage_check_booking FOREIGN KEY (booking_id) REFERENCES booking(booking_id);
ALTER TABLE baggage ADD CONSTRAINT fk_baggage_booking FOREIGN KEY (booking_id) REFERENCES booking(booking_id);
ALTER TABLE boarding_pass ADD CONSTRAINT fk_boarding_booking FOREIGN KEY (booking_id) REFERENCES booking(booking_id);
ALTER TABLE booking_flight ADD CONSTRAINT fk_booking_flight_booking FOREIGN KEY (booking_id) REFERENCES booking(booking_id);

ALTER TABLE booking_flight ADD CONSTRAINT fk_booking_flight_flight FOREIGN KEY (flight_id) REFERENCES flights(flight_id);
ALTER TABLE flights ADD CONSTRAINT fk_flight_departing_airport FOREIGN KEY (departing_airport_id) REFERENCES airport(airport_id);
ALTER TABLE flights ADD CONSTRAINT fk_flight_arriving_airport FOREIGN KEY (arriving_airport_id) REFERENCES airport(airport_id);
ALTER TABLE flights ADD CONSTRAINT fk_flight_airline FOREIGN KEY (airline_id) REFERENCES airline(airline_id);

-- ==========================================
-- Insert Initial Sample Data for Lab 3 DML
-- ==========================================

INSERT INTO airline (airline_id, airline_code, airline_name, airline_country, created_at, updated_at) VALUES
(1, 'KCA', 'Air Astana', 'Kazakhstan', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(5, 'THY', 'Turkish Airlines', 'Turkey', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO airport (airport_id, airport_name, country, state, city, created_at, updated_at) VALUES
(1, 'Almaty International', 'Kazakhstan', 'Almaty Region', 'Almaty', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 'Nursultan Nazarbayev', 'Kazakhstan', 'Akmola Region', 'Astana', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO passengers (passenger_id, first_name, last_name, date_of_birth, gender, country_of_citizenship, country_of_residence, passport_number, created_at, updated_at) VALUES
(1, 'Aidar', 'Karimov', '1990-01-01', 'M', 'Kazakhstan', 'Kazakhstan', 'P1001', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO flights (flight_id, sch_departure_time, sch_arrival_time, departing_airport_id, arriving_airport_id, departing_gate, arriving_gate, airline_id, act_departure_time, act_arrival_time, created_at, updated_at) VALUES
(1, '2024-05-01 10:00:00', '2024-05-01 12:00:00', 1, 2, 'Gate A1', 'Gate B2', 1, '2024-05-01 10:05:00', '2024-05-01 12:00:00', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO booking (booking_id, flight_id, passenger_id, booking_platform, created_at, updated_at, status, ticket_price) VALUES
(1001, 1, 1, 'Web', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Confirmed', 55000.00);

-- ==========================================
-- DML TASKS: Laboratory Work 3 PUSHKIN DANIIL
-- ==========================================

-- 1. Generate and insert 200 random rows in your airport database.
INSERT INTO airport (airport_id, airport_name, country, state, city, created_at, updated_at)
SELECT 
    i, 
    'Airport ' || i, 
    'Country ' || (i % 20), 
    'State ' || (i % 20), 
    'City ' || i, 
    CURRENT_TIMESTAMP, 
    CURRENT_TIMESTAMP
FROM generate_series(6, 205) AS i;

-- 2. Add a new airline named "KazAir" based in "Kazakhstan" to the airline table.
INSERT INTO airline (airline_id, airline_code, airline_name, airline_country, created_at, updated_at)
VALUES (6, 'KZA', 'KazAir', 'Kazakhstan', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- 3. Update the airline country "KazAir" to "Turkey".
UPDATE airline
SET airline_country = 'Turkey',
    updated_at = CURRENT_TIMESTAMP
WHERE airline_name = 'KazAir';

-- 4. Add three airlines at once: "AirEasy" in "France", "FlyHigh" in "Brazil" and "FlyFly" in "Poland".
INSERT INTO airline (airline_id, airline_code, airline_name, airline_country, created_at, updated_at)
VALUES 
    (7, 'AEZ', 'AirEasy', 'France', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (8, 'FLH', 'FlyHigh', 'Brazil', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (9, 'FLF', 'FlyFly', 'Poland', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- 5. Delete all flights whose arrival in 2024 year.
DELETE FROM flights
WHERE EXTRACT(YEAR FROM sch_arrival_time) = 2024;

-- 6. Increase the price of all tickets in booking table for flights by 15%.
UPDATE booking
SET ticket_price = ticket_price * 1.15,
    updated_at = CURRENT_TIMESTAMP;

-- 7. Delete all tickets where price is less than 10000.
DELETE FROM booking
WHERE ticket_price < 10000;

-- 8. Set a default code 'UNK' (Unknown) for any airline in the airline table where airline_code is missing (NULL).
UPDATE airline
SET airline_code = 'UNK',
    updated_at = CURRENT_TIMESTAMP
WHERE airline_code IS NULL;

-- 9. Delete all baggage check records created before June 1, 2023, whose result is still 'Not checked'.
DELETE FROM baggage_check
WHERE created_at < '2023-06-01' 
  AND check_result = 'Not checked';

-- 10. Delete all entries from the airport table where state is missing (NULL) and the city is either 'Mlawe' or 'Kepuh'.
DELETE FROM airport
WHERE state IS NULL 
  AND city IN ('Mlawe', 'Kepuh');

-- 11. Insert a new unchecked baggage inspection record and immediately return its newly generated baggage_check_id and created_at timestamp.
INSERT INTO baggage_check (baggage_check_id, check_result, created_at, updated_at, booking_id, passenger_id)
VALUES (100, 'Not checked', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 1001, 1)
RETURNING baggage_check_id, created_at;

-- 12. Convert all country names in the airline table to uppercase to ensure data consistency.
UPDATE airline
SET airline_country = UPPER(airline_country),
    updated_at = CURRENT_TIMESTAMP;

-- 13. Update both the name and country for the airline with airline_id = 5. 
UPDATE airline
SET airline_name = 'Global Airways',
    airline_country = 'United Kingdom',
    updated_at = CURRENT_TIMESTAMP
WHERE airline_id = 5;

-- 14. Set the state field to 'Capital District' for airports located in specific cities: 'Astana', 'London', and 'Tokyo'
UPDATE airport
SET state = 'Capital District',
    updated_at = CURRENT_TIMESTAMP
WHERE city IN ('Astana', 'London', 'Tokyo');

-- 15. Mark all baggage check records created in March 2024 with a status of 'Not checked' as completed ('Checked').
UPDATE baggage_check
SET check_result = 'Checked',
    updated_at = CURRENT_TIMESTAMP
WHERE check_result = 'Not checked'
  AND EXTRACT(YEAR FROM created_at) = 2024 
  AND EXTRACT(MONTH FROM created_at) = 3;
