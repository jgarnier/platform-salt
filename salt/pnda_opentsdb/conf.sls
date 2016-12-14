{% set pnda_dir = pillar['pnda']['homedir'] %}

include:
  - opentsdb
  - cm-api-helpers

pnda_opentsdb-pnda-opentsdb-configuration:
  cmd.run:
    - name: sed -i "s/.*tsd.storage.hbase.zk_quorum =.*/tsd.storage.hbase.zk_quorum = $(python {{ pnda_dir }}/cm-api-helpers/zk.py)/g" /etc/opentsdb/opentsdb.conf   

pnda_opentsdb-pnda-opentsdb-configuration-lastvalue:
  file.replace:
    - name: /etc/opentsdb/opentsdb.conf
    - append_if_not_found: True
    - pattern: '.*tsd.core.meta.enable_realtime_ts =.*'
    - repl: 'tsd.core.meta.enable_realtime_ts = true'

pnda_opentsdb-pnda-opentsdb-configuration-cors:
  file.replace:
    - name: /etc/opentsdb/opentsdb.conf
    - append_if_not_found: True
    - pattern: '.*tsd.http.request.cors_domains =.*'
    - repl: 'tsd.http.request.cors_domains = *'
    
pnda_opentsdb-update-opentsdb-default-file:
  file.managed:
    - name: /etc/default/opentsdb
    - contents: JAVA_HOME=/usr/lib/jvm/java-8-oracle
