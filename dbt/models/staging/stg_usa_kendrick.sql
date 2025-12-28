WITH typed AS (
    SELECT
        cast(period AS integer) AS year,
        series_id,
        cast(value AS double) AS value
    FROM
        {{ source('raw', 'kendrick') }}
),
filtered AS (
    SELECT
        *
    FROM
        typed
    WHERE
        series_id IN (
            'KTA03S07',
            'KTA03S08',
            'KTA10S08',
            'KTA15S07',
            'KTA15S08'
        )
),
deduplicated AS (
    SELECT
        year,
        series_id,
        value,
        row_number() over (
            PARTITION by year,
            series_id
            ORDER BY
                year
        ) AS rn
    FROM
        filtered
)
SELECT
    year,
    series_id,
    value
FROM
    deduplicated
WHERE
    rn = 1
