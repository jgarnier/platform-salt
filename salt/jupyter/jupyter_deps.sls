{% set pip_extra_index_url = salt['pillar.get']('pip:extra_index_url', '') %}

jupyter-install_anaconda_deps:
  cmd.run:
    - name: export PATH=/opt/cloudera/parcels/Anaconda/bin:$PATH; pip install {% if pip_extra_index_url != '' -%}--extra-index-url {{ pip_extra_index_url }}{% endif %} cm_api avro

jupyter-install_anaconda_ipywidgets:
  cmd.run:
    - name: export PATH=/opt/cloudera/parcels/Anaconda/bin:$PATH; conda install -c conda-forge ipywidgets

