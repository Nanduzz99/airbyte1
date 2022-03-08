{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_airbyte_1",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('poke_pokemon_ab1') }}
select
    cast({{ adapter.quote('id') }} as {{ dbt_utils.type_bigint() }}) as {{ adapter.quote('id') }},
    cast({{ adapter.quote('name') }} as {{ dbt_utils.type_string() }}) as {{ adapter.quote('name') }},
    forms,
    moves,
    cast({{ adapter.quote('order') }} as {{ dbt_utils.type_bigint() }}) as {{ adapter.quote('order') }},
    stats,
    {{ adapter.quote('types') }},
    cast(height as {{ dbt_utils.type_bigint() }}) as height,
    cast(weight as {{ dbt_utils.type_bigint() }}) as weight,
    cast(species as {{ type_json() }}) as species,
    cast(sprites as {{ type_json() }}) as sprites,
    abilities,
    held_items,
    {{ cast_to_boolean(adapter.quote('is_default ')) }} as {{ adapter.quote('is_default ') }},
    game_indices,
    cast(base_experience as {{ dbt_utils.type_bigint() }}) as base_experience,
    cast(location_area_encounters as {{ dbt_utils.type_string() }}) as location_area_encounters,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('poke_pokemon_ab1') }}
-- poke_pokemon
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at') }}

