{#
    Parse an integer-encoded date (e.g. 20101229) into a proper DATE.

    The CRM sales feed stores order/ship/due dates as 8-digit integers, and
    uses 0 (or malformed lengths) for "missing". This mirrors the CASE logic
    from the original silver-layer load procedure, made reusable.
#}
{% macro parse_yyyymmdd(column_name) %}
    case
        when {{ column_name }} = 0 or length(cast({{ column_name }} as varchar)) != 8 then null
        else strptime(cast({{ column_name }} as varchar), '%Y%m%d')::date
    end
{% endmacro %}
