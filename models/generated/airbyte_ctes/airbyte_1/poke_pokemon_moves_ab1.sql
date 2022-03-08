{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_airbyte_1",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ ref('poke_pokemon') }}
{{ unnest_cte(ref('poke_pokemon'), 'poke_pokemon', 'moves') }}
select
    _airbyte_poke_pokemon_hashid,
    {{ json_extract('', unnested_column_value('moves'), ['move'], ['move']) }} as {{ adapter.quote('move') }},
    {{ json_extract_array(unnested_column_value('moves'), ['version_group_details'], ['version_group_details']) }} as version_group_details,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('poke_pokemon') }} as table_alias
-- moves at poke_pokemon/moves
{{ cross_join_unnest('poke_pokemon', 'moves') }}
where 1 = 1
and moves is not null
{{ incremental_clause('_airbyte_emitted_at') }}

