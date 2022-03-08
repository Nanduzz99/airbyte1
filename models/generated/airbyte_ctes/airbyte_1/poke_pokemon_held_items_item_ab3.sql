{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_airbyte_1",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('poke_pokemon_held_items_item_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        '_airbyte_held_items_hashid',
        'url',
        adapter.quote('name'),
    ]) }} as _airbyte_item_hashid,
    tmp.*
from {{ ref('poke_pokemon_held_items_item_ab2') }} tmp
-- item at poke_pokemon/held_items/item
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at') }}

