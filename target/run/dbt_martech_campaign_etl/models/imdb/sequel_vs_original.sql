
  
    

    create or replace table `the-field-448907-r6`.`my_imdb`.`sequel_vs_original`
      
    
    

    OPTIONS(
      description="""Analyzes whether sequels generally perform better or worse than the original movies based on IMDb ratings."""
    )
    as (
      

WITH temporary_table AS (
    SELECT 
        tr.tconst, 
        tr.average_rating,
        CASE 
            WHEN ta.types = 'original' THEN 'Original'
            WHEN ta.types IN ('alternative', 'working', 'video', 'tv', 'dvd', 'festival') THEN 'Sequel'
            ELSE 'Others' 
        END AS ori_or_seq
    FROM `the-field-448907-r6`.`my_imdb`.`title_akas` AS ta
    JOIN `the-field-448907-r6`.`my_imdb`.`title_ratings` AS tr
        ON ta.title_id = tr.tconst
    JOIN `the-field-448907-r6`.`my_imdb`.`title_basics` AS tb
        ON tb.tconst = tr.tconst
    WHERE tb.title_type = 'movie' 
        AND ta.types IS NOT NULL 
        AND ta.types != 'imdbDisplay'
)

SELECT 
    ori_or_seq, 
    COUNT(DISTINCT tconst) AS num_mov,
    ROUND(AVG(average_rating), 2) AS ave_rating
FROM temporary_table
WHERE ori_or_seq IN ('Original', 'Sequel')
GROUP BY ori_or_seq
    );
  