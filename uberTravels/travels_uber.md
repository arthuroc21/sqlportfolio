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

* One of the things that I like to do when doing projects, is to always keep a backup file of important things. So I decided to keep the 'travels' table as a backup file and worked on a copy of it. Well, looking from a storage consumption perspective, this could be considered a not good practice. But again, I allowed myself to do this, as It is a small database.
To create this copy, I joined the two tables 'travels' and 'time_zone' so I could have an only table with all the necessary columns, making it easier to work on.
```sql
CREATE TABLE travels.travels_2 AS
	(SELECT * FROM travels.travels
	LEFT OUTER JOIN travels.time_zone
	USING (city));
```

* Again, an error occured. If you go back a few lines ago I typed 'São Paulo' and 'São Luís' as values for the time_zone table, and used it as a key to join the tables. The Uber's file comes with the city names without '~' or '´', so I had to update it as well. After running the following query, I could run the previous one.
```sql
UPDATE travels.time_zone
SET city = 'Sao Paulo'
WHERE city = 'São Paulo';

UPDATE travels.time_zone
SET city = 'Sao Luis'
WHERE city = 'São Luís';
```

* Right after that I could manipulate the columns 'request_time', 'begin_trip_time' and 'dropoff_time' to match a timestamp format, making it easier to manipulate.
```sql
UPDATE travels.travels_2
SET request_time = SPLIT_PART (request_time, ' +', 1);

UPDATE travels.travels_2
SET begin_trip_time = SPLIT_PART (begin_trip_time, ' +', 1);

UPDATE travels.travels_2
SET dropoff_time = SPLIT_PART (dropoff_time, ' +', 1);
```

* To finish, I updated these same columns, adding the respective time zone offset.
```sql
UPDATE travels.travels_2
SET request_time = (TO_TIMESTAMP (request_time, 'YYYY-MM-DD HH24:MI:SS')::TIMESTAMP WITHOUT TIME ZONE) + offset_sec * INTERVAL '1 second';

UPDATE travels.travels_2
SET begin_trip_time = TO_TIMESTAMP (begin_trip_time, 'YYYY-MM-DD HH24:MI:SS')::TIMESTAMP WITHOUT TIME ZONE + offset_sec * INTERVAL '1 second';

UPDATE travels.travels_2
SET dropoff_time = TO_TIMESTAMP (dropoff_time, 'YYYY-MM-DD HH24:MI:SS')::TIMESTAMP WITHOUT TIME ZONE + offset_sec * INTERVAL '1 second';
```

* And that's all :) I'm gonna upload the sql file as well, a little bit different from what I showed here. The sql file already comes fixed, so It won't show any of the errors presented above. I'm very open to hear any tips or "smarter" ways of doing this, just reach me on my social medias, I'd be more than happy to learn more :)