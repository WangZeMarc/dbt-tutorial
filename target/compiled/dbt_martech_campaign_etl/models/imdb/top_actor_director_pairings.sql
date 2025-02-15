

WITH actors AS (
    SELECT 
        tp.tconst, 
        tp.nconst, 
        nb.primary_name AS actor_name
    FROM `the-field-448907-r6`.`my_imdb`.`title_principals` AS tp
    JOIN `the-field-448907-r6`.`my_imdb`.`name_basics` AS nb
        ON tp.nconst = nb.nconst
    WHERE category IN ('actor', 'actress')
),

directors AS (
    SELECT 
        tp.tconst, 
        tp.nconst, 
        nb.primary_name AS director_name
    FROM `the-field-448907-r6`.`my_imdb`.`title_principals` AS tp
    JOIN `the-field-448907-r6`.`my_imdb`.`name_basics` AS nb
        ON tp.nconst = nb.nconst
    WHERE category = 'director'
),

pairings AS (
    SELECT 
        a.tconst, 
        a.actor_name, 
        d.director_name
    FROM actors AS a
    JOIN directors AS d
        ON a.tconst = d.tconst
)

SELECT 
    p.actor_name, 
    p.director_name,
    ROUND(AVG(tr.average_rating), 2) AS ave_rating,
    COUNT(tr.tconst) AS num_movie
FROM pairings AS p
JOIN `the-field-448907-r6`.`my_imdb`.`title_ratings` AS tr
    ON p.tconst = tr.tconst
GROUP BY p.actor_name, p.director_name
HAVING ROUND(AVG(tr.average_rating), 2) >= 9 
    AND COUNT(tr.tconst) > 100
ORDER BY num_movie DESC, ave_rating DESC