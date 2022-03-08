{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_airbyte_1",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ ref('poke_pokemon_stats') }}
select
    _airbyte_stats_hashid,
    {{ json_extract_scalar('stat', ['url'], ['url']) }} as url,
    {{ json_extract_scalar('stat', ['name'], ['name']) }} as {{ adapter.quote('name') }},
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('poke_pokemon_stats') }} as table_alias
-- stat at poke_pokemon/stats/stat
where 1 = 1
and stat is not null
{{ incremental_clause('_airbyte_emitted_at') }}

