# Zabbix server install
# ------------------------------------------------------------------------------

include:
  - zabbix.common

{% set mysql_root_pass = salt['pillar.get']('mysql:server:root_password', salt['grains.get']('server_id')) %}
{% set database = salt['pillar.get']('zabbix:db:database', 'zabbix') %}


# Password in /etc/zabbix/zabbix_server.conf was not set properly
# DBPassword=zabbix
# runs through the config / setup script -- automate that.
php-set-timezone:
  file.replace:
    - name: /etc/php5/apache2/php.ini
    - pattern: '^;date.timezone ='
    - repl: date.timezone = "America/New_York"
    - unless: grep '^date.timezone' /etc/php5/apache2/php.ini
    - requires:
      - pkg: zabbix-server-mysql

zabbix-server-mysql:
  pkg.installed:
    - pkgs:
      - zabbix-server-mysql
      - php5-mysql
      - zabbix-frontend-php
    - require:
      - pkgrepo: zabbix-repo

zabbix-server:
  service:
    - running
    - require:
      - pkg: zabbix-server-mysql

zabbix-schema-init:
    cmd.run:
    - name: mysql -u root -p{{ mysql_root_pass }} {{ database }} <  /usr/share/zabbix-server-mysql/schema.sql
    - unless: mysql -u root -p{{ mysql_root_pass }} {{ database }} -e 'show tables' | grep 'Tables_in'
    - require:
      - pkg: zabbix-server-mysql

zabbix-images-init:
    cmd.run:
    - name: mysql -u root -p{{ mysql_root_pass }} {{ database }} <  /usr/share/zabbix-server-mysql/images.sql
    - onlyif: mysql -u root -p{{ mysql_root_pass }} {{ database }} -e 'select count(*) from images' | grep '^0$'
    - require:
      - pkg: zabbix-server-mysql

zabbix-data-init:
    cmd.run:
    - name: mysql -u root -p{{ mysql_root_pass }} {{ database }} <  /usr/share/zabbix-server-mysql/data.sql
    - onlyif: mysql -u root -p{{ mysql_root_pass }} {{ database }} -e 'select count(*) from hosts' | grep '^0$'
    - require:
      - pkg: zabbix-server-mysql

/usr/lib/zabbix/alertscripts/zabbix-alert-gmail-smtp.py3:
  file.managed:
    - source: salt://zabbix/files/zabbix-alert-gmail-smtp.py3
    - mode: 700 
    - require:
      - pkg: zabbix-server-mysql

/etc/zabbix/zabbix_server.conf:
  file.replace:
    - name: /etc/hosts
    - pattern: '^DBPassword=.*'
    - repl: DBPassword=zabbixpass

