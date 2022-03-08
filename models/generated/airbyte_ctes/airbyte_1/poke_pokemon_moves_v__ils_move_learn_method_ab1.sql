{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_airbyte_1",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ ref('poke_pokemon_moves_version_group_details') }}
select
    _airbyte_version_group_details_hashid,
    {{ json_extract_scalar('move_learn_method', ['url'], ['url']) }} as url,
    {{ json_extract_scalar('move_learn_method', ['name'], ['name']) }} as {{ adapter.quote('name') }},
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('poke_pokemon_moves_version_group_details') }} as table_alias
-- move_learn_method at poke_pokemon/moves/version_group_details/move_learn_method
where 1 = 1
and move_learn_method is not null
{{ incremental_clause('_airbyte_emitted_at') }}

