{% set pip_index_url = salt['pillar.get']('pip:index_url', 'https://pypi.python.org/simple/') %}

include:
  - python-pip

install_python_deps:
  pip.installed:
    - pkgs:
      - cm_api == 11.0.0
    - index_url: {{ pip_index_url }}
    - reload_modules: True
    - require:
      - pip: python-pip-install_python_pip
