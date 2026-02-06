-- Model with refs and macros
{{ config(
    materialized='view',
    labels={'env': 'dev', 'team': 'analytics'}
) }}

select
    id,
    event_date,
    event_type,
    amount,
    amount * 1.1 as amount_with_tax
from {{ ref('example_model_02') }}
where event_type is not null
