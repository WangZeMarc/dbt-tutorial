{{ config(
    materialized='table'
) }}

SELECT DISTINCT 
    te.parent_tconst,
    ROUND(AVG(tr.average_rating), 1) AS ave_rating_fixed
FROM {{ ref('title_basics') }} AS tb
JOIN {{ ref('title_ratings') }} AS tr
    ON tb.tconst = tr.tconst
JOIN {{ ref('title_episode') }} AS te
    ON tb.tconst = te.tconst
WHERE TRIM(tb.title_type) = 'tvEpisode' 
  AND tr.average_rating >= 9.5
GROUP BY te.parent_tconst
ORDER BY ave_rating_fixed DESC
