{{ config(
    materialized='table'
) }}


SELECT
    nb.primary_name,
    COUNT(tr.tconst) AS counts_per_actor
FROM {{ ref('title_ratings') }} AS tr
JOIN {{ ref('title_principals') }} AS tp
    ON tr.tconst = tp.tconst
JOIN {{ ref('title_basics') }} AS tb
    ON tr.tconst = tb.tconst
JOIN {{ ref('name_basics') }} AS nb
    ON tp.nconst = nb.nconst
WHERE TRIM(tb.title_type) = 'movie'
  AND tr.average_rating >= 9
  AND TRIM(tp.category) = 'actor'
GROUP BY nb.primary_name
HAVING counts_per_actor >= 10
ORDER BY counts_per_actor DESC
