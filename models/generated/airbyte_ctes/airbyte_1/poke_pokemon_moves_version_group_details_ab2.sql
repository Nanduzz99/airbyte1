{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_airbyte_1",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('poke_pokemon_moves_version_group_details_ab1') }}
select
    _airbyte_moves_hashid,
    cast(version_group as {{ type_json() }}) as version_group,
    cast(level_learned_at as {{ dbt_utils.type_bigint() }}) as level_learned_at,
    cast(move_learn_method as {{ type_json() }}) as move_learn_method,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('poke_pokemon_moves_version_group_details_ab1') }}
-- version_group_details at poke_pokemon/moves/version_group_details
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at') }}

