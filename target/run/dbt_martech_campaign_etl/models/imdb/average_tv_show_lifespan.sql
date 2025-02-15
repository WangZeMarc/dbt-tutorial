
  
    

    create or replace table `the-field-448907-r6`.`my_imdb`.`average_tv_show_lifespan`
      
    
    

    OPTIONS(
      description="""Calculates the average lifespan (number of seasons) of top-rated TV shows."""
    )
    as (
      

SELECT 
    ROUND(AVG(season_number_fixed), 2) AS ave_season
FROM (
    SELECT DISTINCT 
        te.parent_tconst, 
        ROUND(AVG(tr.average_rating), 1) AS ave_rating_fixed, 
        MAX(te.season_number) AS season_number_fixed
    FROM `the-field-448907-r6`.`my_imdb`.`title_basics` AS tb
    JOIN `the-field-448907-r6`.`my_imdb`.`title_ratings` AS tr
        ON tb.tconst = tr.tconst
    JOIN `the-field-448907-r6`.`my_imdb`.`title_episode` AS te
        ON tb.tconst = te.tconst
    WHERE TRIM(tb.title_type) = 'tvEpisode' 
      AND tr.average_rating >= 9.5
    GROUP BY te.parent_tconst
    ORDER BY season_number_fixed DESC
)
    );
  