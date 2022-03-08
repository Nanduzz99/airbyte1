{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_airbyte_1",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ ref('poke_pokemon_moves_version_group_details') }}
select
    _airbyte_version_group_details_hashid,
    {{ json_extract_scalar('version_group', ['url'], ['url']) }} as url,
    {{ json_extract_scalar('version_group', ['name'], ['name']) }} as {{ adapter.quote('name') }},
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('poke_pokemon_moves_version_group_details') }} as table_alias
-- version_group at poke_pokemon/moves/version_group_details/version_group
where 1 = 1
and version_group is not null
{{ incremental_clause('_airbyte_emitted_at') }}

