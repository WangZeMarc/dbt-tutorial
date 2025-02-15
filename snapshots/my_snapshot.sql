{% snapshot my_snapshot %}

{{
    config(
        target_schema='imdb',
        unique_key='tconst',
        strategy='check',
        check_cols='all'
    )
}}

SELECT * FROM imdb.title_basics

{% endsnapshot %}
