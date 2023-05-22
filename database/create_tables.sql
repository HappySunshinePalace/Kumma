SHOW WARNINGS LIMIT 15;

DROP TABLE IF EXISTS recurring_pattern;
DROP TABLE IF EXISTS event_instance_exception;
DROP TABLE IF EXISTS tour;
DROP TABLE IF EXISTS driver;
DROP TABLE IF EXISTS car;
DROP TABLE IF EXISTS address;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS recurring_type;
DROP TABLE IF EXISTS tour_type;
DROP TABLE IF EXISTS location_type;
DROP TABLE IF EXISTS car_type;


CREATE TABLE recurring_type (
	id INT,
	recurring_type VARCHAR(20) NOT NULL,
	PRIMARY KEY (id)
);

CREATE TABLE tour_type (
	id INT,
	type_name VARCHAR(20),
	type_description VARCHAR(500),
	PRIMARY KEY (id)
);

CREATE TABLE location_type(
	id INT NOT NULL,
	location_type_name VARCHAR(50),
	location_type_description VARCHAR(500),
	PRIMARY KEY (id)
);

CREATE TABLE car_type (
	id INT NOT NULL,
	car_type_name VARCHAR(50),
	car_type_name_short VARCHAR(5),
	car_type_description VARCHAR(500),
	PRIMARY KEY (id)
);

-- unused
CREATE TABLE driver (
	id INT NOT NULL,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	PRIMARY KEY (id)
);

-- unused
CREATE TABLE car (
	id INT NOT NULL,
	license_plate VARCHAR(10) NOT NULL,
	car_type_id INT NOT NULL,
	customer_seats INT NOT NULL,
	has_wheelchair BOOL NOT NULL,
	is_wheelchair_friendly BOOL NOT NULL,
	has_carrying_seat BOOL NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (car_type_id) REFERENCES car_type(id)
);

CREATE TABLE tour (
	id INT NOT NULL,
	parent_event_id INT,
	type_of_tour INT,
	passenger_id INT NOT NULL,
	driver_id INT NOT NULL,
	
	-- SPECIAL CAR/EQUIPMENT REQUIREMENTS
	wheelchair_needed CHAR(1), -- still able to sit in normal car seat
	wheelchair_space_needed CHAR(1),
	carrying_chair_needed CHAR(1),
	
	-- TIME AND LOCATION
	start_date DATE NOT NULL,
	end_date DATE,
	start_time TIMESTAMP,
	appointment_time TIMESTAMP,
	end_time TIMESTAMP,
	start_location VARCHAR(50) NOT NULL,
	appointment_location VARCHAR(50),
	end_location VARCHAR(50) NOT NULL,
	is_recurring CHAR(1) NOT NULL,
	
	-- LOGGING
	created_by VARCHAR(10) NOT NULL,
	created_date DATE NOT NULL,
	call_for_retrieval_time TIMESTAMP,
	appointment_made_by VARCHAR(50),
		
	-- KEYs
	PRIMARY KEY (id),
	FOREIGN KEY (parent_event_id) REFERENCES tour(id),
	FOREIGN KEY (type_of_tour) REFERENCES tour_type(id),
	FOREIGN KEY (driver_id) REFERENCES driver(id)
);


-- unfinished
CREATE TABLE customer (
	id INT NOT NULL,
	first_name INT NOT NULL,
	last_name INT NOT NULL,
	PRIMARY KEY (id)
);

-- unfinished
CREATE TABLE address (
	id INT NOT NULL,
	street VARCHAR(50),
	house_number VARCHAR(10),
	postal_code INT,
	city VARCHAR(50),
	location_type INT,
	PRIMARY KEY (id),
	FOREIGN KEY (location_type) REFERENCES location_type(id)
);


CREATE TABLE event_instance_exception (
	id INT NOT NULL,
	event_id INT NOT NULL,
	is_rescheduled CHAR(1) NOT NULL,
	id_cancelled CHAR(1) NOT NULL,
	start_date DATE NOT NULL,
	end_date DATE,
	start_time TIMESTAMP,
	end_time TIMESTAMP,
	is_full_day_event CHAR(1),
	created_by VARCHAR(10) NOT NULL,
	created_date DATE NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (event_id) REFERENCES tour(id)
);

CREATE TABLE recurring_pattern (
	event_id INT,
	recurring_type_id INT NOT NULL,
	separation_count INT DEFAULT NULL,
	max_num_of_occurrences INT DEFAULT NULL,
	day_of_week INT DEFAULT NULL,
	week_of_month INT DEFAULT NULL,
	day_of_month INT DEFAULT NULL,
	month_of_year INT DEFAULT NULL,
	PRIMARY KEY (event_id),
	FOREIGN KEY (event_id) REFERENCES tour(id),
	FOREIGN KEY (recurring_type_id) REFERENCES recurring_type(id)
);