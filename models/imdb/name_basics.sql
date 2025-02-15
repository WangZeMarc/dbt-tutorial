{{ config(
    materialized='table'
) }}

SELECT * FROM {{ source('imdb', 'name_basics') }}
