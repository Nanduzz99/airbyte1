{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_airbyte_1",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ ref('poke_pokemon_held_items') }}
select
    _airbyte_held_items_hashid,
    {{ json_extract_scalar('item', ['url'], ['url']) }} as url,
    {{ json_extract_scalar('item', ['name'], ['name']) }} as {{ adapter.quote('name') }},
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('poke_pokemon_held_items') }} as table_alias
-- item at poke_pokemon/held_items/item
where 1 = 1
and item is not null
{{ incremental_clause('_airbyte_emitted_at') }}

