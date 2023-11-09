-- Use the database
USE DATABASE entertainment_db;

-- -- Validation # 1: View is created to find missing DIRECTOR NAMES from CLEANSED data:
CREATE OR replace VIEW netflix_titles.missing_director_names
AS
  SELECT show_id,
         release_year,
         TYPE,
         director,
         Concat('Director name is missing for '
                || TYPE
                || ' '
                || title) AS reason
  FROM   netflix_titles.cleansed_shows
  WHERE  director IS NULL
  ORDER  BY release_year; 


-- Validation # 2: View is created to check for missing dates when shows are added to netflix.
CREATE OR replace VIEW netflix_titles.missing_netflix_dates
AS
  SELECT show_id,
         release_year,
         TYPE,
         date_added,
         Concat('Date is missing for '
                || TYPE
                || ' '
                || title) AS reason
  FROM   netflix_titles.cleansed_shows
  WHERE  date_added IS NULL
  ORDER  BY release_year; 