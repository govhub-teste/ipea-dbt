-- macros/get_airflow_var.sql
{% macro get_airflow_var(name) %}
  {{ env_var(name) | upper }}
{% endmacro %}