SELECT * FROM athletes_cleared;

SELECT * FROM results;

SELECT * FROM games;

SELECT * FROM noc_regions;


-- Analyze athletes' height statistics
SELECT MIN(HEIGHT) AS min_height
	 , CEILING(AVG(HEIGHT)) AS avg_height
	 , MAX(HEIGHT) AS max_height
FROM athletes_cleared;

-- Analyze athletes' who won medals in London 2012
SELECT DISTINCT
	  ac.first_name
	, ac.last_name
	, ac.team
FROM athletes_cleared ac
WHERE ac.athlete_id IN(
	SELECT r.athlete_fk
	FROM results r
	JOIN games g
		ON r.game_fk = g.game_id
	WHERE g.city = 'London'
		AND g.year = 2012
		AND r.medal != '0'
)
LIMIT 10;

-- Count medals by type
SELECT
    SUM(CASE WHEN medal = 'Gold' THEN 1 ELSE 0 END) AS cnt_gold_medal,
    SUM(CASE WHEN medal = 'Silver' THEN 1 ELSE 0 END) AS cnt_silver_medal,
    SUM(CASE WHEN medal = 'Bronze' THEN 1 ELSE 0 END) AS cnt_bronze_medal,
    SUM(CASE WHEN medal = '0' THEN 1 ELSE 0 END) AS cnt_no_medal
FROM results;

-- Count athletes from countries that no longer exist
SELECT team, COUNT(*) AS athletes_count
FROM athletes_cleared
WHERE team IN (
      'Australasia'
    , 'Bohemia'
    , 'Czechoslovakia'
    , 'East Germany'
    , 'Rhodesia'
    , 'Serbia and Montenegro'
    , 'South Vietnam'
    , 'Soviet Union'
    , 'Unified Team'
    , 'West Germany'
    'Yugoslavia'
)
GROUP BY team
ORDER BY athletes_count DESC;

-- Top 20 teams by number of gold medals
SELECT 
	 COUNT(*) as cnt_medal
	 , ac.team
FROM athletes_cleared ac
LEFT JOIN results r
	ON ac.athlete_id = r.athlete_fk
WHERE medal = 'Gold'
GROUP BY ac.team
ORDER BY cnt_medal desc
LIMIT 20;


-- Top 10 Ukrainian athletes by number of gold medals
SELECT 
	  ac.first_name
	, ac.last_name
	, ac.team
	, r.sport
	, COUNT(r.medal) as cnt_gold_medal
FROM athletes_cleared ac
LEFT JOIN results r
	ON ac.athlete_id = r.athlete_fk
WHERE medal = 'Gold' and team = 'Ukraine'
GROUP BY athlete_id, r.sport
ORDER BY cnt_gold_medal desc
LIMIT 10;

-- Top 10 athletes with most gold medals in 21st century
WITH gold_medalist AS (
    SELECT
          r.athlete_fk
		, r.sport
    FROM results r
    JOIN games g
		ON r.game_fk = g.game_id
    WHERE g.year > 2000
    	AND r.medal = 'Gold' 
)
SELECT
      ac.first_name
    , ac.last_name
    , ac.team
	, gm.sport
    , COUNT(gm.athlete_fk) AS total_gold_medals
FROM athletes_cleared ac
JOIN gold_medalist gm
	ON ac.athlete_id = gm.athlete_fk
GROUP BY ac.athlete_id, ac.first_name, ac.last_name, ac.team, gm.sport
ORDER BY total_gold_medals DESC
LIMIT 10;

-- Top 10 teams by number of gold medals in Volleyball
SELECT
	  ac.team
	, COUNT(r.medal) as cnt_gold
FROM athletes_cleared ac
JOIN results r
	ON ac.athlete_id = r.athlete_fk
WHERE r.sport = 'Volleyball'
GROUP BY ac.team
ORDER BY cnt_gold desc
LIMIT 10;
