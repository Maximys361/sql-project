SELECT *
FROM athlete_events
LIMIT 20;


-- We can see that there is duplicate data in the athlete_events table, so we need to perform normalization.

-- Create a table called athletes that contains the following columns:
-- athlete_id (generated with a SERIAL function),
-- name, sex, age, height, weight, and team.
CREATE TABLE athletes(
	athlete_id SERIAL PRIMARY KEY,
	name TEXT NOT NULL,
	sex TEXT,
	age REAL,
	height REAL,
	weight REAL,
	team TEXT,
	noc TEXT
)

--Insert data into the new table from the main table.
INSERT INTO athletes(name, sex, age, height, weight, team, noc)
SELECT DISTINCT name, sex, age, height, weight, team, noc
FROM athlete_events;

SELECT * FROM athletes;

--Create a table called games that contains the following colums:
-- game_id(generated with a SERIAL function),
-- year, season and city. Year and season will be unique values only.
CREATE TABLE games(
	game_id SERIAL PRIMARY KEY,
	year INTEGER NOT NULL,
	season TEXT NOT NULL,
	city TEXT NOT NULL,
	UNIQUE(year, season)
)

--Insert data into in the new column.
INSERT INTO games(year, season, city)
SELECT DISTINCT year, season, city
FROM athlete_events
ON CONFLICT (year, season) DO NOTHING;

SELECT * 
FROM games;

--Also add a new columns to the main table.
ALTER TABLE athlete_events
ADD COLUMN athlete_fk INTEGER,
ADD COLUMN game_fk INTEGER;

--Remove unnecessary columns from the main table.
ALTER TABLE athlete_events
DROP COLUMN sex,
DROP COLUMN age,
DROP COLUMN height,
DROP COLUMN weight,
DROP COLUMN team,
DROP COLUMN noc,
DROP COLUMN year,
DROP COLUMN season,
DROP COLUMN city;


SELECT * FROM athlete_events;

--Rename main table.
ALTER TABLE athlete_events RENAME TO results;

SELECT * FROM results;

--Updates results.athlete_fk with athletes.athlete_id where names match.
UPDATE results r
SET athlete_fk = a.athlete_id
FROM athletes a
WHERE r.name = a.name;

SELECT * FROM results;

SELECT * FROM games;

--Updates results.game_fk with games.game_id where year and season in results.games match games.year and games.season.
UPDATE results r
SET game_fk = g.game_id
FROM games g
WHERE g.year = CAST(SUBSTRING(r.games FROM 1 FOR 4) as INTEGER)
  AND g.season = SUBSTRING(r.games FROM 6)
  AND r.games IS NOT NULL;


--Drops the name and games columns from the results table.
ALTER TABLE results
DROP COLUMN name,
DROP COLUMN games;


--Adds foreign key constraints to **results**, linking athlete_fk to athletes.athlete_id
--and game_fk to games.game_id.
ALTER TABLE results
ADD CONSTRAINT fk_athlete
FOREIGN KEY (athlete_fk)
REFERENCES athletes (athlete_id);

ALTER TABLE results
ADD CONSTRAINT fk_game
FOREIGN KEY (game_fk)
REFERENCES games (game_id);

SELECT * FROM noc_regions;
SELECT * FROM results;
SELECT * FROM games;
SELECT * FROM athletes;


--We can also see that the athletes table contains non-atomic values. We need to fix this.
CREATE TABLE athletes_cleared(
	athlete_id SERIAL PRIMARY KEY,
	first_name TEXT NOT NULL,
	last_name TEXT NOT NULL,
	sex TEXT,
	age REAL,
	height REAL,
	weight REAL,
	team TEXT,
	noc TEXT
)

INSERT INTO athletes_cleared(first_name, last_name, sex, age, height, weight, team, noc)
SELECT
		(s.parts_array)[1] AS first_name
	  , (s.parts_array)[array_length(parts_array, 1)] AS last_name
	  , sex
	  , age
	  , height
	  , weight
	  , team
	  , noc
FROM athletes a,
LATERAL (
        SELECT 
            string_to_array(
                TRIM(REGEXP_REPLACE(a.name, '\s\([^)]*\)', '', 'g')),
                ' '
            ) AS parts_array
    ) AS s;


--Check the new table for atomic values.
select * from athletes_cleared;

