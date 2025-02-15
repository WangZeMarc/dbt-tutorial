
  
    

    create or replace table `the-field-448907-r6`.`my_imdb`.`top_frequent_collaborators`
      
    
    

    OPTIONS(
      description="""Identifies the most frequent collaborations between actors, directors, and writers within specific movie genres."""
    )
    as (
      

WITH collaborators AS (
    SELECT 
        tp.tconst, 
        tp.category, 
        nb.primary_name, 
        genre
    FROM `the-field-448907-r6`.`my_imdb`.`title_principals` AS tp
    JOIN `the-field-448907-r6`.`my_imdb`.`title_basics` AS tb
        ON tp.tconst = tb.tconst
    JOIN `the-field-448907-r6`.`my_imdb`.`name_basics` AS nb
        ON tp.nconst = nb.nconst
    CROSS JOIN UNNEST(SPLIT(tb.genres, ',')) AS genre
    WHERE tb.title_type = 'movie' 
        AND genre IS NOT NULL
),

pairings AS (
    SELECT 
        c1.tconst, 
        c1.category AS role1, 
        c2.category AS role2,
        c1.primary_name AS name1, 
        c2.primary_name AS name2, 
        c1.genre
    FROM collaborators AS c1
    JOIN collaborators AS c2
        ON c1.tconst = c2.tconst 
        AND c1.primary_name > c2.primary_name 
        AND c1.genre = c2.genre
)

SELECT 
    genre, 
    name1, 
    role1, 
    name2, 
    role2, 
    COUNT(DISTINCT tconst) AS num_movie
FROM pairings
GROUP BY genre, name1, role1, name2, role2
HAVING COUNT(DISTINCT tconst) >= 100
ORDER BY num_movie DESC
    );
  