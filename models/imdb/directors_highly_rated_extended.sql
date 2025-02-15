{{ config(
    materialized='table'
) }}

WITH temporary_table AS (
    SELECT 
        nb.primary_name, 
        COUNT(DISTINCT COALESCE(te.parent_tconst, te.tconst)) AS num_works
    FROM {{ ref('title_ratings') }} AS tr
    JOIN {{ ref('title_principals') }} AS tp
        ON tr.tconst = tp.tconst
    JOIN {{ ref('name_basics') }} AS nb
        ON tp.nconst = nb.nconst
    JOIN {{ ref('title_basics') }} AS tb
        ON tr.tconst = tb.tconst
    LEFT JOIN {{ ref('title_episode') }} AS te
        ON tb.tconst = te.tconst
    WHERE TRIM(tp.category) = 'director' 
        AND tr.average_rating >= 8 
        AND tb.start_year IS NOT NULL
    GROUP BY nb.primary_name
    HAVING num_works >= 40
    ORDER BY num_works DESC
)

SELECT 
    nb.primary_name, 
    MIN(tb.start_year) AS start_year_fixed, 
    ROUND(AVG(tr.average_rating), 1) AS ave_rating_fixed,
    tt.num_works, 
    COALESCE(te.parent_tconst, te.tconst) AS works_name
FROM {{ ref('title_ratings') }} AS tr
JOIN {{ ref('title_principals') }} AS tp
    ON tr.tconst = tp.tconst
JOIN {{ ref('name_basics') }} AS nb
    ON tp.nconst = nb.nconst
JOIN {{ ref('title_basics') }} AS tb
    ON tr.tconst = tb.tconst
LEFT JOIN {{ ref('title_episode') }} AS te
    ON tb.tconst = te.tconst
JOIN temporary_table AS tt
    ON nb.primary_name = tt.primary_name
WHERE TRIM(tp.category) = 'director' 
    AND tr.average_rating >= 8 
    AND tb.start_year IS NOT NULL
GROUP BY nb.primary_name, tt.num_works, works_name
ORDER BY nb.primary_name, start_year_fixed
