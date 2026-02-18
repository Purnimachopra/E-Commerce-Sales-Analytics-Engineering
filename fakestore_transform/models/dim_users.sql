{{ config(materialized='table', schema='silver') }}

WITH cleaned_users AS (
    SELECT 
        id,
        email,
        username,
        -- Replace single quotes with double quotes to make it valid JSON
        REPLACE(address, '''', '"')::json AS address_json,
        REPLACE(name, '''', '"')::json AS name_json
    FROM {{ source('raw', 'stg_users') }}
)

SELECT
    id AS user_id,
    email,
    username,
    address_json->>'city' AS city,
    address_json->>'zipcode' AS zipcode,
    name_json->>'firstname' AS first_name,
    name_json->>'lastname' AS last_name,
    CURRENT_TIMESTAMP AS loaded_at
FROM cleaned_users
