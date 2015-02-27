# Zabbix server install
# ------------------------------------------------------------------------------

{% from "zabbix/map.jinja" import zabbix with context %}

include:
  - mysql
  - zabbix.common

{% set mysql_root_pass = salt['pillar.get']('mysql:server:root_password', salt['grains.get']('server_id')) %}

php-set-timezone:
  file.replace:
    - name: /etc/php5/apache2/php.ini
    - pattern: '^;date.timezone ='
    - repl: date.timezone = "America/New_York"
    - unless: grep '^date.timezone' /etc/php5/apache2/php.ini
    - require:
      - pkg: zabbix-server-mysql

zabbix-server-mysql:
  pkg.installed:
    - pkgs:
      - zabbix-server-mysql
      - php5-mysql
      - zabbix-frontend-php
    - require:
      - pkgrepo: zabbix-repo

zabbix-schema-init:
    cmd.run:
    - name: mysql -u root -p{{ mysql_root_pass }} {{ zabbix.database }} <  /usr/share/zabbix-server-mysql/schema.sql
    - unless: mysql -u root -p{{ mysql_root_pass }} {{ zabbix.database }} -e 'show tables' | grep 'Tables_in'
    - require:
      - pkg: zabbix-server-mysql

zabbix-images-init:
    cmd.run:
    - name: mysql -u root -p{{ mysql_root_pass }} {{ zabbix.database }} <  /usr/share/zabbix-server-mysql/images.sql
    - onlyif: mysql -u root -p{{ mysql_root_pass }} {{ zabbix.database }} -e 'select count(*) from images' | grep '^0$'
    - require:
      - pkg: zabbix-server-mysql

zabbix-data-init:
    cmd.run:
    - name: mysql -u root -p{{ mysql_root_pass }} {{ zabbix.database }} <  /usr/share/zabbix-server-mysql/data.sql
    - onlyif: mysql -u root -p{{ mysql_root_pass }} {{ zabbix.database }} -e 'select count(*) from hosts' | grep '^0$'
    - require:
      - pkg: zabbix-server-mysql

/usr/lib/zabbix/alertscripts/zabbix-alert-gmail-smtp.py3:
  file.managed:
    - source: salt://zabbix/files/zabbix-alert-gmail-smtp.py3
    - mode: 755
    - context:
      gmail_account: {{ zabbix.database_host }}
      gmail_password: {{ zabbix.database }}
      sender_name: {{ zabbix.sender_name }}
    - require:
      - pkg: zabbix-server-mysql

/etc/zabbix/zabbix_server.conf:
  file.managed:
    - template: jinja
    - source: salt://zabbix/files/zabbix_server.conf.jinja
    - mode: 644
    - context:
      zabbix_database_host: {{ zabbix.database_host }}
      zabbix_database: {{ zabbix.database }}
      zabbix_database_user: {{ zabbix.database_user }}
      zabbix_database_password: {{ zabbix.database_password }}
      zabbix_server_host: {{ zabbix.server_host }}
      zabbix_server_name: {{ zabbix.server_name }}

apache2-service:
  service.running:
    - name: apache2
    - enable: True
    - require:
      - pkg: zabbix-server-mysql
    - watch:
      - file: /etc/php5/apache2/php.ini

/etc/zabbix/web/zabbix.conf.php:
  file.managed:
    - require:
      - service: zabbix-server
    - template: jinja
    - source: salt://zabbix/files/zabbix.conf.php.jinja
    - mode: 755
    - context:
      zabbix_database_host: {{ zabbix.database_host }}
      zabbix_database: {{ zabbix.database }}
      zabbix_database_user: {{ zabbix.database_user }}
      zabbix_database_password: {{ zabbix.database_password }}
      zabbix_server_host: {{ zabbix.server_host }}
      zabbix_server_name: {{ zabbix.server_name }}

# This state needs to be last.  
# We want the server to restart after changing zabbix_server.conf.  Salt *should* 
# figure this out via the requisite system, but if we have this state before 
# file:zabbix.conf.php, the service does not get restarted after the file is 
# updated via the salt state above.  Seems to be salt bug #14183
#   https://github.com/saltstack/salt/issues/14183

zabbix-server:
  service.running:
    - enable: True
    - watch:
      - file: /etc/zabbix/zabbix_server.conf
    - require:
      - pkg: zabbix-server-mysql
      - file: /etc/zabbix/zabbix_server.conf
