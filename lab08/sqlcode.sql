-- ============================================================================
-- LABORATORY WORK #8: VIEWS AND ROLES (PostgreSQL)
-- Student: Pushkin Daniil | Group: DB26
-- ============================================================================

-- ----------------------------------------------------------------------------
-- OPTIONAL DATA INSERTS FOR NEXT-7-DAYS TASKS (Tasks 2 & 5)
-- Ensures flights exist within [CURRENT_DATE, CURRENT_DATE + INTERVAL '7 days']
-- ----------------------------------------------------------------------------
INSERT INTO flights (
    flight_id, sch_departure_time, sch_arrival_time,
    departing_airport_id, arriving_airport_id,
    departing_gate, arriving_gate, airline_id,
    actual_departure_time, actual_arrival_time,
    created_at, updated_at, status
) VALUES
(
    1001,
    CURRENT_TIMESTAMP + INTERVAL '2 days',
    CURRENT_TIMESTAMP + INTERVAL '2 days 4 hours',
    1, 2, 'A1', 'B3', 1,
    CURRENT_TIMESTAMP + INTERVAL '2 days',
    CURRENT_TIMESTAMP + INTERVAL '2 days 4 hours',
    CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Scheduled'
),
(
    1002,
    CURRENT_TIMESTAMP + INTERVAL '5 days',
    CURRENT_TIMESTAMP + INTERVAL '5 days 3 hours',
    10, 7, 'C4', 'D2', 1,
    CURRENT_TIMESTAMP + INTERVAL '5 days',
    CURRENT_TIMESTAMP + INTERVAL '5 days 3 hours',
    CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Scheduled'
);

INSERT INTO booking (
    booking_id, flight_id, passenger_id, booking_platform,
    created_at, updated_at, status, ticket_price
) VALUES
(
    501, 1001, 1, 'Leffler-Thompson',
    CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Confirmed', 450.00
),
(
    502, 1002, 2, 'SkyScanner',
    CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Confirmed', 620.50
);

INSERT INTO Booking_flight (
    booking_flight_id, booking_id, flight_id, created_at, updated_at
) VALUES
(1001, 501, 1001, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1002, 502, 1002, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


-- ============================================================================
-- PART 1: VIEWS
-- ============================================================================

-- Task 1: Create a view to show details of all flights departing on a specific date
CREATE OR REPLACE VIEW v_flights_specific_date AS
SELECT
    f.flight_id,
    a.airline_name,
    dep.airport_name AS departing_airport,
    arr.airport_name AS arriving_airport,
    f.sch_departure_time,
    f.sch_arrival_time,
    f.departing_gate,
    f.arriving_gate,
    f.status
FROM flights f
JOIN Airline a ON f.airline_id = a.airline_id
JOIN Airport dep ON f.departing_airport_id = dep.airport_id
JOIN Airport arr ON f.arriving_airport_id = arr.airport_id
WHERE DATE(f.sch_departure_time) = '2023-11-22';

SELECT * FROM v_flights_specific_date;


-- Task 2: Create a view that shows bookings for flights scheduled to depart within the next week
CREATE OR REPLACE VIEW v_bookings_next_week AS
SELECT
    b.booking_id,
    p.first_name || ' ' || p.last_name AS passenger_name,
    b.booking_platform,
    b.status AS booking_status,
    b.ticket_price,
    f.flight_id,
    f.sch_departure_time,
    f.sch_arrival_time
FROM booking b
JOIN Passengers p ON b.passenger_id = p.passenger_id
JOIN Booking_flight bf ON b.booking_id = bf.booking_id
JOIN flights f ON bf.flight_id = f.flight_id
WHERE f.sch_departure_time >= CURRENT_TIMESTAMP
  AND f.sch_departure_time <= CURRENT_TIMESTAMP + INTERVAL '7 days';

SELECT * FROM v_bookings_next_week;


-- Task 3: Create a view to show the top 5 most popular flight routes based on the number of bookings
CREATE OR REPLACE VIEW v_top5_popular_routes AS
SELECT
    dep.airport_name AS departure_airport,
    dep.city AS departure_city,
    arr.airport_name AS arrival_airport,
    arr.city AS arrival_city,
    COUNT(bf.booking_id) AS total_bookings
FROM Booking_flight bf
JOIN flights f ON bf.flight_id = f.flight_id
JOIN Airport dep ON f.departing_airport_id = dep.airport_id
JOIN Airport arr ON f.arriving_airport_id = arr.airport_id
GROUP BY dep.airport_name, dep.city, arr.airport_name, arr.city
ORDER BY total_bookings DESC
LIMIT 5;

SELECT * FROM v_top5_popular_routes;


-- Task 4: Create a view that lists all flights for a specific airline
CREATE OR REPLACE VIEW v_airline_flights AS
SELECT
    f.flight_id,
    a.airline_id,
    a.airline_name,
    a.airline_code,
    f.departing_airport_id,
    f.arriving_airport_id,
    f.sch_departure_time,
    f.sch_arrival_time,
    f.status
FROM flights f
JOIN Airline a ON f.airline_id = a.airline_id
WHERE a.airline_id = 1;

SELECT * FROM v_airline_flights LIMIT 10;


-- Task 5: Modify the view created in task 4 to show only flights departing within the next 7 days for a specific airline
CREATE OR REPLACE VIEW v_airline_flights AS
SELECT
    f.flight_id,
    a.airline_id,
    a.airline_name,
    a.airline_code,
    f.departing_airport_id,
    f.arriving_airport_id,
    f.sch_departure_time,
    f.sch_arrival_time,
    f.status
FROM flights f
JOIN Airline a ON f.airline_id = a.airline_id
WHERE a.airline_id = 1
  AND f.sch_departure_time >= CURRENT_TIMESTAMP
  AND f.sch_departure_time <= CURRENT_TIMESTAMP + INTERVAL '7 days';

SELECT * FROM v_airline_flights;


-- Task 6: Create a view to show flights that are delayed by more than 24 hours
CREATE OR REPLACE VIEW v_delayed_flights_24h AS
SELECT
    flight_id,
    airline_id,
    departing_airport_id,
    arriving_airport_id,
    sch_departure_time,
    actual_departure_time,
    (actual_departure_time - sch_departure_time) AS delay_duration,
    status
FROM flights
WHERE actual_departure_time - sch_departure_time > INTERVAL '24 hours';

SELECT * FROM v_delayed_flights_24h LIMIT 10;


-- Task 7: Create a view displaying full name and country of origin of passengers who made bookings on Leffler-Thompson platform
CREATE OR REPLACE VIEW v_leffler_thompson_passengers AS
SELECT DISTINCT
    p.passenger_id,
    p.first_name || ' ' || p.last_name AS full_name,
    p.country_of_citizenship AS country_of_origin
FROM Passengers p
JOIN booking b ON p.passenger_id = b.passenger_id
WHERE b.booking_platform = 'Leffler-Thompson';

SELECT * FROM v_leffler_thompson_passengers;


-- Task 8: Create a view that shows top 10 most visited countries
CREATE OR REPLACE VIEW v_top10_visited_countries AS
SELECT
    arr.country AS destination_country,
    COUNT(bf.booking_id) AS visit_count
FROM Booking_flight bf
JOIN flights f ON bf.flight_id = f.flight_id
JOIN Airport arr ON f.arriving_airport_id = arr.airport_id
GROUP BY arr.country
ORDER BY visit_count DESC
LIMIT 10;

SELECT * FROM v_top10_visited_countries;


-- Task 9: Update any of the created views by adding new information in the view table. Show results.
-- Create a simple updatable single-table view on Airline (required by PostgreSQL auto-updatable view rules)
CREATE OR REPLACE VIEW v_updatable_airlines AS
SELECT
    airline_id,
    airline_code,
    airline_name,
    airline_country,
    created_at,
    updated_at,
    airline_info
FROM Airline
WHERE airline_country = 'Kazakhstan';

INSERT INTO v_updatable_airlines (
    airline_id, airline_code, airline_name, airline_country,
    created_at, updated_at, airline_info
) VALUES (
    51, 'KZR', 'Air Astana', 'Kazakhstan',
    CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Flag Carrier'
);

SELECT * FROM v_updatable_airlines;


-- Task 10: Drop all existing views
DROP VIEW IF EXISTS v_flights_specific_date;
DROP VIEW IF EXISTS v_bookings_next_week;
DROP VIEW IF EXISTS v_top5_popular_routes;
DROP VIEW IF EXISTS v_airline_flights;
DROP VIEW IF EXISTS v_delayed_flights_24h;
DROP VIEW IF EXISTS v_leffler_thompson_passengers;
DROP VIEW IF EXISTS v_top10_visited_countries;
DROP VIEW IF EXISTS v_updatable_airlines;


-- ============================================================================
-- PART 2: ROLES AND PRIVILEGES
-- ============================================================================

-- Task 11: Create the group roles flight_manager and flight_analyst, then show the list of roles
CREATE ROLE flight_manager NOLOGIN;
CREATE ROLE flight_analyst NOLOGIN;

SELECT rolname, rolsuper, rolinherit, rolcreaterole, rolcreatedb, rolcanlogin, rolconnlimit
FROM pg_roles
WHERE rolname IN ('flight_manager', 'flight_analyst');


-- Task 12: Create the users first_user and second_user and add them to the group roles
CREATE USER first_user WITH PASSWORD 'FirstUser123!';
CREATE USER second_user WITH PASSWORD 'SecondUser123!';

GRANT flight_manager TO first_user;
GRANT flight_analyst TO second_user;

SELECT r.rolname AS group_role, m.rolname AS member_user
FROM pg_auth_members am
JOIN pg_roles r ON am.roleid = r.oid
JOIN pg_roles m ON am.member = m.oid
WHERE r.rolname IN ('flight_manager', 'flight_analyst');


-- Task 13: Grant flight_analyst SELECT on the flights, airlines and bookings tables
GRANT SELECT ON flights, Airline, booking TO flight_analyst;


-- Task 14: Grant flight_manager SELECT, INSERT and UPDATE on bookings, and SELECT on the other tables
GRANT SELECT, INSERT, UPDATE ON booking TO flight_manager;
GRANT USAGE, SELECT ON SEQUENCE booking_booking_id_seq TO flight_manager;
GRANT SELECT ON Airline, Airport, Baggage, Baggage_check, Boarding_pass, Booking_flight, flights, Passengers, Security_check TO flight_manager;


-- Task 15: Connect as second_user, read flights and try to delete from bookings
SET ROLE second_user;
SELECT flight_id, departing_airport_id, arriving_airport_id, status FROM flights LIMIT 3;
-- Attempting DELETE (will raise ERROR: permission denied for table booking):
DELETE FROM booking WHERE booking_id = 502;
RESET ROLE;


-- Task 16: Connect as first_user, insert and update a booking, and try to delete one
SET ROLE first_user;
INSERT INTO booking (booking_id, flight_id, passenger_id, booking_platform, created_at, updated_at, status, ticket_price)
VALUES (503, 1, 1, 'Direct Web', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'Confirmed', 310.00);

UPDATE booking
SET ticket_price = 345.00, status = 'Paid'
WHERE booking_id = 503;

SELECT booking_id, passenger_id, booking_platform, status, ticket_price
FROM booking
WHERE booking_id = 503;

-- Attempting DELETE (will raise ERROR: permission denied for table booking):
DELETE FROM booking WHERE booking_id = 503;
RESET ROLE;


-- Task 17: Grant column-level SELECT on only the full name and country columns of passengers
GRANT SELECT (first_name, last_name, country_of_citizenship) ON Passengers TO flight_analyst;

SET ROLE second_user;
SELECT first_name, last_name, country_of_citizenship FROM Passengers LIMIT 3;
-- Attempting to read unauthorized column (will raise ERROR: permission denied for table passengers):
SELECT passport_number FROM Passengers LIMIT 1;
RESET ROLE;


-- Task 18: Revoke SELECT on bookings from flight_analyst and show that access is denied
REVOKE SELECT ON booking FROM flight_analyst;

SET ROLE second_user;
-- Attempting SELECT (will raise ERROR: permission denied for table booking):
SELECT * FROM booking LIMIT 1;
RESET ROLE;


-- Task 19: Alter the roles: change a password, set a connection limit and rename a role
ALTER USER first_user WITH PASSWORD 'NewSecurePass2026!';
ALTER USER second_user WITH CONNECTION LIMIT 5;
ALTER ROLE flight_analyst RENAME TO senior_flight_analyst;

SELECT rolname, rolcanlogin, rolconnlimit
FROM pg_roles
WHERE rolname IN ('first_user', 'second_user', 'flight_manager', 'senior_flight_analyst');


-- Task 20: Drop all created roles
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM flight_manager, senior_flight_analyst;
REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public FROM flight_manager, senior_flight_analyst;

DROP USER IF EXISTS first_user;
DROP USER IF EXISTS second_user;
DROP ROLE IF EXISTS flight_manager;
DROP ROLE IF EXISTS senior_flight_analyst;
