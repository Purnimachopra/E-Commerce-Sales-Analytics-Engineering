-- This tells dbt to create this as a table in the 'silver' schema
{{ config(materialized='table', schema='silver') }}

SELECT
    id AS product_id,
    title,
    price AS unit_price,
    -- Simple cleaning: making sure category is lowercase
    LOWER(category) AS category,
    -- Adding a system timestamp for auditing (Great for SIT!)
    CURRENT_TIMESTAMP AS loaded_at
FROM {{ source('raw', 'stg_products') }}
