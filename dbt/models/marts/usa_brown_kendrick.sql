{{ config(
    materialized = 'incremental',
    unique_key = 'year'
) }} WITH core AS (
    SELECT
        *
    FROM
        {{ ref('int_usa_brown_kendrick_core') }}
),
fallback AS (
    SELECT
        year,
        brown_0x0,
        brown_0x1,
        brown_0x2,
        brown_0x3
    FROM
        {{ ref('int_brown_wide') }}
    WHERE
        year >= 1954
),
unioned AS (
    SELECT
        *
    FROM
        core
    UNION
    ALL
    SELECT
        *
    FROM
        fallback
)
SELECT
    year,
    round(brown_0x0) AS brown_0x0,
    round(brown_0x1) AS brown_0x1,
    round(brown_0x2) AS brown_0x2,
    round(brown_0x3) AS brown_0x3
FROM
    unioned {% if is_incremental() %}
WHERE
    year > (
        SELECT
            max(year)
        FROM
            {{ this }}
    ) {% endif %}
