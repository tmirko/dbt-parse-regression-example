-- Model with various BigQuery configurations
{{ config(
    materialized='table',
    partition_by={
      "field": "created_date",
      "data_type": "date"
    },
    cluster_by=["category"]
) }}

select
    current_date() as created_date,
    'category_a' as category,
    rand() as random_value,
    struct('key' as name, 'value' as value) as metadata
