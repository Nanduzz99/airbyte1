{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_airbyte_1",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('poke_pokemon_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        adapter.quote('id'),
        adapter.quote('name'),
        array_to_string('forms'),
        array_to_string('moves'),
        adapter.quote('order'),
        array_to_string('stats'),
        array_to_string(adapter.quote('types')),
        'height',
        'weight',
        'species',
        'sprites',
        array_to_string('abilities'),
        array_to_string('held_items'),
        boolean_to_string(adapter.quote('is_default ')),
        array_to_string('game_indices'),
        'base_experience',
        'location_area_encounters',
    ]) }} as _airbyte_poke_pokemon_hashid,
    tmp.*
from {{ ref('poke_pokemon_ab2') }} tmp
-- poke_pokemon
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at') }}

