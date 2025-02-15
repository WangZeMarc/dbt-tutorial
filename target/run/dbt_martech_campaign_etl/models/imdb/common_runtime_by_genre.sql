
  
    

    create or replace table `the-field-448907-r6`.`my_imdb`.`common_runtime_by_genre`
      
    
    

    OPTIONS(
      description="""Finds the most common runtime (in minutes) for movies in each genre."""
    )
    as (
      

WITH temporary_table AS (
    SELECT 
        genre, 
        runtime_minutes, 
        COUNT(tconst) AS frequency
    FROM `the-field-448907-r6`.`my_imdb`.`title_basics`,
    UNNEST(SPLIT(genres, ',')) AS genre
    WHERE runtime_minutes IS NOT NULL 
        AND TRIM(title_type) = 'movie'
    GROUP BY genre, runtime_minutes
    ORDER BY genre
)

SELECT 
    genre, 
    runtime_minutes,
    frequency
FROM (
    SELECT 
        genre, 
        runtime_minutes, 
        frequency,
        ROW_NUMBER() OVER (PARTITION BY genre ORDER BY frequency DESC) AS rank_num
    FROM temporary_table
)
WHERE rank_num = 1
ORDER BY frequency DESC
    );
  