{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_airbyte_1",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ ref('poke_pokemon') }}
{{ unnest_cte(ref('poke_pokemon'), 'poke_pokemon', 'stats') }}
select
    _airbyte_poke_pokemon_hashid,
    {{ json_extract('', unnested_column_value('stats'), ['stat'], ['stat']) }} as stat,
    {{ json_extract_scalar(unnested_column_value('stats'), ['effort'], ['effort']) }} as effort,
    {{ json_extract_scalar(unnested_column_value('stats'), ['base_stat'], ['base_stat']) }} as base_stat,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('poke_pokemon') }} as table_alias
-- stats at poke_pokemon/stats
{{ cross_join_unnest('poke_pokemon', 'stats') }}
where 1 = 1
and stats is not null
{{ incremental_clause('_airbyte_emitted_at') }}

