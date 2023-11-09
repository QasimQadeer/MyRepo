-- Use the database
USE DATABASE entertainment_db;


-- the most common first name among actors and actresses
CREATE OR REPLACE view netflix_titles.common_first_name
AS
  SELECT first_name,
         Count(*) AS name_count
  FROM   (SELECT Split_part(director, ' ', 1) AS first_name
          FROM   netflix_titles.cleansed_shows
          WHERE  director IS NOT NULL) AS first_names
  GROUP  BY first_name
  ORDER  BY name_count DESC
  LIMIT  1; 


-- The Movie had the longest timespan from release to appearing on Netflix
CREATE OR REPLACE view netflix_titles.longest_timespan
AS
  SELECT type,
         title,
         release_year,
         date_added,
         Trim(Split_part(date_added, ',', 2))       AS Year_added,
         Datediff(days, To_date(To_variant(release_year) :: string, 'YYYY'),
         To_date(
         To_variant(year_added) :: string, 'YYYY')) AS timespan_days
  FROM   netflix_titles.cleansed_shows
  WHERE  Lower(type) = 'movie'
         AND release_year IS NOT NULL
         AND date_added IS NOT NULL
  ORDER  BY timespan_days DESC
  LIMIT  1; 


-- The Month of the year had the most new releases historically.
CREATE OR REPLACE view netflix_titles.month_with_most_new_releases
AS
  SELECT Extract(month FROM To_date(To_variant(release_year) :: string, 'YYYY'))
         AS
         release_month,
         Count(*)
            AS release_count
  FROM   netflix_titles.cleansed_shows
  WHERE  Extract(year FROM To_date(To_variant(release_year) :: string, 'YYYY'))
         <= Year(
         CURRENT_DATE()) -- Filter for historical data
  GROUP  BY release_month
  ORDER  BY release_count DESC
  LIMIT  1; 



-- The year with the largest increase year on year (percentage wise) for TV Shows.
CREATE OR replace VIEW netflix_titles.largest_percent_inc_tv_shows AS
                       WITH yearly_counts                          AS
                       (
                                SELECT   release_year                          AS year,
                                         count(*)                              AS total_shows,
                                         lag(total_shows) OVER (ORDER BY year) AS previous_year_shows -- retrieves the total number of TV shows for the previous year
                                FROM     netflix_titles.cleansed_shows
                                WHERE    lower(type) = 'tv show'
                                GROUP BY year
                       )SELECT   year,
                       total_shows,
                       previous_year_shows,
                       Round(((total_shows - previous_year_shows) / previous_year_shows) * 100, 2) AS percentage_increase
              FROM     yearly_counts
              WHERE    previous_year_shows IS NOT NULL -- Exclude the first year without previous year data
              ORDER BY percentage_increase DESC limit 1;


-- List the actresses that have appeared in a movie with Woody Harrelson more than once
CREATE OR replace VIEW netflix_titles.list_actor_woody_movies
AS
  WITH woody_movies
       AS (SELECT DISTINCT title AS movie_title
           FROM   netflix_titles.cleansed_shows
           WHERE  Lower(TYPE) = 'movie'
                  AND Lower("cast") LIKE '%woody harrelson%'),
       actresses_in_woody_movies
       AS (SELECT DISTINCT m."cast" AS actor_name,
                           m.title  AS movie_title
           FROM   netflix_titles.cleansed_shows m
                  inner join woody_movies wm
                          ON m.title = wm.movie_title)
  SELECT actor_name
  FROM   actresses_in_woody_movies
  GROUP  BY actor_name
  HAVING Count(DISTINCT movie_title) > 1; 