{% macro drop_ci_schemas() %}
  {% set rows = run_query("SHOW SCHEMAS IN workspace LIKE '" ~ target.schema ~ "_*'") %}
  {% for row in rows %}
    {% do run_query("DROP SCHEMA IF EXISTS workspace." ~ row[0] ~ " CASCADE") %}
    {{ log("dropped " ~ row[0], info=True) }}
  {% endfor %}
{% endmacro %}