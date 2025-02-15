{{ config(
    materialized='table'
) }}

WITH temporary_table AS (
    SELECT 
        ta.region, 
        genre, 
        ROUND(AVG(tr.average_rating), 2) AS ave_rating,
        COUNT(ta.title_id) AS num_movies
    FROM {{ ref('title_akas') }} AS ta
    JOIN {{ ref('title_ratings') }} AS tr
        ON ta.title_id = tr.tconst
    JOIN {{ ref('title_basics') }} AS tb
        ON ta.title_id = tb.tconst,
    UNNEST(SPLIT(tb.genres, ',')) AS genre
    WHERE ta.region IS NOT NULL 
        AND tb.title_type = 'movie'
    GROUP BY ta.region, genre
    ORDER BY ta.region, genre, ave_rating DESC
),

temporary_table_2 AS (
    SELECT 
        region, 
        genre, 
        ave_rating, 
        num_movies,
        ROW_NUMBER() OVER (PARTITION BY region ORDER BY ave_rating DESC) AS ranks
    FROM temporary_table
    WHERE num_movies >= 5
    ORDER BY region, genre
)

SELECT 
    region, 
    genre, 
    ave_rating, 
    num_movies
FROM temporary_table_2
WHERE ranks = 1 AND ave_rating > 7
ORDER BY ave_rating DESC, num_movies DESC
