{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_airbyte_1",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('poke_pokemon_held_items_version_details_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        '_airbyte_held_items_hashid',
        'rarity',
        adapter.quote('version'),
    ]) }} as _airbyte_version_details_hashid,
    tmp.*
from {{ ref('poke_pokemon_held_items_version_details_ab2') }} tmp
-- version_details at poke_pokemon/held_items/version_details
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at') }}

