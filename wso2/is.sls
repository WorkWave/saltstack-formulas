# wso2/is.sls
# Salt formula for WSO2's Identity Server
# To use, download the zip file from wso2 and place it in files.  Update
#   pillar/wso2 with the proper version of IS (to match the filename)

include:
  - wso2.common
  - oracle-java.java7

{% set is_user = salt['pillar.get']('wso2:is:user', 'wso2is') %}
{% set is_group = salt['pillar.get']('wso2:is:group', 'users') %}
{% set is_version = salt['pillar.get']('wso2:is:version', '5.0.0') %}
{% set is_root = salt['pillar.get']('wso2:is:root', '/opt/wso2is-5.0.0') %}

{{ is_user }}:
  user.present:
    - fullname: {{ is_user }}
    - shell: /bin/bash
    - require:
      - archive: wso2is
    - unless:
      - grep {{ is_user }} /etc/passwd

{{ is_group }}:
  group.present:
    - require:
      - user: {{ is_user }}
    - addusers:
      - vagrant
      - {{ is_user }}

wso2is:
  archive:
    - extracted
    - name: /opt/ 
    - source: salt://wso2/files/wso2is-{{ is_version }}.zip
    - archive_format: zip
    - if_missing: {{ is_root }}
    - require:
      - pkg: unzip
      - sls: oracle-java.java7

wso2_dir:
  file.directory:
    - name: {{ is_root }}
    - user: {{ is_user }}
    - group: {{ is_group }}
    - mode: 755
    - recurse:
      - user
      - group
    - require:
      - archive: wso2is
      - user: {{ is_user }}
      - group: {{ is_group }}

wso2-scripts-executable:
  file.managed:
    - name: {{ is_root }}/bin/wso2server.sh
    - mode: 755

/etc/init.d/wso2is:
  file.managed:
    - template: jinja
    - source: salt://wso2/files/wso2-initd-script.jinja
    - mode: 755
    - context:
      java_home: {{ pillar['java']['java_home'] }}
      wso2_user: {{ is_user }}
      wso2_root: {{ is_root }}
      wso2_service: wso2is
    - require:
      - file: wso2_dir

enable-wso2is-at-startup:
  cmd.run:
    - name: update-rc.d wso2is defaults
    - unless: update-rc.d -n wso2is defaults | grep "already exist"
    - require:
      - file: /etc/init.d/wso2is

ensure-wso2is-service-running:
  service.running:
    - name: wso2is
    - require:
      - file: /etc/init.d/wso2is
