
  
    

    create or replace table `the-field-448907-r6`.`my_imdb`.`prolific_actors_by_genre`
      
    
    

    OPTIONS(
      description="""Finds the most prolific actors in a specific genre (e.g., Comedy)."""
    )
    as (
      

SELECT 
    genre, 
    nb.primary_name,
    COUNT(DISTINCT COALESCE(te.parent_tconst, te.tconst)) AS uni_num
FROM `the-field-448907-r6`.`my_imdb`.`title_principals` AS tp
JOIN `the-field-448907-r6`.`my_imdb`.`name_basics` AS nb
    ON tp.nconst = nb.nconst
JOIN `the-field-448907-r6`.`my_imdb`.`title_basics` AS tb
    ON tp.tconst = tb.tconst
LEFT JOIN `the-field-448907-r6`.`my_imdb`.`title_episode` AS te
    ON tp.tconst = te.tconst
CROSS JOIN UNNEST(SPLIT(tb.genres, ',')) AS genre
WHERE TRIM(genre) = 'Comedy' 
  AND TRIM(tp.category) = 'actor'
GROUP BY genre, nb.primary_name
ORDER BY uni_num DESC
LIMIT 10
    );
  