{{ config(
    materialized='table'
) }}

SELECT * FROM {{ source('imdb', 'reviews') }}
