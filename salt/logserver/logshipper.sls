{% set packages_server = pillar['packages_server']['base_uri'] %}
{% set logstash_version = salt['pillar.get']('logstash:release_version', '1.5.4') %}
{% set logstash_package = 'logstash-' + logstash_version + '.tar.gz' %}
{% set install_dir = pillar['pnda']['homedir'] %}
{% set extra_mirror = salt['pillar.get']('extra:mirror', 'https://artifacts.elastic.co/downloads/logstash/') %}
{% set logstash_url = extra_mirror +  'logstash-' +  logstash_version + '.tar.gz' %}

include:
  - java

logshipper-lbc6:
  pkg.installed:
    - pkgs:
      - libc6-dev
      - acl

logshipper-dl-and-extract:
  archive.extracted:
    - name: {{ install_dir }}
    - source: {{ logstash_url }}
    - source_hash: {{ logstash_url }}.sha1.txt
    - archive_format: tar
    - tar_options: v
    - if_missing: {{ install_dir }}/logstash-1.5.4


logshipper-link_release:
  cmd.run:
    - name: ln -f -s {{ install_dir }}/logstash-{{ logstash_version }} {{ install_dir }}/logstash
    - cwd: {{ install_dir }}
    - unless: test -L {{ install_dir }}/logstash

logshipper-copy_configuration:
  file.managed:
    - name: {{ install_dir }}/logstash/shipper.conf
    - source: salt://logserver/logshipper_templates/shipper.conf.tpl
    - template: jinja
    - defaults:
        install_dir: {{ install_dir }}

yarn:
  group.present
kafka:
  group.present

logger:
  user.present:
    - groups:
      - yarn
      - root
      - kafka

logshipper-add_salt_permissions:
  cmd.run:
    - name: 'chmod -R 755 /var/log/salt'

logshipper-copy_permission_script:
  file.managed:
    - name: {{ install_dir }}/logstash/open_yarn_log_permissions.sh
    - source: salt://logserver/logshipper_files/open_yarn_log_permissions.sh
    - mode: 755

logshipper-yarnperms-add_crontab_entry:
  cron.present:
    - identifier: YARN-PERMISSIONS
    - name: {{ install_dir }}/logstash/open_yarn_log_permissions.sh
    - user: root
    - minute: '*'

logshipper-create_sincedb_folder:
  file.directory:
    - name: {{ install_dir }}/logstash/sincedb
    - user: root
    - group: syslog
    - mode: 777
    - makedirs: True

logshipper-copy_upstart:
  file.managed:
    - name: /etc/init/logshipper.conf
    - source: salt://logserver/logshipper_templates/logstash.conf.tpl
    - template: jinja
    - defaults:
        install_dir: {{ install_dir }}

logshipper-stop_service:
  cmd.run:
    - name: 'initctl stop logshipper || echo logshipper already stopped'
    - user: root
    - group: root

logshipper-start_service:
  cmd.run:
    - name: 'initctl start logshipper'
    - user: root
    - group: root
