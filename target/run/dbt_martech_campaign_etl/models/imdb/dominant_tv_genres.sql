
  
    

    create or replace table `the-field-448907-r6`.`my_imdb`.`dominant_tv_genres`
      
    
    

    OPTIONS(
      description="""Identifies which genres dominate TV series production based on the number of TV series per genre."""
    )
    as (
      

SELECT 
    genre, 
    COUNT(te.parent_tconst) AS num_per_genre
FROM `the-field-448907-r6`.`my_imdb`.`title_basics` AS tb
JOIN `the-field-448907-r6`.`my_imdb`.`title_episode` AS te
    ON tb.tconst = te.tconst,
UNNEST(SPLIT(tb.genres, ',')) AS genre
WHERE TRIM(tb.title_type) = 'tvEpisode'
GROUP BY genre
ORDER BY num_per_genre DESC
    );
  