{{ config(
    materialized='table'
) }}

WITH temporary_table AS (
    SELECT 
        genre, 
        tr.average_rating, 
        COALESCE(te.parent_tconst, te.tconst) AS te_const
    FROM {{ ref('title_ratings') }} AS tr
    JOIN {{ ref('title_basics') }} AS tb
        ON tr.tconst = tb.tconst
    LEFT JOIN {{ ref('title_episode') }} AS te
        ON tr.tconst = te.tconst,
    UNNEST(SPLIT(tb.genres, ',')) AS genre
    WHERE tb.start_year >= EXTRACT(YEAR FROM DATE_SUB(CURRENT_DATE(), INTERVAL 10 YEAR))
    ORDER BY tr.average_rating DESC
)

SELECT 
    genre, 
    ROUND(AVG(average_rating), 2) AS ave_rating_grouped
FROM temporary_table
GROUP BY genre
ORDER BY ave_rating_grouped DESC
