
  
    

    create or replace table `the-field-448907-r6`.`my_imdb`.`top_rated_actors`
      
    
    

    OPTIONS(
      description="""A table containing actors who have appeared in the highest number of top-rated movies"""
    )
    as (
      


SELECT
    nb.primary_name,
    COUNT(tr.tconst) AS counts_per_actor
FROM `the-field-448907-r6`.`my_imdb`.`title_ratings` AS tr
JOIN `the-field-448907-r6`.`my_imdb`.`title_principals` AS tp
    ON tr.tconst = tp.tconst
JOIN `the-field-448907-r6`.`my_imdb`.`title_basics` AS tb
    ON tr.tconst = tb.tconst
JOIN `the-field-448907-r6`.`my_imdb`.`name_basics` AS nb
    ON tp.nconst = nb.nconst
WHERE TRIM(tb.title_type) = 'movie'
  AND tr.average_rating >= 9
  AND TRIM(tp.category) = 'actor'
GROUP BY nb.primary_name
HAVING counts_per_actor >= 10
ORDER BY counts_per_actor DESC
    );
  