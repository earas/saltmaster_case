# Get minion id from pillar
{% set minion = pillar['minion'] %}

# Refresh minion data
saltutil.sync_all:
  salt.function:
    - tgt: {{ minion }}
    - reload_modules: True

saltutil.refresh_grains:
  salt.function:
    - tgt: {{ minion }}

saltutil.sync_grains:
  salt.function:
    - tgt: {{ minion }}
    - kwargs:
        saltenv: base

saltutil.refresh_pillar:
  salt.function:
    - tgt: {{ minion }}

mine.update:
  salt.function:
    - tgt: {{ minion }}


{% set role = salt['saltutil.runner']('cache.grains', tgt=minion)[minion].get('role', []) %}
{% if
    'kafka' in role or
    'monitoring' in role or
    'zookeeper' in role or
    'vault' in role
%}
  {% set run_highstate = True %}
{% else %}
  {% set run_highstate = False %}
{% endif %}

{% set status = salt['saltutil.runner']('cache.grains', tgt=minion)[minion].get('status', True) %}
{% if status == False %}
run_initialize_state:
  salt.state:
    - tgt: {{ minion }}
    - sls:
      - firstjobs

  {% if run_highstate == True %}
run_highstate:
  salt.state:
    - tgt: {{ minion }}
    - highstate: True
  {% endif %}
{% endif %}