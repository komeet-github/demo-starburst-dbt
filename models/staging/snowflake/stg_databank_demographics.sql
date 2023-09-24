with source as (

    select * from {{ source('snowflake', 'databank_demographics') }}

),

renamed as (

    select
        cast(iso3166_1 as VARCHAR) as iso3166_1,
        cast(iso3166_2 as VARCHAR) as iso3166_2,
        cast(fips as VARCHAR) as fips,
        latitude,
        longitude,
        cast(state as VARCHAR) as state,
        cast(county as VARCHAR) as county,
        total_population,
        total_male_population,
        total_female_population,
        country_region

    from source

)

select * from renamed
