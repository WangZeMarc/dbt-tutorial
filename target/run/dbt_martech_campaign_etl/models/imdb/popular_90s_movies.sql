
  
    

    create or replace table `the-field-448907-r6`.`my_imdb`.`popular_90s_movies`
      
    
    

    OPTIONS(
      description="""Identifies movies from the 1990s that are still popular today based on rating and vote count."""
    )
    as (
      

SELECT 
    tb.tconst, 
    tr.num_votes, 
    tr.average_rating, 
    tb.start_year
FROM `the-field-448907-r6`.`my_imdb`.`title_basics` AS tb
JOIN `the-field-448907-r6`.`my_imdb`.`title_ratings` AS tr
    ON tb.tconst = tr.tconst
WHERE TRIM(tb.title_type) = 'movie'
    AND tb.start_year BETWEEN 1990 AND 1999
    AND tr.average_rating >= 8.5
    AND tr.num_votes >= 500000
ORDER BY tr.num_votes DESC, tr.average_rating DESC
    );
  