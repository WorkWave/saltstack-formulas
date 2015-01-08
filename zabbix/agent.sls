# Zabbix Agent
# -------------------------------------------------------------

include:
  - zabbix.common

zabbix-agent:
  pkg.installed:
    - require:
      - pkgrepo: zabbix-repo
    - service:
      - running