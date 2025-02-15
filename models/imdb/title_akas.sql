{{ config(
    materialized='table'
) }}

SELECT * FROM {{ source('imdb', 'title_akas') }}
