{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_airbyte_1",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('poke_pokemon_sprites_ab1') }}
select
    _airbyte_poke_pokemon_hashid,
    cast(back_shiny as {{ dbt_utils.type_string() }}) as back_shiny,
    cast(back_female as {{ dbt_utils.type_string() }}) as back_female,
    cast(front_shiny as {{ dbt_utils.type_string() }}) as front_shiny,
    cast(back_default as {{ dbt_utils.type_string() }}) as back_default,
    cast(front_female as {{ dbt_utils.type_string() }}) as front_female,
    cast(front_default as {{ dbt_utils.type_string() }}) as front_default,
    cast(back_shiny_female as {{ dbt_utils.type_string() }}) as back_shiny_female,
    cast(front_shiny_female as {{ dbt_utils.type_string() }}) as front_shiny_female,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('poke_pokemon_sprites_ab1') }}
-- sprites at poke_pokemon/sprites
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at') }}

