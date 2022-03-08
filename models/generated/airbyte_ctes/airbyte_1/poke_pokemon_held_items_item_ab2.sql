{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'btree'}],
    schema = "_airbyte_airbyte_1",
    tags = [ "nested-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
-- depends_on: {{ ref('poke_pokemon_held_items_item_ab1') }}
select
    _airbyte_held_items_hashid,
    cast(url as {{ dbt_utils.type_string() }}) as url,
    cast({{ adapter.quote('name') }} as {{ dbt_utils.type_string() }}) as {{ adapter.quote('name') }},
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('poke_pokemon_held_items_item_ab1') }}
-- item at poke_pokemon/held_items/item
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at') }}

