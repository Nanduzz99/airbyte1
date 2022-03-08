{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "airbyte_1",
    tags = [ "nested" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('poke_pokemon_moves_version_group_details_ab3') }}
select
    _airbyte_moves_hashid,
    version_group,
    level_learned_at,
    move_learn_method,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_version_group_details_hashid
from {{ ref('poke_pokemon_moves_version_group_details_ab3') }}
-- version_group_details at poke_pokemon/moves/version_group_details from {{ ref('poke_pokemon_moves') }}
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at') }}

