{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_airbyte_1",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to parse JSON blob stored in a single column and extract into separated field columns as described by the JSON Schema
-- depends_on: {{ ref('poke_pokemon') }}
select
    _airbyte_poke_pokemon_hashid,
    {{ json_extract_scalar('sprites', ['back_shiny'], ['back_shiny']) }} as back_shiny,
    {{ json_extract_scalar('sprites', ['back_female'], ['back_female']) }} as back_female,
    {{ json_extract_scalar('sprites', ['front_shiny'], ['front_shiny']) }} as front_shiny,
    {{ json_extract_scalar('sprites', ['back_default'], ['back_default']) }} as back_default,
    {{ json_extract_scalar('sprites', ['front_female'], ['front_female']) }} as front_female,
    {{ json_extract_scalar('sprites', ['front_default'], ['front_default']) }} as front_default,
    {{ json_extract_scalar('sprites', ['back_shiny_female'], ['back_shiny_female']) }} as back_shiny_female,
    {{ json_extract_scalar('sprites', ['front_shiny_female'], ['front_shiny_female']) }} as front_shiny_female,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('poke_pokemon') }} as table_alias
-- sprites at poke_pokemon/sprites
where 1 = 1
and sprites is not null
{{ incremental_clause('_airbyte_emitted_at') }}

