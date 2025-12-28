SELECT
    year,
    max(
        CASE
            WHEN series_id = 'KTA03S07' THEN value
        END
    ) AS kta03s07,
    max(
        CASE
            WHEN series_id = 'KTA03S08' THEN value
        END
    ) AS kta03s08,
    max(
        CASE
            WHEN series_id = 'KTA10S08' THEN value
        END
    ) AS kta10s08,
    max(
        CASE
            WHEN series_id = 'KTA15S07' THEN value
        END
    ) AS kta15s07,
    max(
        CASE
            WHEN series_id = 'KTA15S08' THEN value
        END
    ) AS kta15s08
FROM
    {{ ref('stg_usa_kendrick') }}
WHERE
    year BETWEEN 1889
    AND 1954
GROUP BY
    year
