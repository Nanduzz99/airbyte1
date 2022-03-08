{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_airbyte_1",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ source('airbyte_1', '_airbyte_raw_poke_pokemon') }}
select
    {{ json_extract_scalar('_airbyte_data', ['id'], ['id']) }} as {{ adapter.quote('id') }},
    {{ json_extract_scalar('_airbyte_data', ['name'], ['name']) }} as {{ adapter.quote('name') }},
    {{ json_extract_array('_airbyte_data', ['forms'], ['forms']) }} as forms,
    {{ json_extract_array('_airbyte_data', ['moves'], ['moves']) }} as moves,
    {{ json_extract_scalar('_airbyte_data', ['order'], ['order']) }} as {{ adapter.quote('order') }},
    {{ json_extract_array('_airbyte_data', ['stats'], ['stats']) }} as stats,
    {{ json_extract_array('_airbyte_data', ['types'], ['types']) }} as {{ adapter.quote('types') }},
    {{ json_extract_scalar('_airbyte_data', ['height'], ['height']) }} as height,
    {{ json_extract_scalar('_airbyte_data', ['weight'], ['weight']) }} as weight,
    {{ json_extract('table_alias', '_airbyte_data', ['species'], ['species']) }} as species,
    {{ json_extract('table_alias', '_airbyte_data', ['sprites'], ['sprites']) }} as sprites,
    {{ json_extract_array('_airbyte_data', ['abilities'], ['abilities']) }} as abilities,
    {{ json_extract_array('_airbyte_data', ['held_items'], ['held_items']) }} as held_items,
    {{ json_extract_scalar('_airbyte_data', ['is_default '], ['is_default ']) }} as {{ adapter.quote('is_default ') }},
    {{ json_extract_array('_airbyte_data', ['game_indices'], ['game_indices']) }} as game_indices,
    {{ json_extract_scalar('_airbyte_data', ['base_experience'], ['base_experience']) }} as base_experience,
    {{ json_extract_scalar('_airbyte_data', ['location_area_encounters'], ['location_area_encounters']) }} as location_area_encounters,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ source('airbyte_1', '_airbyte_raw_poke_pokemon') }} as table_alias
-- poke_pokemon
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at') }}

