# wso2/esb.sls
# Salt formula for WSO2's Enterprise Service Bus
# To use, download the zip file from wso2 and place it in files.  Update
#   pillar/wso2 with the proper version of ESB (to match the filename)

include:
  - wso2.common
  - oracle-java.java6

{% set esb_user = salt['pillar.get']('wso2:esb:user', 'wso2esb') %}
{% set esb_group = salt['pillar.get']('wso2:esb:group', 'users') %}
{% set esb_version = salt['pillar.get']('wso2:esb:version', '4.7.0') %}
{% set esb_root = salt['pillar.get']('wso2:esb:root', '/opt/wso2esb-4.7.0') %}

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
    - archive_format: zip
    - if_missing: {{ esb_root }}
    - require:
      - pkg: unzip
      - sls: oracle-java.java6

wso2_dir:
  file.directory:
    - name: {{ esb_root }}
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

wso2-scripts-executable:
  file.managed:
    - name: {{ esb_root }}/bin/wso2server.sh
    - mode: 755

/etc/init.d/wso2esb:
  file.managed:
    - template: jinja
    - source: salt://wso2/files/wso2-initd-script.jinja
    - mode: 755
    - context:
      java_home: {{ pillar['java']['java_home'] }}
      wso2_user: {{ esb_user }}
      wso2_root: {{ esb_root }}
      wso2_service: wso2esb
    - require:
      - file: wso2_dir

enable-wso2as-at-startup:
  cmd.run:
    - name: update-rc.d wso2esb defaults
    - unless: update-rc.d -n wso2esb defaults | grep "already exist"
    - require:
      - file: /etc/init.d/wso2esb

ensure-wso2as-service-running:
  service.running:
    - name: wso2esb
    - require:
      - file: /etc/init.d/wso2esb
