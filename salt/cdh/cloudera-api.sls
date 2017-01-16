# Install required python dependencies to run cloudera installation process
{% set pip_extra_index_url = salt['pillar.get']('pip:extra_index_url', '') %}

include:
  - python-pip

cdh-cloudera-api:
  pip.installed:
    - pkgs:
      - cm_api == 11.0.0
      - spur == 0.3.17
      - pywebhdfs
{% if pip_extra_index_url != '' %}
    - extra_index_url: {{ pip_extra_index_url }}
{% endif %}
    - require:
      - pip: python-pip-install_python_pip
