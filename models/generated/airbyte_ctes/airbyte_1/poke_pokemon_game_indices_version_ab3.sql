{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_airbyte_1",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('poke_pokemon_game_indices_version_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        '_airbyte_game_indices_hashid',
        'url',
        adapter.quote('name'),
    ]) }} as _airbyte_version_hashid,
    tmp.*
from {{ ref('poke_pokemon_game_indices_version_ab2') }} tmp
-- version at poke_pokemon/game_indices/version
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at') }}

