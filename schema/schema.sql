-- =================================================================
-- EX 603 Assignment 2 — schema.sql
-- Theme: Rental Marketplac
-- Author: Diana Cristina Terry
-- Target: PostgreSQL 14+
-- =================================================================
-- Reset. Reverse creation order, so no dependency blocks a drop.



DROP TABLE IF EXISTS listing_amenities CASCADE;
DROP TABLE IF EXISTS user_viewing CASCADE;
DROP TABLE IF EXISTS user_property CASCADE;
DROP TABLE IF EXISTS viewing CASCADE;
DROP TABLE IF EXISTS amenities CASCADE;
DROP TABLE IF EXISTS property CASCADE;
DROP TABLE IF EXISTS users CASCADE;


CREATE TABLE users(
	user_id INTEGER GENERATED ALWAYS AS IDENTITY Primary key,
	first_name VARCHAR (255) NOT NULL,
	last_name VARCHAR(255) NOT  NULL, 
	address VARCHAR(255),
	email VARCHAR(255) NOT NULL UNIQUE, 
	phone_number VARCHAR(20),
	ssn VARCHAR(11) UNIQUE	
);

CREATE TABLE property(
	property_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	property_name VARCHAR(255),
	address VARCHAR(255) NOT NULL,
	is_available BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE amenities(
	amenity_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	amenity_name VARCHAR(255),
	amenity_description VARCHAR(255),
	size INTEGER
);
CREATE TABLE viewing(
	viewing_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
	property_id INTEGER NOT NULL, 
	viewing_time TIMESTAMP NOT NULL,
	total_attendees INTEGER NOT NULL,
	duration_min INTEGER NOT NULL,
	
	FOREIGN KEY (property_id) REFERENCES property(property_id) ON DELETE RESTRICT, 
	
	CHECK (total_attendees>=1),
	CHECK (duration_min>0)
);

CREATE TABLE user_property(
	user_id INTEGER,
	property_id INTEGER, 
	PRIMARY KEY(user_id, property_id),
	FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE RESTRICT,
	FOREIGN KEY (property_id) REFERENCES property(property_id) ON DELETE CASCADE
);

CREATE TABLE user_viewing(
	viewing_id INTEGER,
	user_id INTEGER, 
	PRIMARY KEY(viewing_id, user_id),
	FOREIGN KEY(viewing_id) REFERENCES viewing(viewing_id) ON DELETE CASCADE,
	FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE RESTRICT
);

CREATE TABLE listing_amenities(
	amenity_id INTEGER, 
	property_id INTEGER,
	PRIMARY KEY (amenity_id, property_id),

	FOREIGN KEY (amenity_id) REFERENCES amenities(amenity_id) ON DELETE CASCADE,
	FOREIGN KEY (property_id) REFERENCES property(property_id)	ON DELETE CASCADE
);



