{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_airbyte_1",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('poke_pokemon_moves_version_group_details_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        '_airbyte_moves_hashid',
        'version_group',
        'level_learned_at',
        'move_learn_method',
    ]) }} as _airbyte_version_group_details_hashid,
    tmp.*
from {{ ref('poke_pokemon_moves_version_group_details_ab2') }} tmp
-- version_group_details at poke_pokemon/moves/version_group_details
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at') }}

