SHOW WARNINGS LIMIT 15;

DROP TABLE IF EXISTS recurring_pattern;
DROP TABLE IF EXISTS event_instance_exception;
DROP TABLE IF EXISTS atomic_tour;
DROP TABLE IF EXISTS tour_set;
DROP TABLE IF EXISTS tour_for_driver;
DROP TABLE IF EXISTS driver;
DROP TABLE IF EXISTS car;
DROP TABLE IF EXISTS address;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS recurring_type;
DROP TABLE IF EXISTS location_type;
DROP TABLE IF EXISTS car_type;
DROP TABLE IF EXISTS accessibility_type;


CREATE TABLE recurring_type (
	id INT PRIMARY KEY,
	recurring_type VARCHAR(20) NOT NULL
);

CREATE TABLE accessibility_type (
	id INT PRIMARY KEY,
	type_name VARCHAR(20), -- stufenlos, 1-2 Stufen, weniger als eine Etage, mehr als eine Etage
	type_description VARCHAR(500)
);

CREATE TABLE location_type(
	id INT NOT NULL PRIMARY KEY,
	location_type_name VARCHAR(50),
	location_type_description VARCHAR(500)
);

CREATE TABLE car_type (
	id INT PRIMARY KEY,
	car_type_name VARCHAR(50),
	car_type_name_short VARCHAR(5),
	car_type_description VARCHAR(500)
);

-- unused
CREATE TABLE driver (
	id INT PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50)
);

-- unused
CREATE TABLE car (
	id INT PRIMARY KEY,
	license_plate VARCHAR(10) NOT NULL,
	car_type_id INT NOT NULL,
	customer_seats INT NOT NULL,
	has_wheelchair BOOL NOT NULL,
	is_wheelchair_friendly BOOL NOT NULL,
	has_carrying_seat BOOL NOT NULL,
	FOREIGN KEY (car_type_id) REFERENCES car_type(id)
);

CREATE TABLE tour_for_driver (
	id INT PRIMARY KEY,
	driver_id INT NOT NULL,
	car_id INT NOT NULL,
	
	FOREIGN KEY (driver_id) REFERENCES driver(id),
	FOREIGN KEY (car_id) REFERENCES car(id)
);

-- unfinished
CREATE TABLE customer (
	id INT PRIMARY KEY,
	first_name INT NOT NULL,
	last_name INT NOT NULL,
	STATUS_id INT NOT NULL -- todo:FOREIGN  key fehlt noch
);

-- unfinished
CREATE TABLE address (
	id INT PRIMARY KEY,
	accessibility_id INT,
	street VARCHAR(50),
	label VARCHAR (50),
	location_detail VARCHAR(50), -- Etage, 'Wohnung rechts', ...
	location_comment VARCHAR(50), -- 'bissiger Hund'
	house_number VARCHAR(10),
	postal_code INT,
	city VARCHAR(50),
	location_type INT,
	FOREIGN KEY (location_type) REFERENCES location_type(id),
	FOREIGN KEY (accessibility_id) REFERENCES accessibility_type(id)
);

CREATE TABLE tour_set (
	id INT PRIMARY KEY,
	payed_car_type INT, -- KK: Mietwagen, Mietwagen mit Rollstuhl (BTW), Mietwagen mit Tragestuhl (TSW) 
	passenger_id INT NOT NULL,
	
	-- LOGGING
	created_by VARCHAR(10) NOT NULL,
	created_date DATE NOT NULL,
	
	-- KEYs
	FOREIGN KEY (payed_car_type) REFERENCES car_type(id),
	FOREIGN KEY (passenger_id) REFERENCES customer(id)
);

CREATE TABLE atomic_tour (
	id INT PRIMARY KEY,
	tour_set_id INT NOT NULL,
	details VARCHAR(50),
	
	-- SPECIAL CAR/EQUIPMENT REQUIREMENTS
	wheelchair_needed BOOL, -- still able to sit in normal car seat
	wheelchair_space_needed BOOL,
	carrying_chair_needed BOOL,
	
	-- TIME AND LOCATION
	start_date DATE NOT NULL,
	end_date DATE,
	is_recurring BOOL NOT NULL,
	start_time TIMESTAMP,
	end_time TIMESTAMP,
	start_location INT,
	end_location INT,

	-- LOGGING
	call_for_retrieval_time TIMESTAMP,
	appointment_made_by VARCHAR(50),
		
	-- KEYs
	FOREIGN KEY (tour_set_id) REFERENCES tour_set(id),
	FOREIGN KEY (start_location) REFERENCES address(id),
	FOREIGN KEY (end_location) REFERENCES address(id)
);

CREATE TABLE event_instance_exception (
	id INT PRIMARY KEY,
	atomic_tour_id INT NOT NULL,
	
	-- EXCEPTION FLAG
	is_rescheduled BOOL NOT NULL,
	is_cancelled BOOL NOT NULL,
	car_requirements_changed BOOL NOT NULL,
	location_changed BOOL NOT NULL,
	
	
	tour_set_id INT NOT NULL,
	driver_id INT,
	
	-- SPECIAL CAR/EQUIPMENT REQUIREMENTS
	wheelchair_needed BOOL, -- still able to sit in normal car seat
	wheelchair_space_needed BOOL,
	carrying_chair_needed BOOL,
	
	-- TIME AND LOCATION
	start_date DATE NOT NULL,
	end_date DATE,
	is_recurring BOOL NOT NULL,
	start_time TIMESTAMP,
	end_time TIMESTAMP,
	start_location INT,
	end_location INT,

	-- LOGGING
	call_for_retrieval_time TIMESTAMP,
	appointment_made_by VARCHAR(50),
		
	-- KEYs
	FOREIGN KEY (driver_id) REFERENCES driver(id),
	FOREIGN KEY (tour_set_id) REFERENCES tour_set(id),
	FOREIGN KEY (start_location) REFERENCES address(id),
	FOREIGN KEY (end_location) REFERENCES address(id)
);

CREATE TABLE recurring_pattern (
	tour_set_id INT PRIMARY KEY,
	
	-- repetition details
	recurring_type_id INT NOT NULL,
	separation_count INT DEFAULT NULL,   -- eg. 1, if only every two weeks instead of every week
	max_num_of_occurrences INT DEFAULT NULL,
	
	-- base date for repetition
	day_of_week INT DEFAULT NULL,
	week_of_month INT DEFAULT NULL,
	month_of_year INT DEFAULT NULL,
	monday BOOL DEFAULT NULL,
	tuesday BOOL DEFAULT NULL,
	wednesday BOOL DEFAULT NULL,
	thursday BOOL DEFAULT NULL,
	friday BOOL DEFAULT NULL,
	saturday BOOL DEFAULT NULL,
	sunday BOOL DEFAULT NULL,
	
	FOREIGN KEY (tour_set_id) REFERENCES tour_set(id),
	FOREIGN KEY (recurring_type_id) REFERENCES recurring_type(id)
);