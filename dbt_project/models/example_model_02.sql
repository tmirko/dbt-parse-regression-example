-- Model with config() and standard BigQuery features
{{ config(
    materialized='incremental',
    unique_key='id',
    on_schema_change='append_new_columns',
    partition_by={
      "field": "event_date",
      "data_type": "date"
    }
) }}

select
    2 as id,
    current_date() as event_date,
    'event_type_a' as event_type,
    cast(100.50 as numeric) as amount

{% if is_incremental() %}
  where event_date > (select max(event_date) from {{ this }})
{% endif %}
