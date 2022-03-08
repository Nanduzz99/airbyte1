{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_airbyte_1",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ ref('poke_pokemon') }}
{{ unnest_cte(ref('poke_pokemon'), 'poke_pokemon', 'held_items') }}
select
    _airbyte_poke_pokemon_hashid,
    {{ json_extract('', unnested_column_value('held_items'), ['item'], ['item']) }} as item,
    {{ json_extract_array(unnested_column_value('held_items'), ['version_details'], ['version_details']) }} as version_details,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('poke_pokemon') }} as table_alias
-- held_items at poke_pokemon/held_items
{{ cross_join_unnest('poke_pokemon', 'held_items') }}
where 1 = 1
and held_items is not null
{{ incremental_clause('_airbyte_emitted_at') }}

