-- ==========================================
-- 3. INSERTING DUMMY DATA (Strictly following Lab 5 rules)
-- ==========================================

-- Airports (Names must be >= 10 chars)
INSERT INTO Airport (airport_id, airport_name, country, state, city, created_at, updated_at) VALUES 
(1, 'Almaty International', 'Kazakhstan', 'Almaty Region', 'Almaty', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
(2, 'Charles de Gaulle', 'France', 'Ile-de-France', 'Paris', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
(3, 'John F. Kennedy Intl', 'USA', 'New York', 'New York', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
RETURNING *;

-- Airlines
INSERT INTO Airline (airline_id, airline_code, airline_name, airline_country, created_at, updated_at) VALUES 
(1, 'KZA', 'Air Astana', 'Kazakhstan', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
(2, 'AFR', 'Air France', 'France', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(5, 'UNK', 'Old Airways', 'United Kingdom', '2023-12-01', CURRENT_DATE)
RETURNING *;

-- Passengers (Strict constraints: KZ Male <= 2008, FR Female <= 2007, US Male <= 2007)
INSERT INTO Passengers (passenger_id, first_name, last_name, date_of_birth, gender, country_of_citizenship, country_of_residence, passport_number, created_at, updated_at) VALUES 
(1, 'Dias', 'Nurmagambetov', '2000-05-15', 'Male', 'Kazakhstan', 'Kazakhstan', 'KZ1234567', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
(2, 'Chloe', 'Dubois', '2005-08-20', 'Female', 'France', 'France', 'FR9876543', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
(3, 'John', 'Smith', '1995-11-10', 'Male', 'USA', 'USA', 'US1122334', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
RETURNING *;

-- Flights
INSERT INTO Flights (flight_id, sch_departure_time, sch_arrival_time, departing_airport_id, arriving_airport_id, departing_gate, arriving_gate, airline_id, created_at, updated_at) VALUES 
(1, '2026-11-01 10:00:00', '2026-11-01 14:00:00', 1, 2, 'G1', 'T2', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
(2, '2026-12-05 08:00:00', '2026-12-05 18:00:00', 2, 3, 'A4', 'B2', 2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
RETURNING *;

-- Bookings (Price <= 50000. Testing discount logic: <= 2024 gets 10%, > 2024 gets 5%)
INSERT INTO Booking (booking_id, flight_id, passenger_id, booking_platform, created_at, updated_at, ticket_price, ticket_discount) VALUES 
(1, 1, 1, 'Web', '2023-12-15 10:00:00', CURRENT_TIMESTAMP, 40000.00, 4000.00),
(2, 2, 2, 'App', '2025-06-10 12:00:00', CURRENT_TIMESTAMP, 30000.00, 1500.00),
(3, 1, 3, 'Agency', '2024-05-01 09:00:00', CURRENT_TIMESTAMP, 25000.00, 1250.00)
RETURNING *;

-- Baggage (Weight 1-23 kg)
INSERT INTO Baggage (baggage_id, weight_in_kg, booking_id, created_at, updated_at) VALUES 
(1, 15.50, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
(2, 22.00, 2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP), 
(3, 8.00, 3, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
RETURNING *;

-- Baggage Check
INSERT INTO Baggage_check (baggage_check_id, check_result, created_at, updated_at, booking_id, passenger_id) VALUES 
(1, 'Not checked', '2023-05-01', '2023-05-01', 1, 1),
(2, 'Not checked', '2024-03-15', '2024-03-15', 2, 2);


-- ==========================================
-- 4. DML: DATA MODIFICATION (Lab 3) 
-- ==========================================
UPDATE airline SET airline_country = 'Turkey' WHERE airline_name = 'Air Astana' RETURNING *;

INSERT INTO airline (airline_id, airline_code, airline_name, airline_country, created_at, updated_at) VALUES 
(52, 'AEY', 'AirEasy', 'France', CURRENT_DATE, CURRENT_DATE),
(53, 'FHI', 'FlyHigh', 'Brazil', CURRENT_DATE, CURRENT_DATE),
(54, 'FLY', 'FlyFly', 'Poland', CURRENT_DATE, CURRENT_DATE) 
RETURNING *;

DELETE FROM Flights WHERE EXTRACT(YEAR FROM sch_arrival_time) = 2022 RETURNING *;

UPDATE Booking 
SET ticket_price = ticket_price * 1.15, 
    ticket_discount = (ticket_price * 1.15) * CASE WHEN created_at > '2024-01-01' THEN 0.05 ELSE 0.10 END 
RETURNING *;

DELETE FROM Booking WHERE ticket_price < 5000 RETURNING *;

UPDATE airline SET airline_code = 'UKN' WHERE airline_code IS NULL RETURNING *;
DELETE FROM Baggage_check WHERE created_at < '2023-06-01' AND check_result = 'Not checked' RETURNING *;
DELETE FROM Airport WHERE state IS NULL AND city IN ('Mlawe', 'Kepuh') RETURNING *;
UPDATE airline SET airline_country = UPPER(airline_country) RETURNING *;
UPDATE airline SET airline_name = 'Global Airways', airline_country = 'United Kingdom', updated_at = CURRENT_DATE WHERE airline_id = 5 RETURNING *;
UPDATE Airport SET state = 'Capital District' WHERE city IN ('Astana', 'London', 'Tokyo') RETURNING *;
UPDATE Baggage_check SET check_result = 'Checked' WHERE check_result = 'Not checked' AND created_at >= '2024-03-01' AND created_at < '2024-04-01' RETURNING *;


-- ==========================================
-- 5. DQL: SELECT QUERIES (Lab 4)
-- ==========================================
SELECT UPPER(airline_name) FROM airline;
SELECT REPLACE(airline_name, 'Air', 'Aero') FROM airline;
SELECT * FROM Airport WHERE airport_name LIKE '%Reginal%' AND airport_name LIKE '%Air%';
SELECT CONCAT(first_name, ' ', last_name) AS full_name, TO_CHAR(date_of_birth, 'Month DD, YYYY') FROM Passengers;
SELECT flight_id FROM Flights WHERE act_arrival_time > sch_arrival_time;

SELECT * FROM airline WHERE airline_country IN ('FRANCE', 'PORTUGAL', 'POLAND') AND created_at BETWEEN '2023-11-01' AND '2024-03-31'; 

SELECT * FROM Baggage WHERE weight_in_kg > 20 ORDER BY weight_in_kg DESC LIMIT 3; 

SELECT CONCAT(first_name, ' ', last_name) AS full_name FROM Passengers ORDER BY date_of_birth DESC LIMIT 1;
SELECT booking_platform, MIN(ticket_price) FROM Booking GROUP BY booking_platform;
SELECT * FROM airline WHERE airline_code ~ '[0-9]';
SELECT * FROM airline ORDER BY created_at DESC LIMIT 5;
SELECT * FROM Baggage_check WHERE booking_id BETWEEN 200 AND 300 AND check_result <> 'Checked';
SELECT * FROM Baggage_check WHERE EXTRACT(MONTH FROM updated_at) = EXTRACT(MONTH FROM created_at) AND updated_at < created_at;
