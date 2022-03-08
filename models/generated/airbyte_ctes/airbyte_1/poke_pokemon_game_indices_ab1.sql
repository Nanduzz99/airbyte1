{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_airbyte_1",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ ref('poke_pokemon') }}
{{ unnest_cte(ref('poke_pokemon'), 'poke_pokemon', 'game_indices') }}
select
    _airbyte_poke_pokemon_hashid,
    {{ json_extract('', unnested_column_value('game_indices'), ['version'], ['version']) }} as {{ adapter.quote('version') }},
    {{ json_extract_scalar(unnested_column_value('game_indices'), ['game_index'], ['game_index']) }} as game_index,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('poke_pokemon') }} as table_alias
-- game_indices at poke_pokemon/game_indices
{{ cross_join_unnest('poke_pokemon', 'game_indices') }}
where 1 = 1
and game_indices is not null
{{ incremental_clause('_airbyte_emitted_at') }}

