{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_airbyte_1",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('poke_pokemon_game_indices_ab1') }}
select
    _airbyte_poke_pokemon_hashid,
    cast({{ adapter.quote('version') }} as {{ type_json() }}) as {{ adapter.quote('version') }},
    cast(game_index as {{ dbt_utils.type_bigint() }}) as game_index,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('poke_pokemon_game_indices_ab1') }}
-- game_indices at poke_pokemon/game_indices
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at') }}

