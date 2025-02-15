
  
    

    create or replace table `the-field-448907-r6`.`my_imdb`.`directors_highly_rated`
      
    
    

    OPTIONS(
      description="""Identifies directors who consistently produce highly-rated content."""
    )
    as (
      

SELECT 
    nb.primary_name, 
    COUNT(DISTINCT COALESCE(te.parent_tconst, te.tconst)) AS num_works
FROM `the-field-448907-r6`.`my_imdb`.`title_ratings` AS tr
JOIN `the-field-448907-r6`.`my_imdb`.`title_principals` AS tp
    ON tr.tconst = tp.tconst
JOIN `the-field-448907-r6`.`my_imdb`.`name_basics` AS nb
    ON tp.nconst = nb.nconst
JOIN `the-field-448907-r6`.`my_imdb`.`title_basics` AS tb
    ON tr.tconst = tb.tconst
LEFT JOIN `the-field-448907-r6`.`my_imdb`.`title_episode` AS te
    ON tb.tconst = te.tconst
WHERE TRIM(tp.category) = 'director' 
    AND tr.average_rating >= 8 
    AND tb.start_year IS NOT NULL
GROUP BY nb.primary_name
HAVING num_works >= 40
ORDER BY num_works DESC
    );
  