# Install required python dependencies to run cloudera installation process
{% set pip_index_url = salt['pillar.get']('pip:index_url', 'https://pypi.python.org/simple/') %}

include:
  - python-pip

cdh-cloudera-api:
  pip.installed:
    - pkgs:
      - cm_api == 11.0.0
      - spur == 0.3.17
      - pywebhdfs
    - index_url: {{ pip_index_url }}
    - require:
      - pip: python-pip-install_python_pip
