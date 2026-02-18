{{ config(
    materialized='table',
    schema='silver'
) }}

WITH expanded_carts AS (
    SELECT 
        id AS cart_id,
        "userId" AS user_id,
        -- Postgres cast to timestamp
        "date"::timestamp AS sale_at,
        -- SIT Trick: Handle the single quote issue in the nested products array
        json_array_elements(REPLACE(products, '''', '"')::json) AS product_item
    FROM {{ source('raw', 'stg_carts') }}
)

SELECT
    -- Create a Unique Sale ID (Surrogate Key) using MD5
     -- md5(cart_id || '-' || (product_item->>'productId') || '-' || sale_at) AS sale_key,
    
    md5(coalesce(cast(cart_id as text), 'na') || '-' || coalesce(product_item->>'productId', 'na'))  AS sale_key,
    cart_id,
    user_id,
    (product_item->>'productId')::int AS product_id,
    (product_item->>'quantity')::int AS quantity,
    sale_at,
    -- Join with your Silver Dimension to get the price
    p.unit_price,
    ((product_item->>'quantity')::int * p.unit_price) AS total_revenue
FROM expanded_carts ec
INNER JOIN {{ ref('dim_products') }} p 
    ON (ec.product_item->>'productId')::int = p.product_id
