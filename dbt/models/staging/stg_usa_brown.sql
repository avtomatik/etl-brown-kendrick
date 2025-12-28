SELECT
    cast(period AS integer) AS year,
    series_id,
    cast(value AS double) AS value
FROM
    {{ source('raw', 'brown') }}
