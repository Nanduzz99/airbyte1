{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "airbyte_1",
    tags = [ "nested" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('poke_pokemon_moves_v__details_version_group_ab3') }}
select
    _airbyte_version_group_details_hashid,
    url,
    {{ adapter.quote('name') }},
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_version_group_hashid
from {{ ref('poke_pokemon_moves_v__details_version_group_ab3') }}
-- version_group at poke_pokemon/moves/version_group_details/version_group from {{ ref('poke_pokemon_moves_version_group_details') }}
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at') }}

