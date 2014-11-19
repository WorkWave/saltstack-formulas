# Install the sun / Oracle JDK8 from the WEB UPD8 team repo
# Ubuntu tested only.
# --------------------------------------------------

{% set java_home = salt['pillar.get']('oracle-java:java_home', '/usr/lib/jvm/java-8-oracle') %}

include:
  - oracle-java.common

# Automatically accept the oracle license
Accept Oracle7 Terms:
  debconf.set:
    - name: oracle-java8-installer 
    - data: 
        'shared/accepted-oracle-license-v1-1': {'type': 'boolean', 'value': True }

# Run the installer itself
oracle-java8-installer:
  pkg:
    - installed
    - require:
      - pkgrepo: webupd8-repo
      - debconf: Accept Oracle8 Terms

