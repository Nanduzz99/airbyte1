{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "airbyte_1",
    tags = [ "nested" ]
) }}
-- Final base SQL model
-- depends_on: {{ ref('poke_pokemon_abilities_ability_ab3') }}
select
    _airbyte_abilities_hashid,
    url,
    {{ adapter.quote('name') }},
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at,
    _airbyte_ability_hashid
from {{ ref('poke_pokemon_abilities_ability_ab3') }}
-- ability at poke_pokemon/abilities/ability from {{ ref('poke_pokemon_abilities') }}
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at') }}

