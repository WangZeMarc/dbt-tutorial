{{ config(
    materialized='table'
) }}

WITH temporary_table AS (
    SELECT 
        tr.tconst, 
        tr.average_rating,
        CASE 
            WHEN ta.types = 'original' THEN 'Original'
            WHEN ta.types IN ('alternative', 'working', 'video', 'tv', 'dvd', 'festival') THEN 'Sequel'
            ELSE 'Others' 
        END AS ori_or_seq
    FROM {{ ref('title_akas') }} AS ta
    JOIN {{ ref('title_ratings') }} AS tr
        ON ta.title_id = tr.tconst
    JOIN {{ ref('title_basics') }} AS tb
        ON tb.tconst = tr.tconst
    WHERE tb.title_type = 'movie' 
        AND ta.types IS NOT NULL 
        AND ta.types != 'imdbDisplay'
)

SELECT 
    ori_or_seq, 
    COUNT(DISTINCT tconst) AS num_mov,
    ROUND(AVG(average_rating), 2) AS ave_rating
FROM temporary_table
WHERE ori_or_seq IN ('Original', 'Sequel')
GROUP BY ori_or_seq
