# Zabbix Agent
# -------------------------------------------------------------

{% include 'zabbix/common.sls' %}

zabbix-agent:
  pkg.installed:
    - require:
      - pkgrepo: zabbix-repo
    - service:
      - running