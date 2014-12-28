# wso2/as.sls
# Salt formula for WSO2's Application Server
# To use, download the zip file from wso2 and place it in files.  Update
#   pillar/wso2 with the proper version of AS (to match the filename)

include:
  - wso2.common
  - oracle-java.java6

{% set as_user = salt['pillar.get']('wso2:as:user', 'vagrant') %}
{% set as_group = salt['pillar.get']('wso2:as:group', 'wso2') %}
{% set as_version = salt['pillar.get']('wso2:as:version', '5.2.1') %}
{% set wso2_root = salt['pillar.get']('wso2:as:root', '/opt/wso2as-5.2.1') %}

as-user-{{ as_user }}:
  user.present:
    - name: {{ as_user }}
    - fullname: {{ as_user }}
    - shell: /bin/bash
    - require:
      - archive: wso2as
    - unless:
      - grep {{ as_user }} /etc/passwd

as-group-{{ as_group }}:
  group.present:
    - name: {{ as_user }}
    - require:
      - user: as-user-{{ as_user }}
    - addusers:
      - vagrant
      - {{ as_user }}

wso2as:
  archive:
    - extracted
    - name: /opt/ 
    - source: salt://wso2/files/wso2as-{{ as_version }}.zip
#    - source_hash: md5=8dc1cea6e99ed2ef1a2bb75c92097320
    - archive_format: zip
    - if_missing: {{ wso2_root }}
    - require:
      - pkg: unzip
      - sls: oracle-java.java6

{{ wso2_root }}:
  file.directory:
    - name: {{ wso2_root }}
    - user: {{ as_user }}
    - group: {{ as_group }}
    - mode: 755
    - recurse:
      - user
      - group
      - mode
#    - unless: test -d {{ wso2_root }}
    - require:
      - archive: wso2as
      - user: as-user-{{ as_user }}
      - group: as-group-{{ as_group }}


/etc/init.d/wso2as:
  file.managed:
    - template: jinja
    - source: salt://wso2/files/wso2-as.sh.jinja
    - mode: 755
    - context:
      java_home: {{ pillar['java']['java_home'] }}
      wso2_user: {{ as_user }}
      wso2_root: {{ wso2_root }}

enable-wso2as-at-startup:
  cmd.run:
    - name: update-rc.d wso2as defaults
    - unless: update-rc.d -n wso2as defaults | grep "already exist"

ensure-wso2as-service-running:
  service.running:
    - name: wso2as
