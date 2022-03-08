{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_airbyte_1",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('poke_pokemon_moves_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        '_airbyte_poke_pokemon_hashid',
        adapter.quote('move'),
        array_to_string('version_group_details'),
    ]) }} as _airbyte_moves_hashid,
    tmp.*
from {{ ref('poke_pokemon_moves_ab2') }} tmp
-- moves at poke_pokemon/moves
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at') }}

