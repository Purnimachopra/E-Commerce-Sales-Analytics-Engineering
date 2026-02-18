-- dbt tests fail if this query returns ANY rows.
-- Since we use SELECT *, the audit table will store the WHOLE row.
--select *
--from {{ ref('fact_sales') }}
--where product_id not in (select product_id from {{ ref('dim_products') }})
-- This test checks for "Source Data Quality" 
-- It will FAIL if the API sends a bad Product ID, 
-- even if your Fact table is clean.



WITH raw_source AS (
    SELECT 
        id AS cart_id,
        "userId" AS user_id,
        "date" AS sale_at,
        -- Flatten the JSON array
        json_array_elements(REPLACE(products, '''', '"')::json) AS product_item
    FROM {{ source('raw', 'stg_carts') }}
)

SELECT DISTINCT
    cart_id,
    user_id,
    sale_at,
    (product_item->>'productId')::int AS bad_product_id,
    (product_item->>'quantity')::int AS quantity,
    -- Add a descriptive reason for the SIT report
    'Product ID not found in dim_products' AS failure_reason,
    CURRENT_TIMESTAMP AS detected_at
FROM raw_source
WHERE (product_item->>'productId')::int NOT IN (
    SELECT product_id FROM {{ ref('dim_products') }}
)
