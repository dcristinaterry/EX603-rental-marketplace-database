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
	
	email VARCHAR(255) NOT NULL,
	phone_number VARCHAR(20),
	ssn VARCHAR(11) UNIQUE

	CONSTRAINT uq_user_email UNIQUE (email),
	CONSTRAINT uq_users_ssn UNIQUE (ssn),
	CONSTRAINT chk_user_email,
		CHECK (email LIKE '%@%.%')
);

CREATE TABLE property(
	property_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	property_name VARCHAR(255),
	address VARCHAR(255) NOT NULL,
	is_available BOOLEAN NOT NULL DEFAULT TRUE,

	CONSTRAINT chk_is_available_property
		CHECK (is_available = TRUE OR is_available=FALSE)
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
	

	CONSTRAINT fk_viewing_property
		FOREIGN KEY (property_id) REFERENCES property(property_id) ON DELETE RESTRICT, 
	
	CONSTRAINT chk_number_attendees
		CHECK (total_attendees>=1),
	CONSTRAINT chk_viewing_duration	
		CHECK (duration_min>0)
);

CREATE TABLE user_property(
	user_id INTEGER,
	property_id INTEGER, 

	CONSTRAINT pk_user_property
		PRIMARY KEY(user_id, property_id),
	CONSTRAINT fk_user_id_user_property
		FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE RESTRICT,
	CONSTRAINT fk_property_id_user_property
		FOREIGN KEY (property_id) REFERENCES property(property_id) ON DELETE CASCADE
);

CREATE TABLE user_viewing(
	viewing_id INTEGER,
	user_id INTEGER, 

	CONSTRAINT pk_user_viewing
		PRIMARY KEY(viewing_id, user_id),

	CONSTRAINT fk_viewing_id_user_viewing
		FOREIGN KEY(viewing_id) REFERENCES viewing(viewing_id) ON DELETE CASCADE,
	CONSTRAINT fk_user_id_user_viewing	
		FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE RESTRICT
);

CREATE TABLE listing_amenities(
	amenity_id INTEGER, 
	property_id INTEGER,

	CONSTRAINT pk_listing_amenities
		PRIMARY KEY (amenity_id, property_id),

	CONSTRAINT fk_amenity_id_listing_amenities
		FOREIGN KEY (amenity_id) REFERENCES amenities(amenity_id) ON DELETE CASCADE,
	CONSTRAINT fk_property_id_listing_amenities	
		FOREIGN KEY (property_id) REFERENCES property(property_id)	ON DELETE CASCADE
);



