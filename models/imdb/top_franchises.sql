{{ config(
    materialized='table'
) }}

WITH temporary_table AS (
    SELECT 
        tr.tconst, 
        tr.average_rating, 
        tb.primary_title
    FROM {{ ref('title_akas') }} AS ta
    JOIN {{ ref('title_ratings') }} AS tr
        ON ta.title_id = tr.tconst
    JOIN {{ ref('title_basics') }} AS tb
        ON tb.tconst = tr.tconst
    WHERE tb.title_type = 'movie'
)

SELECT 
    primary_title, 
    ROUND(AVG(average_rating), 2) AS ave_rating,
    COUNT(DISTINCT tconst) AS num_mov
FROM temporary_table
GROUP BY primary_title
HAVING COUNT(DISTINCT tconst) > 3 AND ROUND(AVG(average_rating), 2) > 7.5
ORDER BY ave_rating DESC, num_mov DESC
