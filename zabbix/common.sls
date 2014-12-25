# Zabbix common.sls -- shared Zabbix config info and states
# ----------------------------------------------------------

# Configure apt to use the Zabbix repo
zabbix-repo:
  pkgrepo.managed:
    - humanname: Zabbix Repository
    - name: deb http://repo.zabbix.com/zabbix/2.4/ubuntu/ trusty main
    - gpgcheck: 1
    - keyid: D13D58E479EA5ED4
    - keyserver: keyserver.ubuntu.com
    - enabled: 1
