-- Use the database
USE DATABASE entertainment_db;


-- the most common first name among actors and actresses
CREATE OR REPLACE VIEW models.common_first_name AS
SELECT first_name, COUNT(*) as name_count
FROM (
    SELECT SPLIT_PART(director, ' ', 1) AS first_name
    FROM models.shows
    WHERE director IS NOT NULL
) AS first_names
GROUP BY first_name
ORDER BY name_count DESC
LIMIT 1;


-- The Movie had the longest timespan from release to appearing on Netflix
CREATE OR REPLACE VIEW models.longest_timespan AS
SELECT type,
       title,
       release_year,
       date_added,
       trim(SPLIT_PART(date_added, ',', 2)) AS Year_added,
       DATEDIFF(DAYS, TO_DATE(TO_VARIANT(release_year)::STRING, 'YYYY'), TO_DATE(TO_VARIANT(Year_added)::STRING, 'YYYY')) AS timespan_days
FROM models.shows
WHERE lower(type) = 'movie' AND release_year IS NOT NULL and date_added IS NOT NULL
ORDER BY timespan_days DESC
LIMIT 1;


-- The Month of the year had the most new releases historically.
CREATE OR REPLACE VIEW models.month_with_most_new_releases AS
SELECT EXTRACT(MONTH FROM TO_DATE(TO_VARIANT(release_year)::STRING, 'YYYY')) AS release_month,
COUNT(*) AS release_count
FROM  models.shows
WHERE EXTRACT(YEAR FROM TO_DATE(TO_VARIANT(release_year)::STRING, 'YYYY')) <= YEAR(CURRENT_DATE()) -- Filter for historical data
GROUP BY release_month
ORDER BY release_count DESC
LIMIT 1;



-- The year with the largest increase year on year (percentage wise) for TV Shows.
CREATE OR REPLACE VIEW models.largest_percent_inc_tv_shows AS
WITH yearly_counts AS (
    SELECT release_year as year,
           count(*) AS total_shows,
           LAG(total_shows) OVER (ORDER BY year) AS previous_year_shows -- retrieves the total number of TV shows for the previous year 
    FROM models.shows
    WHERE lower(type) = 'tv show'
    GROUP BY year
)
SELECT year,
       total_shows,
       previous_year_shows,
       ROUND(((total_shows - previous_year_shows) / previous_year_shows) * 100, 2) AS percentage_increase
FROM yearly_counts
WHERE previous_year_shows IS NOT NULL -- Exclude the first year without previous year data
ORDER BY percentage_increase DESC
LIMIT 1;



-- List the actresses that have appeared in a movie with Woody Harrelson more than once
CREATE OR REPLACE VIEW models.list_actor_woody_movies AS
WITH woody_movies AS (
    SELECT DISTINCT title AS movie_title
    FROM models.shows
    WHERE lower(type) = 'movie' AND lower("CAST") like '%woody harrelson%'
),
actresses_in_woody_movies AS (
    SELECT DISTINCT m."CAST" as actor_name, m.title as movie_title
    FROM models.shows m
    INNER JOIN woody_movies wm ON m.title = wm.movie_title
)
SELECT actor_name
FROM actresses_in_woody_movies
GROUP BY actor_name
HAVING COUNT(DISTINCT movie_title) > 1;



