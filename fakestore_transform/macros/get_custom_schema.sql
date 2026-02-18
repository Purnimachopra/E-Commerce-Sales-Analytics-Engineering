{% macro generate_schema_name(custom_schema_name, node) -%}
    
    {# If this is a test failure table, let dbt use its default naming #}
    {%- if node.resource_type == 'test' -%}
        {{ target.schema }}_dbt_test__audit
        
    {# If we specified a schema like 'silver', use ONLY that name #}
    {%- elif custom_schema_name is not none -%}
        {{ custom_schema_name | trim }}
        
    {# Fallback to the default schema from profiles.yml #}
    {%- else -%}
        {{ target.schema }}
    {%- endif -%}

{%- endmacro %}
