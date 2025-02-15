

SELECT 
    CASE 
        WHEN tb.start_year < 1900 THEN '1800+'
        WHEN tb.start_year BETWEEN 1900 AND 1910 THEN '1900s'
        WHEN tb.start_year BETWEEN 1910 AND 1920 THEN '1910s'
        WHEN tb.start_year BETWEEN 1920 AND 1930 THEN '1920s'
        WHEN tb.start_year BETWEEN 1930 AND 1940 THEN '1930s'
        WHEN tb.start_year BETWEEN 1940 AND 1950 THEN '1940s'
        WHEN tb.start_year BETWEEN 1950 AND 1960 THEN '1950s'
        WHEN tb.start_year BETWEEN 1960 AND 1970 THEN '1960s'
        WHEN tb.start_year BETWEEN 1970 AND 1980 THEN '1970s'
        WHEN tb.start_year BETWEEN 1980 AND 1990 THEN '1980s'
        WHEN tb.start_year BETWEEN 1990 AND 2000 THEN '1990s'
        WHEN tb.start_year BETWEEN 2000 AND 2010 THEN '2000s'
        WHEN tb.start_year > 2010 THEN '2010+'
    END AS time_interval,
    COUNT(tb.tconst) AS total_num,
    ROUND(AVG(tr.num_votes), 0) AS ave_num_votes,
    ROUND(AVG(tr.average_rating), 2) AS ave_rating
FROM `the-field-448907-r6`.`my_imdb`.`title_basics` AS tb
JOIN `the-field-448907-r6`.`my_imdb`.`title_ratings` AS tr
    ON tb.tconst = tr.tconst
WHERE tb.start_year IS NOT NULL
    AND TRIM(tb.title_type) = 'movie'
GROUP BY time_interval
ORDER BY time_interval