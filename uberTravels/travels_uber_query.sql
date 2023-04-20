CREATE SCHEMA travels
    AUTHORIZATION postgres;
	
CREATE TABLE
	travels.time_zone (
		city VARCHAR(50) PRIMARY KEY,
		offset_sec INT NOT NULL
	);

CREATE TABLE
	travels.travels (
		city VARCHAR(50) REFERENCES travels.time_zone(city),
		product_type VARCHAR(50),
		trip_or_order_status VARCHAR(50),
		request_time VARCHAR(50),
		begin_trip_time VARCHAR(50),
		begin_trip_lat FLOAT,
		begin_trip_lng FLOAT,
		begin_trip_address VARCHAR(250),
		dropoff_time VARCHAR(50),
		dropoff_lat FLOAT,
		dropoff_lng FLOAT,
		dropoff_address VARCHAR(250),
		distance_km FLOAT,
		fare_amount FLOAT,
		fare_currency VARCHAR(10)
	);
	
INSERT INTO travels.time_zone VALUES 
	('Fortaleza', -10800),
	('Sao Paulo', -10800),
	('Porto Alegre', -10800),
	('Sydney', 36000),
	('Recife', -10800),
	('Sao Luis', -10800);
	
COPY travels.travels
FROM 'C:\Users\Public\trips_data.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE travels.travels_2 AS
	(SELECT * FROM travels.travels
	LEFT OUTER JOIN travels.time_zone
	USING (city));
	
UPDATE travels.travels_2
SET request_time = SPLIT_PART (request_time, ' +', 1);

UPDATE travels.travels_2
SET begin_trip_time = SPLIT_PART (begin_trip_time, ' +', 1);

UPDATE travels.travels_2
SET dropoff_time = SPLIT_PART (dropoff_time, ' +', 1);

UPDATE travels.travels_2
SET distance_km = (distance_km * 1.60934);

UPDATE travels.travels_2
SET request_time = (TO_TIMESTAMP (request_time, 'YYYY-MM-DD HH24:MI:SS')::TIMESTAMP WITHOUT TIME ZONE) + offset_sec * INTERVAL '1 second';

UPDATE travels.travels_2
SET begin_trip_time = TO_TIMESTAMP (begin_trip_time, 'YYYY-MM-DD HH24:MI:SS')::TIMESTAMP WITHOUT TIME ZONE + offset_sec * INTERVAL '1 second';

UPDATE travels.travels_2
SET dropoff_time = TO_TIMESTAMP (dropoff_time, 'YYYY-MM-DD HH24:MI:SS')::TIMESTAMP WITHOUT TIME ZONE + offset_sec * INTERVAL '1 second';