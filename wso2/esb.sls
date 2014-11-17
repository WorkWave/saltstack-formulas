# wso2/esb.sls
# Salt formula for WSO2's Enterprise Service Bus
# To use, download the zip file from wso2 and place it in files.  Update
#   pillar/wso2 with the proper version of ESB (to match the filename)

include:
  - wso2.common

{% set esb_user = salt['pillar.get']('wso2:esb:user', 'wso2esb') %}
{% set esb_group = salt['pillar.get']('wso2:esb:group', 'users') %}
{% set esb_version = salt['pillar.get']('wso2:esb:version', '4.7.0') %}

{{ esb_user }}:
  user.present:
    - fullname: {{ esb_user }}
    - shell: /bin/bash
    - require:
      - archive: wso2esb
    - unless:
      - grep {{ esb_user }} /etc/passwd

{{ esb_group }}:
  group.present:
    - require:
      - user: {{ esb_user }}
    - addusers:
      - vagrant
      - {{ esb_user }}

wso2esb:
  archive:
    - extracted
    - name: /opt/ 
    - source: salt://wso2/files/wso2esb-{{ esb_version }}.zip
#    - source_hash: md5=8dc1cea6e99ed2ef1a2bb75c92097320
    - archive_format: zip
    - if_missing: /opt/wso2esb-{{ esb_version }}
    - require:
      - pkg: unzip

wso2_dir:
  file.directory:
    - name: /opt/wso2esb-{{ esb_version }}
    - user: {{ esb_user }}
    - group: {{ esb_group }}
    - mode: 755
    - recurse:
      - user
      - group
    - require:
      - archive: wso2esb
      - user: {{ esb_user }}
      - group: {{ esb_group }}