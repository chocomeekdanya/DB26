-- Laboratory Work #2: Normalization and DDL

CREATE TABLE airline (
    airline_id INT PRIMARY KEY,
    airline_name VARCHAR(100) NOT NULL
);

CREATE TABLE airport (
    airport_id INT PRIMARY KEY,
    airport_name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL
);

CREATE TABLE passenger (
    passport_number VARCHAR(20) PRIMARY KEY,
    passenger_full_name VARCHAR(100) NOT NULL
);

CREATE TABLE flight (
    flight_number VARCHAR(20) PRIMARY KEY,
    departure_airport_id INT NOT NULL,
    arrival_airport_id INT NOT NULL,
    airline_id INT NOT NULL,
    FOREIGN KEY (departure_airport_id) REFERENCES airport(airport_id),
    FOREIGN KEY (arrival_airport_id) REFERENCES airport(airport_id),
    FOREIGN KEY (airline_id) REFERENCES airline(airline_id)
);

CREATE TABLE booking (
    booking_id INT PRIMARY KEY,
    flight_number VARCHAR(20) NOT NULL,
    FOREIGN KEY (flight_number) REFERENCES flight(flight_number)
);

CREATE TABLE booking_passenger (
    booking_id INT NOT NULL,
    passport_number VARCHAR(20) NOT NULL,
    seat_number VARCHAR(10) NOT NULL,
    ticket_price DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (booking_id, passport_number),
    FOREIGN KEY (booking_id) REFERENCES booking(booking_id),
    FOREIGN KEY (passport_number) REFERENCES passenger(passport_number)
);

INSERT INTO airline VALUES
(1, 'Air Astana'),
(2, 'FlyArystan'),
(3, 'SCAT Airlines'),
(4, 'Qazaq Air'),
(5, 'Turkish Airlines');

INSERT INTO airport VALUES
(1, 'Almaty International Airport', 'Almaty'),
(2, 'Nursultan Nazarbayev International Airport', 'Astana'),
(3, 'Shymkent International Airport', 'Shymkent'),
(4, 'Aktau International Airport', 'Aktau'),
(5, 'Tashkent International Airport', 'Tashkent');

INSERT INTO passenger VALUES
('P1001', 'Aidar Karimov'),
('P1002', 'Mira Lee'),
('P1003', 'Daniyar Kim'),
('P1004', 'Sofia Park'),
('P1005', 'Timur Sadyk');

INSERT INTO flight VALUES
('KC101', 1, 2, 1),
('FS202', 2, 1, 2),
('KC303', 1, 3, 1),
('FS404', 3, 2, 2),
('TK505', 1, 5, 5);

INSERT INTO booking VALUES
(1001, 'KC101'),
(1002, 'FS202'),
(1003, 'KC303'),
(1004, 'FS404'),
(1005, 'TK505');

INSERT INTO booking_passenger VALUES
(1001, 'P1001', '12A', 55000.00),
(1001, 'P1002', '12B', 55000.00),
(1002, 'P1003', '18C', 42000.00),
(1003, 'P1004', '7A', 47000.00),
(1004, 'P1005', '20D', 39000.00);

-- DDL section

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

CREATE TABLE booking (
    booking_id INT NOT NULL,
    flight_id INT NOT NULL,
    passenger_id INT NOT NULL,
    booking_platform VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    status VARCHAR(50) NOT NULL,
    price DECIMAL(7,2) NOT NULL,
    PRIMARY KEY (booking_id)
);

CREATE TABLE booking_flight (
    booking_flight_id INT NOT NULL,
    booking_id INT NOT NULL,
    flight_id INT NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    PRIMARY KEY (booking_flight_id)
);

CREATE TABLE baggage (
    baggage_id INT NOT NULL,
    weight_in_kg DECIMAL(4,2) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    booking_id INT NOT NULL,
    PRIMARY KEY (baggage_id)
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

CREATE TABLE boarding_pass (
    boarding_pass_id INT NOT NULL,
    booking_id INT NOT NULL,
    seat VARCHAR(50) NOT NULL,
    boarding_time TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    PRIMARY KEY (boarding_pass_id)
);

CREATE TABLE security_check (
    security_check_id INT NOT NULL,
    check_result VARCHAR(20) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    passenger_id INT NOT NULL,
    PRIMARY KEY (security_check_id)
);

ALTER TABLE airline_info RENAME TO airline;

ALTER TABLE booking
RENAME COLUMN price TO ticket_price;

ALTER TABLE flights
MODIFY COLUMN departing_gate TEXT NOT NULL;

ALTER TABLE airline
DROP COLUMN info;

ALTER TABLE security_check
ADD CONSTRAINT fk_security_passenger
FOREIGN KEY (passenger_id) REFERENCES passengers(passenger_id);

ALTER TABLE booking
ADD CONSTRAINT fk_booking_passenger
FOREIGN KEY (passenger_id) REFERENCES passengers(passenger_id);

ALTER TABLE baggage_check
ADD CONSTRAINT fk_baggage_check_passenger
FOREIGN KEY (passenger_id) REFERENCES passengers(passenger_id);

ALTER TABLE booking_flight
ADD CONSTRAINT fk_booking_flight_booking
FOREIGN KEY (booking_id) REFERENCES booking(booking_id);

ALTER TABLE baggage
ADD CONSTRAINT fk_baggage_booking
FOREIGN KEY (booking_id) REFERENCES booking(booking_id);

ALTER TABLE baggage_check
ADD CONSTRAINT fk_baggage_check_booking
FOREIGN KEY (booking_id) REFERENCES booking(booking_id);

ALTER TABLE boarding_pass
ADD CONSTRAINT fk_boarding_booking
FOREIGN KEY (booking_id) REFERENCES booking(booking_id);

ALTER TABLE booking_flight
ADD CONSTRAINT fk_booking_flight_flight
FOREIGN KEY (flight_id) REFERENCES flights(flight_id);

ALTER TABLE flights
ADD CONSTRAINT fk_flight_departing_airport
FOREIGN KEY (departing_airport_id) REFERENCES airport(airport_id);

ALTER TABLE flights
ADD CONSTRAINT fk_flight_arriving_airport
FOREIGN KEY (arriving_airport_id) REFERENCES airport(airport_id);

ALTER TABLE flights
ADD CONSTRAINT fk_flight_airline
FOREIGN KEY (airline_id) REFERENCES airline(airline_id);
