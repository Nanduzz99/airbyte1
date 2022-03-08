{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "airbyte_1",
    tags = [ "nested" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('poke_pokemon_sprites_ab3') }}
select
    _airbyte_poke_pokemon_hashid,
    back_shiny,
    back_female,
    front_shiny,
    back_default,
    front_female,
    front_default,
    back_shiny_female,
    front_shiny_female,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_sprites_hashid
from {{ ref('poke_pokemon_sprites_ab3') }}
-- sprites at poke_pokemon/sprites from {{ ref('poke_pokemon') }}
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at') }}

