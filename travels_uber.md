# Uber Travels Dataset

## Intro

This is a personal project that I wanted to do a certain time ago. As a data-driven person, I always felt curious about how many hours I spent inside a Uber, in which places I used it and how much I've spent so far.
So, I requested my personal data to Uber (it's really simple if you don't know about it, just a few clicks on your app and they send your personal data to your email!) and started to work on it.
The whole idea of the procject is to manipulate the data only using SQL commands to create a dataset ready to be uploaded on a BI viz software (I'm still deciding between Google Looker and Power BI).
I'm gonna write my logical process as a storytelling, so you're gonna see some erros during the process and how I fixed It. 
So you can follow my logical process and If you're trying to do It alone first and bump into a similar error, you can see here a possible solution. 

## Code

Well, to begin with, I used Postgres as my SQL database system as well Pgadmin to write and run querys.  
  
* The first thing was to create a schema. 
Postgres comes already with a public schema, but I wanted to simulate a real-world case, so I created a new schema just to better organise everything.
```sql
  CREATE SCHEMA travels
  AUTHORIZATION postgres;
```

* Then, I had to create the tables I was going to use. I created two tables, one for the data from Uber and other as a time zone database. 
The date time on Uber's data comes in UTC. But thinking about visualisation, I wanted to see the day times relative to the location. 
So I manually created a table with the time zone offset in seconds, so I could manipulate this time stamps later.
Talking about data integrity, I defined some constraints for the columns. The first thing was to define my primary and secondary keys.
One important thing about it: I know that is not recommended to use the city name as a primary key. One country's city name could be easily seen in another country, so it would break the uniqueness of a primary key.
In any case, I allowed myself to do this as It is just a simple database which I have 100% certain that won't be any duplicated city names and the main focus is to show some sql manipulation skills.
```sql
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
      request_time TIMESTAMP,
      begin_trip_time TIMESTAMP,
      begin_trip_lat FLOAT,
      begin_trip_lng FLOAT,
      begin_trip_address VARCHAR(250),
      dropoff_time TIMESTAMP,
      dropoff_lat FLOAT,
      dropoff_lng FLOAT,
      dropoff_address VARCHAR(250),
      distance_km FLOAT,
      fare_amount FLOAT,
      fare_currency VARCHAR(10)
	);
```

* The next thing to do was to insert the data inside the tables. 
As I said, I inputed manually the values for table 'time_zone', and for table 'travels' I copied the file from Uber.
```sql
INSERT INTO travels.time_zone VALUES 
	('Fortaleza', -10800),
	('São Paulo', -10800),
	('Porto Alegre', -10800),
	('Sydney', 36000),
	('Recife', -10800),
	('São Luís', -10800);
  
COPY travels.travels
FROM 'C:\Users\Public\trips_data.csv'
DELIMITER ','
CSV HEADER;
```

* Well, everything was going well but an error appeared when I ran the last query. 
As you can see, I defined 'request_time', 'begin_trip_time' and 'dropoff_time' as TIMESTAMP.
As It seems, SQL didn't reconise the format from the Uber file. I had to manipulate these values so I could update them to a reconised format.
The idea was to admit them as a string, so I could manipulate them.
After running the following query, I ran the last one and I could continue.
```sql
ALTER TABLE travels.travels
ALTER COLUMN request_time TYPE VARCHAR(50),
ALTER COLUMN begin_trip_time TYPE VARCHAR(50),
ALTER COLUMN dropoff_time TYPE VARCHAR(50);
```

* One of the things that I like to do
