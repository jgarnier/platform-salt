{% set pip_extra_index_url = salt['pillar.get']('pip:extra_index_url', '') %}

snappy-install-snappy:
  pkg.installed:
    - name: python-snappy
{% if pip_extra_index_url != '' %}
    - extra_index_url: {{ pip_extra_index_url }}
{% endif %}
    - reload_modules: True
