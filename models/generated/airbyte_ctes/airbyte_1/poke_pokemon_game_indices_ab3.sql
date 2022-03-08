{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_airbyte_1",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('poke_pokemon_game_indices_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        '_airbyte_poke_pokemon_hashid',
        adapter.quote('version'),
        'game_index',
    ]) }} as _airbyte_game_indices_hashid,
    tmp.*
from {{ ref('poke_pokemon_game_indices_ab2') }} tmp
-- game_indices at poke_pokemon/game_indices
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at') }}

