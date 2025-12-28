WITH kendrick AS (
    SELECT
        *
    FROM
        {{ ref('int_kendrick_wide') }}
),
brown AS (
    SELECT
        *
    FROM
        {{ ref('int_brown_wide') }}
),
joined AS (
    SELECT
        k.year,
        k.kta03s07,
        k.kta03s08,
        k.kta10s08,
        k.kta15s07,
        k.kta15s08,
        b.brown_0x4
    FROM
        kendrick k
        LEFT JOIN brown b USING (year)
),
derived AS (
    SELECT
        year,
        -- brown_0x0
        kta03s07 - kta03s08 AS brown_0x0,
        -- brown_0x1
        kta15s07 + kta15s08 AS brown_0x1,
        -- brown_0x2
        avg(kta15s07 + kta15s08) over (
            ORDER BY
                year ROWS BETWEEN 1 preceding
                AND current ROW
        ) * brown_0x4 / 100 AS brown_0x2,
        -- brown_0x3
        kta10s08 AS brown_0x3
    FROM
        joined
)
SELECT
    *
FROM
    derived
WHERE
    brown_0x2 IS NOT NULL
