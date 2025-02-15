
  
    

    create or replace table `the-field-448907-r6`.`my_imdb`.`directors_rating_improvement`
      
    
    

    OPTIONS(
      description="""Tracks how directors' average movie ratings have changed over the years."""
    )
    as (
      

WITH temporary_table AS (
    SELECT 
        nb.primary_name, 
        COALESCE(te.parent_tconst, te.tconst) AS tconst_fixed, 
        tb.start_year, 
        tr.average_rating
    FROM `the-field-448907-r6`.`my_imdb`.`title_ratings` AS tr
    JOIN `the-field-448907-r6`.`my_imdb`.`title_principals` AS tp
        ON tr.tconst = tp.tconst
    JOIN `the-field-448907-r6`.`my_imdb`.`title_basics` AS tb
        ON tb.tconst = tr.tconst
    JOIN `the-field-448907-r6`.`my_imdb`.`name_basics` AS nb
        ON nb.nconst = tp.nconst
    JOIN `the-field-448907-r6`.`my_imdb`.`title_episode` AS te
        ON te.tconst = tr.tconst
    WHERE tp.category = 'director' 
        AND tb.start_year IS NOT NULL
),
num_year_table AS (
    SELECT 
        primary_name, 
        COUNT(DISTINCT start_year) AS num_year
    FROM temporary_table
    GROUP BY primary_name
    HAVING COUNT(DISTINCT start_year) >= 40
),
temporary_table_2 AS (
    SELECT 
        ny.primary_name, 
        ny.num_year, 
        tt.start_year, 
        tt.average_rating
    FROM num_year_table AS ny
    JOIN temporary_table AS tt
        ON tt.primary_name = ny.primary_name
    ORDER BY ny.num_year DESC, tt.start_year
)

SELECT 
    primary_name, 
    num_year, 
    start_year, 
    ROUND(AVG(average_rating), 2) AS ave_rating_fixed
FROM temporary_table_2
GROUP BY primary_name, num_year, start_year
ORDER BY num_year DESC, start_year
    );
  