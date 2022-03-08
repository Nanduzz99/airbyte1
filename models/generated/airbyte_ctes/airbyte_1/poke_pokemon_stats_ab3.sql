{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_airbyte_1",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('poke_pokemon_stats_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        '_airbyte_poke_pokemon_hashid',
        'stat',
        'effort',
        'base_stat',
    ]) }} as _airbyte_stats_hashid,
    tmp.*
from {{ ref('poke_pokemon_stats_ab2') }} tmp
-- stats at poke_pokemon/stats
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at') }}

