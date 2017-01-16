{% set pip_extra_index_url = salt['pillar.get']('pip:extra_index_url', '') %}

include:
  - python-pip

install_python_deps:
  pip.installed:
    - pkgs:
      - cm_api == 11.0.0
{% if pip_extra_index_url != '' %}
    - extra_index_url: {{ pip_extra_index_url }}
{% endif %}
    - reload_modules: True
    - require:
      - pip: python-pip-install_python_pip
