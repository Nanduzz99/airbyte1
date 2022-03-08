{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "airbyte_1",
    tags = [ "top-level" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('poke_pokemon_ab3') }}
select
    {{ adapter.quote('id') }},
    {{ adapter.quote('name') }},
    forms,
    moves,
    {{ adapter.quote('order') }},
    stats,
    {{ adapter.quote('types') }},
    height,
    weight,
    species,
    sprites,
    abilities,
    held_items,
    {{ adapter.quote('is_default ') }},
    game_indices,
    base_experience,
    location_area_encounters,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_poke_pokemon_hashid
from {{ ref('poke_pokemon_ab3') }}
-- poke_pokemon from {{ source('airbyte_1', '_airbyte_raw_poke_pokemon') }}
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at') }}

