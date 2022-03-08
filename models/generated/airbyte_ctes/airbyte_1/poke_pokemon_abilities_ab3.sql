{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_airbyte_1",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('poke_pokemon_abilities_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        '_airbyte_poke_pokemon_hashid',
        'slot',
        'ability',
        boolean_to_string('is_hidden'),
    ]) }} as _airbyte_abilities_hashid,
    tmp.*
from {{ ref('poke_pokemon_abilities_ab2') }} tmp
-- abilities at poke_pokemon/abilities
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at') }}

