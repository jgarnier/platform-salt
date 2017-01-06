{% set flavor_cfg = pillar['pnda_flavor']['states'][sls] %}
{% set virtual_env_dir = pillar['pnda']['homedir'] + "/elasticsearch-curator" %}
{% set pip_extra_index_url = salt['pillar.get']('pip:extra_index_url', '') %}

include:
  - python-pip

curator-python-elasticsearch-curator:
  virtualenv.managed:
    - name: {{ virtual_env_dir }}
    - requirements: salt://curator/files/requirements.txt
{% if pip_extra_index_url != '' %}
    - extra_index_url: {{ pip_extra_index_url }}
{% endif %}
    - require:
      - pip: python-pip-install_python_pip

curator-update-crontab-inc-curator:
  cron.present:
    - identifier: CURATOR-DELETE-INDICES
    - user: root
    - minute: 01
    - hour: 00
    - name: {{ virtual_env_dir }}/bin/curator delete indices --older-than {{ flavor_cfg.days_to_keep }} --time-unit days --prefix logstash- --timestring \%Y.\%m.\%d >> /tmp/curator.log 2>&1
