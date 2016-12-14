{% set install_dir = pillar['pnda']['homedir'] %}
{% set cm_user = pillar['admin_login']['user'] %}
{% set cm_pass = pillar['admin_login']['password'] %}
{% set cm_host = salt['pnda.ip_addresses']('cloudera_manager')[0] %}


include:
  - python-pip
  - cdh.cloudera-api

cm-api-helpers-zk:
  file.managed:
    - name: {{ install_dir }}/cm-api-helpers/zk.py
    - source: salt://cm-api-helpers/templates/zk.py.tpl
    - makedirs: True
    - template: jinja
    - defaults:
        cm_user: {{ cm_user }}
        cm_pass: {{ cm_pass }}
        cm_host: {{ cm_host }}


