{{ config(
    materialized='table'
) }}

SELECT 
    tb.tconst, 
    tr.num_votes, 
    tr.average_rating, 
    tb.start_year
FROM {{ ref('title_basics') }} AS tb
JOIN {{ ref('title_ratings') }} AS tr
    ON tb.tconst = tr.tconst
WHERE TRIM(tb.title_type) = 'movie'
    AND tb.start_year BETWEEN 1990 AND 1999
    AND tr.average_rating >= 8.5
    AND tr.num_votes >= 500000
ORDER BY tr.num_votes DESC, tr.average_rating DESC
