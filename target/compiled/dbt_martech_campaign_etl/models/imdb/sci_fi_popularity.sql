

WITH year_range AS (
    SELECT year
    FROM UNNEST(generate_array(1975, 2024)) AS year
)

SELECT 
    yr.year, 
    COUNT(tr.tconst) AS movie_num,
    ROUND(AVG(tr.average_rating), 2) AS ave_rating
FROM year_range AS yr
LEFT JOIN `the-field-448907-r6`.`my_imdb`.`title_basics` AS tb
    ON tb.start_year = yr.year
LEFT JOIN `the-field-448907-r6`.`my_imdb`.`title_ratings` AS tr
    ON tb.tconst = tr.tconst
WHERE tb.genres LIKE '%Sci-Fi%' 
    AND tb.title_type = 'movie'
GROUP BY yr.year
ORDER BY yr.year