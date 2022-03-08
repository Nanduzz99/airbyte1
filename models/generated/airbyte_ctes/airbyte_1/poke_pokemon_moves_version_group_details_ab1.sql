{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_airbyte_1",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ ref('poke_pokemon_moves') }}
{{ unnest_cte(ref('poke_pokemon_moves'), 'moves', 'version_group_details') }}
select
    _airbyte_moves_hashid,
    {{ json_extract('', unnested_column_value('version_group_details'), ['version_group'], ['version_group']) }} as version_group,
    {{ json_extract_scalar(unnested_column_value('version_group_details'), ['level_learned_at'], ['level_learned_at']) }} as level_learned_at,
    {{ json_extract('', unnested_column_value('version_group_details'), ['move_learn_method'], ['move_learn_method']) }} as move_learn_method,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('poke_pokemon_moves') }} as table_alias
-- version_group_details at poke_pokemon/moves/version_group_details
{{ cross_join_unnest('moves', 'version_group_details') }}
where 1 = 1
and version_group_details is not null
{{ incremental_clause('_airbyte_emitted_at') }}

