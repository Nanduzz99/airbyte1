{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_airbyte_1",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ ref('poke_pokemon_game_indices') }}
select
    _airbyte_game_indices_hashid,
    {{ json_extract_scalar(adapter.quote('version'), ['url'], ['url']) }} as url,
    {{ json_extract_scalar(adapter.quote('version'), ['name'], ['name']) }} as {{ adapter.quote('name') }},
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('poke_pokemon_game_indices') }} as table_alias
-- version at poke_pokemon/game_indices/version
where 1 = 1
and {{ adapter.quote('version') }} is not null
{{ incremental_clause('_airbyte_emitted_at') }}

