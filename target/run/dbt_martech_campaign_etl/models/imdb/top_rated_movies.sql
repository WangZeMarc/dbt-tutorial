
  
    

    create or replace table `the-field-448907-r6`.`my_imdb`.`top_rated_movies`
      
    
    

    OPTIONS(
      description=""""""
    )
    as (
      

SELECT 
    tr.tconst, 
    tr.num_votes
FROM `the-field-448907-r6`.`my_imdb`.`title_ratings` AS tr
JOIN `the-field-448907-r6`.`my_imdb`.`title_basics` AS tb 
ON tr.tconst = tb.tconst
WHERE TRIM(tb.title_type) = 'movie'
ORDER BY tr.num_votes DESC
LIMIT 10
    );
  