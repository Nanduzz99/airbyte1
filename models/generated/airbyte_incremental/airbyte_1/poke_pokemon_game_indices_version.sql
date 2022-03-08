{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "airbyte_1",
    tags = [ "nested" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('poke_pokemon_game_indices_version_ab3') }}
select
    _airbyte_game_indices_hashid,
    url,
    {{ adapter.quote('name') }},
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_version_hashid
from {{ ref('poke_pokemon_game_indices_version_ab3') }}
-- version at poke_pokemon/game_indices/version from {{ ref('poke_pokemon_game_indices') }}
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at') }}

