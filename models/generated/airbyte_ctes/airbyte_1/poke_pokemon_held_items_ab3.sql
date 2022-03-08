{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_airbyte_1",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('poke_pokemon_held_items_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        '_airbyte_poke_pokemon_hashid',
        'item',
        array_to_string('version_details'),
    ]) }} as _airbyte_held_items_hashid,
    tmp.*
from {{ ref('poke_pokemon_held_items_ab2') }} tmp
-- held_items at poke_pokemon/held_items
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at') }}

