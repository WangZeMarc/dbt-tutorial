

WITH temporary_table AS (
    SELECT 
        nb.primary_name, 
        tb.start_year, 
        ROUND(AVG(tr.average_rating), 2) AS ave_rating
    FROM `the-field-448907-r6`.`my_imdb`.`title_ratings` AS tr
    JOIN `the-field-448907-r6`.`my_imdb`.`title_basics` AS tb
        ON tr.tconst = tb.tconst
    JOIN `the-field-448907-r6`.`my_imdb`.`title_principals` AS tp
        ON tr.tconst = tp.tconst
    JOIN `the-field-448907-r6`.`my_imdb`.`name_basics` AS nb
        ON nb.nconst = tp.nconst
    WHERE tb.start_year IS NOT NULL 
        AND tp.category = 'actor'
    GROUP BY nb.primary_name, tb.start_year
),
num_year AS (
    SELECT 
        primary_name, 
        COUNT(DISTINCT start_year) AS num_year
    FROM temporary_table
    GROUP BY primary_name
    HAVING COUNT(DISTINCT start_year) >= 70
)

SELECT 
    ny.primary_name, 
    num_year, 
    tt.start_year, 
    tt.ave_rating
FROM num_year AS ny
JOIN temporary_table AS tt
    ON ny.primary_name = tt.primary_name
ORDER BY ny.num_year DESC, tt.start_year