{{ config(
    materialized='table'
) }}

SELECT 
    tr.tconst, 
    tr.num_votes
FROM {{ ref('title_ratings') }} AS tr
JOIN {{ ref('title_basics') }} AS tb 
ON tr.tconst = tb.tconst
WHERE TRIM(tb.title_type) = 'movie'
ORDER BY tr.num_votes DESC
LIMIT 10
