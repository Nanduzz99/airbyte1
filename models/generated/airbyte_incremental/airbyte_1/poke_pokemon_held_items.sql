{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "airbyte_1",
    tags = [ "nested" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('poke_pokemon_held_items_ab3') }}
select
    _airbyte_poke_pokemon_hashid,
    item,
    version_details,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_held_items_hashid
from {{ ref('poke_pokemon_held_items_ab3') }}
-- held_items at poke_pokemon/held_items from {{ ref('poke_pokemon') }}
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at') }}

