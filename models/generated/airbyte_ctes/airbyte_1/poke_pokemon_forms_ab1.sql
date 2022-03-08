{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_airbyte_1",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ ref('poke_pokemon') }}
{{ unnest_cte(ref('poke_pokemon'), 'poke_pokemon', 'forms') }}
select
    _airbyte_poke_pokemon_hashid,
    {{ json_extract_scalar(unnested_column_value('forms'), ['url'], ['url']) }} as url,
    {{ json_extract_scalar(unnested_column_value('forms'), ['name'], ['name']) }} as {{ adapter.quote('name') }},
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('poke_pokemon') }} as table_alias
-- forms at poke_pokemon/forms
{{ cross_join_unnest('poke_pokemon', 'forms') }}
where 1 = 1
and forms is not null
{{ incremental_clause('_airbyte_emitted_at') }}

