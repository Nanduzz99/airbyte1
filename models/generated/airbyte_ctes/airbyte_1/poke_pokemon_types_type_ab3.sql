{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_airbyte_1",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('poke_pokemon_types_type_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        '_airbyte_types_hashid',
        'url',
        adapter.quote('name'),
    ]) }} as _airbyte_type_hashid,
    tmp.*
from {{ ref('poke_pokemon_types_type_ab2') }} tmp
-- type at poke_pokemon/types/type
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at') }}

