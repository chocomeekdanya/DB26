-- Laboratory work 7
-- Task 1: Create an index on the actual_departure column
CREATE INDEX idx_flights_actual_departure 
ON flights (actual_departure_time);

-- Task 2: Create a unique index for flight_no and scheduled_departure
CREATE UNIQUE INDEX idx_flights_unique_flight_departure 
ON flights (flight_id, sch_departure_time);

-- Task 3: Create a composite index on departure and arrival airports
CREATE INDEX idx_flights_route 
ON flights (departing_airport_id, arriving_airport_id);

-- Task 4: Evaluate query performance with and without indexes
-- (Assuming index from Task 3 is already created, we will drop and recreate for testing)
DROP INDEX IF EXISTS idx_flights_route;
EXPLAIN ANALYZE 
SELECT * FROM flights 
WHERE departing_airport_id = 1 AND arriving_airport_id = 2;

CREATE INDEX idx_flights_route 
ON flights (departing_airport_id, arriving_airport_id);
EXPLAIN ANALYZE 
SELECT * FROM flights 
WHERE departing_airport_id = 1 AND arriving_airport_id = 2;

-- Task 5: Check index usage in a query filtering by departure and arrival
EXPLAIN ANALYZE 
SELECT flight_id, sch_departure_time 
FROM flights 
WHERE departing_airport_id = 5 AND arriving_airport_id = 10;

-- Task 6: Unique index for passport_number in Passengers
CREATE UNIQUE INDEX idx_passengers_passport 
ON Passengers (passport_number);

-- Verify by checking system catalogs
SELECT indexname, indexdef 
FROM pg_indexes 
WHERE tablename = 'passengers' AND indexname = 'idx_passengers_passport';

-- Insert two new passengers to test uniqueness
INSERT INTO Passengers (first_name, last_name, date_of_birth, gender, country_of_citizenship, country_of_residence, passport_number, created_at, updated_at) 
VALUES ('John', 'Doe', '1990-01-01', 'Male', 'USA', 'USA', 'A1234567', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- The following will fail due to the unique constraint. 
-- Commented out to ensure the whole script runs smoothly without throwing an error mid-execution.
-- INSERT INTO Passengers (first_name, last_name, date_of_birth, gender, country_of_citizenship, country_of_residence, passport_number, created_at, updated_at) 
-- VALUES ('Jane', 'Smith', '1992-02-02', 'Female', 'UK', 'UK', 'A1234567', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Task 7: Index on multiple passenger details and filter check
CREATE INDEX idx_passengers_details 
ON Passengers (first_name, last_name, date_of_birth, country_of_citizenship);

EXPLAIN ANALYZE 
SELECT * FROM Passengers 
WHERE country_of_citizenship = 'Philippines' 
  AND EXTRACT(YEAR FROM date_of_birth) = 1984;

-- Task 8: List indexes for Passengers and delete them
SELECT indexname, indexdef 
FROM pg_indexes 
WHERE tablename = 'passengers';

DROP INDEX idx_passengers_passport;
DROP INDEX idx_passengers_details;

-- Task 9: Compare execution plan before and after index on passenger_id in booking
EXPLAIN ANALYZE 
SELECT * FROM booking WHERE passenger_id = 100;

CREATE INDEX idx_booking_passenger_id ON booking (passenger_id);

EXPLAIN ANALYZE 
SELECT * FROM booking WHERE passenger_id = 100;

-- Task 10: Composite index on booking_flight and Join query
CREATE INDEX idx_booking_flight_composite 
ON Booking_flight (booking_id, flight_id);

EXPLAIN ANALYZE 
SELECT f.flight_id, b.ticket_price 
FROM booking b
JOIN Booking_flight bf ON b.booking_id = bf.booking_id
JOIN flights f ON bf.flight_id = f.flight_id
WHERE b.ticket_price > 9000;

-- Task 11: Index on status in flights (Selectivity test)
-- Note: 'status' column wasn't in original schema, assuming it was added for this task.
-- ALTER TABLE flights ADD COLUMN status VARCHAR(20);
CREATE INDEX idx_flights_status ON flights (status);

EXPLAIN ANALYZE SELECT * FROM flights WHERE status = 'Departed';
EXPLAIN ANALYZE SELECT * FROM flights WHERE status = 'Boarding';

-- Task 12: Selectivity on weight_in_kg
CREATE INDEX idx_baggage_weight ON Baggage (weight_in_kg);

EXPLAIN ANALYZE SELECT * FROM Baggage WHERE weight_in_kg > 49;
EXPLAIN ANALYZE SELECT * FROM Baggage WHERE weight_in_kg > 5;

-- Task 13: LIKE queries and indexes on airport_name
CREATE INDEX idx_airport_name ON Airport (airport_name);

EXPLAIN ANALYZE SELECT * FROM Airport WHERE airport_name LIKE 'A%';
EXPLAIN ANALYZE SELECT * FROM Airport WHERE airport_name LIKE '%Airport';

-- Task 14: Leftmost prefix rule on composite index (country, city)
CREATE INDEX idx_airport_location ON Airport (country, city);

EXPLAIN ANALYZE SELECT * FROM Airport WHERE country = 'Kazakhstan';
EXPLAIN ANALYZE SELECT * FROM Airport WHERE city = 'Almaty';
EXPLAIN ANALYZE SELECT * FROM Airport WHERE country = 'Kazakhstan' AND city = 'Almaty';

-- Task 15: Functional (Expression) Index on LOWER(last_name)
CREATE INDEX idx_passengers_lower_lastname ON Passengers (LOWER(last_name));

EXPLAIN ANALYZE SELECT * FROM Passengers WHERE LOWER(last_name) = 'irnis';
EXPLAIN ANALYZE SELECT * FROM Passengers WHERE last_name = 'Irnis';

-- Task 16: Covering Index for Index-Only Scan
CREATE INDEX idx_booking_covering ON booking (passenger_id, ticket_price);

EXPLAIN ANALYZE SELECT ticket_price FROM booking WHERE passenger_id = 100;

-- Task 17: Unique index on airline_code and handling duplicates
-- Before creating this index, you must find and remove duplicates if they exist:
-- SELECT airline_code, COUNT(*) FROM Airline GROUP BY airline_code HAVING COUNT(*) > 1;
-- After cleaning up the data, create the index:
-- CREATE UNIQUE INDEX idx_airline_code_unique ON Airline (airline_code);
