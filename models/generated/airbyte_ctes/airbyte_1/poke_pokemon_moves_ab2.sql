{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_airbyte_1",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('poke_pokemon_moves_ab1') }}
select
    _airbyte_poke_pokemon_hashid,
    cast({{ adapter.quote('move') }} as {{ type_json() }}) as {{ adapter.quote('move') }},
    version_group_details,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('poke_pokemon_moves_ab1') }}
-- moves at poke_pokemon/moves
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at') }}

