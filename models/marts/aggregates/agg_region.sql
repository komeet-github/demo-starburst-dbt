{{ config(tags = ['aggregate']) }}


with cases as (
    select * from {{ ref('int_aws_cases') }}
),

populations as (
    select * from {{ ref('int_snow_population') }}
),

locations as (
    select * from {{ ref('int_tpch_location') }}
),

final as (
    
    select
        cases.country,
        locations.nation_key,
        cases.confirmed,
        locations.region,
        populations.total_population,
        populations.vaccinated_population,
        first_value(cases.last_update) OVER (
            PARTITION BY cases.fips ORDER BY cases.last_update DESC) AS most_recent,
        cases.last_update
    from
        cases
    inner join locations
            on cases.country = locations.nation
    inner join populations
            on locations.nation = populations.country_region
)

select
    'COVID KPIs' as covid, 
    region,
    SUM(CAST(confirmed as int)) AS total_confirmed_cases,
    MAX(total_population) as total_region_population,
    MAX(vaccinated_population) as vaccinated_population
from
    final
WHERE
    last_update = most_recent
GROUP BY
    region
ORDER BY
    total_confirmed_cases DESC