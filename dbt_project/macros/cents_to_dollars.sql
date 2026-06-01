{#
    Reusable example macro: convert an integer amount stored in cents into a
    rounded dollar value. Demonstrates how repeated transformation logic can be
    centralised once and reused across models, e.g.

        select {{ cents_to_dollars('amount_cents') }} as amount_usd

    (The current sources already store whole-currency amounts, so this is
    provided as a template for future feeds that arrive in cents.)
#}
{% macro cents_to_dollars(column_name, decimal_places=2) %}
    round(cast({{ column_name }} as numeric) / 100, {{ decimal_places }})
{% endmacro %}
