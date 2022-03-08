{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_airbyte_1",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('poke_pokemon_stats_ab1') }}
select
    _airbyte_poke_pokemon_hashid,
    cast(stat as {{ type_json() }}) as stat,
    cast(effort as {{ dbt_utils.type_bigint() }}) as effort,
    cast(base_stat as {{ dbt_utils.type_bigint() }}) as base_stat,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('poke_pokemon_stats_ab1') }}
-- stats at poke_pokemon/stats
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at') }}

