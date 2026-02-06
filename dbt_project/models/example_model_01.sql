-- Simple model to demonstrate parse performance
{{ config(
    materialized='table',
    partition_by={
      "field": "created_at",
      "data_type": "timestamp",
      "granularity": "day"
    },
    cluster_by=["user_id", "status"]
) }}

select
    1 as user_id,
    'active' as status,
    current_timestamp() as created_at,
    'test_value' as name
