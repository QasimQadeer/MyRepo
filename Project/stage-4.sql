-- Use the database
USE DATABASE entertainment_db;


-- View is created to find missing DIRECTOR or DATE in given data:
CREATE OR REPLACE VIEW models.data_validations AS

-- Check for missing director names
WITH CTE_Validation_1 AS (
SELECT show_id, release_year, type, concat('Director name is missing for '|| TYPE || ' ' || TITLE) AS reason
FROM models.shows
WHERE director IS NULL
order by release_year
),

-- Check for missing dates
CTE_Validation_2 AS (
SELECT show_id, release_year, type, concat('Date is missing for '|| TYPE || ' ' || TITLE) AS reason
FROM models.shows
WHERE date_added IS NULL
order by release_year
),
CTE_FINAL AS (
SELECT * FROM CTE_Validation_1
UNION ALL
SELECT * FROM CTE_Validation_2
)

SELECT * FROM CTE_FINAL
;