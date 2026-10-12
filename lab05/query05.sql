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
(2, 'AFR', 'Air France', 'France', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
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
