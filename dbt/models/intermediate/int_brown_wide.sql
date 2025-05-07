SELECT
    year,
    max(
        CASE
            WHEN series_id = 'brown_0x0' THEN value
        END
    ) AS brown_0x0,
    max(
        CASE
            WHEN series_id = 'brown_0x1' THEN value
        END
    ) AS brown_0x1,
    max(
        CASE
            WHEN series_id = 'brown_0x2' THEN value
        END
    ) AS brown_0x2,
    max(
        CASE
            WHEN series_id = 'brown_0x3' THEN value
        END
    ) AS brown_0x3,
    max(
        CASE
            WHEN series_id = 'brown_0x4' THEN value
        END
    ) AS brown_0x4
FROM
    {{ ref('stg_usa_brown') }}
GROUP BY
    year
