# wso2/emm.sls
# Salt formula for WSO2's Enterprise Mobility Manager
# To use, download the zip file from wso2 and place it in files.  Update
#   pillar/wso2 with the proper version of EMM (to match the filename)

include:
  - wso2.common

{% set emm_user = salt['pillar.get']('wso2:emm:user', 'wso2emm') %}
{% set emm_group = salt['pillar.get']('wso2:emm:group', 'users') %}
{% set emm_version = salt['pillar.get']('wso2:emm:version', '4.7.0') %}

{{ emm_user }}:
  user.present:
    - fullname: {{ emm_user }}
    - shell: /bin/bash
    - require:
      - archive: wso2emm
    - unless:
      - grep {{ emm_user }} /etc/passwd

{{ emm_group }}:
  group.present:
    - require:
      - user: {{ emm_user }}
    - addusers:
      - vagrant
      - {{ emm_user }}

wso2emm:
  archive:
    - extracted
    - name: /opt/ 
    - source: salt://wso2/files/wso2emm-{{ emm_version }}.zip
#    - source_hash: md5=8dc1cea6e99ed2ef1a2bb75c92097320
    - archive_format: zip
    - if_missing: /opt/wso2emm-{{ emm_version }}
    - require:
      - pkg: unzip

/opt/wso2emm-{{ emm_version }}:
  file.directory:
    - user: {{ emm_user }}
    - group: {{ emm_group }}
    - mode: 755
    - recurse:
      - user
      - group
    - require:
      - archive: wso2emm
      - user: {{ emm_user }}
      - group: {{ emm_group }}