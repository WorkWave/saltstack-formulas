# Zabbix Agent
# -------------------------------------------------------------

{% from "zabbix/map.jinja" import zabbix with context %}

include:
  - zabbix.common

zabbix-agent:
  pkg.installed:
    - require:
      - pkgrepo: zabbix-repo
    - service:
      - running