{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_airbyte_1",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ ref('poke_pokemon_abilities') }}
select
    _airbyte_abilities_hashid,
    {{ json_extract_scalar('ability', ['url'], ['url']) }} as url,
    {{ json_extract_scalar('ability', ['name'], ['name']) }} as {{ adapter.quote('name') }},
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('poke_pokemon_abilities') }} as table_alias
-- ability at poke_pokemon/abilities/ability
where 1 = 1
and ability is not null
{{ incremental_clause('_airbyte_emitted_at') }}

