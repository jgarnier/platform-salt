{%- set cm_ver = '5.9.0' -%}

{%- set mysql_root_password = salt['pillar.get']('mysql:root_pw', 'mysqldefault') -%}
{%- set cmdb_host = salt['pnda.ip_addresses']('oozie_database')[0] -%}
{%- set cm_host = salt['pnda.ip_addresses']('cloudera_manager')[0] -%}
{%- set cmdb_user = salt['pillar.get']('cloudera:cmdb:user', 'scm') -%}
{%- set cmdb_database = salt['pillar.get']('cloudera:cmdb:database', 'scm') -%}
{%- set cmdb_password = salt['pillar.get']('cloudera:cmdb:password', 'scm') -%}
{%- set cm_mirror = salt['pillar.get']('cloudera:cm_mirror', 'https://archive.cloudera.com/cm5/ubuntu/trusty/amd64/cm') -%}

include:
  - java
  - mysql.connector

cloudera-manager-add_cloudera_manager_repository:
  pkgrepo.managed:
    - humanname: Cloudera Manager
    - name: deb [arch=amd64] {{ cm_mirror }} trusty-cm{{cm_ver}} contrib
    - dist: trusty-cm{{cm_ver}}
    - key_url: {{ cm_mirror }}/archive.key
    - refresh: True
    - file: /etc/apt/sources.list.d/cloudera.list

cloudera-manager-install_cloudera_manager:
  pkg.installed:
    - pkgs:
      - cloudera-manager-daemons
      - cloudera-manager-server

cloudera-manager-create_ext_db:
  cmd.run:
    - name: /usr/share/cmf/schema/scm_prepare_database.sh mysql -h {{ cmdb_host }} -uroot -p{{ mysql_root_password }} --scm-host {{ cm_host }} {{ cmdb_database }} {{ cmdb_user }} {{ cmdb_password }}
    - onlyif: grep 'com.cloudera.cmf.db.setupType=INIT' /etc/cloudera-scm-server/db.properties

cloudera-manager-ensure_cloudera_manager_started:
  service.running:
    - name: cloudera-scm-server
