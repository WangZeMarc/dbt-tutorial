{{ config(
    materialized='table'
) }}

SELECT 
    genre, 
    nb.primary_name,
    COUNT(DISTINCT COALESCE(te.parent_tconst, te.tconst)) AS uni_num
FROM {{ ref('title_principals') }} AS tp
JOIN {{ ref('name_basics') }} AS nb
    ON tp.nconst = nb.nconst
JOIN {{ ref('title_basics') }} AS tb
    ON tp.tconst = tb.tconst
LEFT JOIN {{ ref('title_episode') }} AS te
    ON tp.tconst = te.tconst
CROSS JOIN UNNEST(SPLIT(tb.genres, ',')) AS genre
WHERE TRIM(genre) = 'Comedy' 
  AND TRIM(tp.category) = 'actor'
GROUP BY genre, nb.primary_name
ORDER BY uni_num DESC
LIMIT 10
