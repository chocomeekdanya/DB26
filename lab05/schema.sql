-- ==========================================
-- 1. DDL: TABLE CREATION (Lab 2)
-- ==========================================
CREATE TABLE Airline (
    airline_id INT PRIMARY KEY,
    airline_code VARCHAR(30) NOT NULL,
    airline_name VARCHAR(50) NOT NULL,
    airline_country VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE Airport (
    airport_id INT PRIMARY KEY,
    airport_name VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    state VARCHAR(50),
    city VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE Passengers (
    passenger_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(50) NOT NULL,
    country_of_citizenship VARCHAR(50) NOT NULL,
    country_of_residence VARCHAR(50) NOT NULL,
    passport_number VARCHAR(20) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE Flights (
    flight_id INT PRIMARY KEY,
    sch_departure_time TIMESTAMP NOT NULL,
    sch_arrival_time TIMESTAMP NOT NULL,
    departing_airport_id INT NOT NULL REFERENCES Airport(airport_id),
    arriving_airport_id INT NOT NULL REFERENCES Airport(airport_id),
    departing_gate TEXT NOT NULL,
    arriving_gate VARCHAR(50) NOT NULL,
    airline_id INT NOT NULL REFERENCES Airline(airline_id),
    act_departure_time TIMESTAMP,
    act_arrival_time TIMESTAMP,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE Booking (
    booking_id INT PRIMARY KEY,
    flight_id INT NOT NULL REFERENCES Flights(flight_id),
    passenger_id INT NOT NULL REFERENCES Passengers(passenger_id),
    booking_platform VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    status VARCHAR(50) NOT NULL,
    ticket_price DECIMAL(10,2) NOT NULL
);

CREATE TABLE Baggage_check (
    baggage_check_id INT PRIMARY KEY,
    check_result VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    booking_id INT NOT NULL REFERENCES Booking(booking_id),
    passenger_id INT NOT NULL REFERENCES Passengers(passenger_id)
);

CREATE TABLE Baggage (
    baggage_id INT PRIMARY KEY,
    weight_in_kg DECIMAL(4,2) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    booking_id INT NOT NULL REFERENCES Booking(booking_id)
);

CREATE TABLE Boarding_pass (
    boarding_pass_id INT PRIMARY KEY,
    booking_id INT NOT NULL REFERENCES Booking(booking_id),
    seat VARCHAR(50) NOT NULL,
    boarding_time TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE Booking_flight (
    booking_flight_id INT PRIMARY KEY,
    booking_id INT NOT NULL REFERENCES Booking(booking_id),
    flight_id INT NOT NULL REFERENCES Flights(flight_id),
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE TABLE Security_check (
    security_check_id INT PRIMARY KEY,
    check_result VARCHAR(20) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    passenger_id INT NOT NULL REFERENCES Passengers(passenger_id)
);

-- ==========================================
-- 2. ADVANCED CONSTRAINTS (Lab 5)
-- ==========================================
ALTER TABLE Passengers ADD CONSTRAINT chk_passenger_age CHECK (date_of_birth <= '2016-10-12');
ALTER TABLE Booking ADD CONSTRAINT chk_ticket_price CHECK (ticket_price >= 0 AND ticket_price <= 50000);
ALTER TABLE Baggage ADD CONSTRAINT chk_weight CHECK (weight_in_kg >= 1 AND weight_in_kg <= 23);
ALTER TABLE Airport ADD CONSTRAINT chk_airport_name_len CHECK (LENGTH(airport_name) >= 10);

ALTER TABLE Airline ADD CONSTRAINT uq_airline_code UNIQUE (airline_code);
ALTER TABLE Airport ADD CONSTRAINT uq_airport_name UNIQUE (airport_name);
ALTER TABLE Passengers ADD CONSTRAINT uq_passport UNIQUE (passport_number);
ALTER TABLE Boarding_pass ADD CONSTRAINT uq_boarding_seat UNIQUE (booking_id, seat);

ALTER TABLE Passengers ADD CONSTRAINT chk_gender_age CHECK (
    (gender = 'Male' AND date_of_birth <= '2008-10-12') OR 
    (gender = 'Female' AND date_of_birth <= '2007-10-12')
);

ALTER TABLE Passengers ADD CONSTRAINT chk_country_age CHECK (
    (country_of_citizenship = 'Kazakhstan' AND date_of_birth <= '2008-10-12') OR 
    (country_of_citizenship = 'France' AND date_of_birth <= '2009-10-12') OR 
    (country_of_citizenship NOT IN ('Kazakhstan', 'France') AND date_of_birth <= '2007-10-12')
);

ALTER TABLE Booking ADD COLUMN ticket_discount DECIMAL(10,2);
ALTER TABLE Booking ADD CONSTRAINT chk_discount_logic CHECK (
    (created_at > '2024-01-01' AND ticket_discount = ticket_price * 0.05) OR 
    (created_at <= '2024-01-01' AND ticket_discount = ticket_price * 0.10)
);

ALTER TABLE Booking ALTER COLUMN status SET DEFAULT 'Confirmed';
