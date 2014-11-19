# Install the sun / Oracle JDK from the WEB UPD8 team repo
# Ubuntu tested only.
# --------------------------------------------------

{% set java_home = salt['pillar.get']('oracle-java:java_home', '/usr/lib/jvm/java-6-oracle') %}

include:
  - oracle-java.common

# Automatically accept the oracle license
Accept Oracle6 Terms:
  debconf.set:
    - name: oracle-java6-installer 
    - data: 
        'shared/accepted-oracle-license-v1-1': {'type': 'boolean', 'value': True }

# Set JAVA_HOME.
/etc/profile.d/set-java-home.sh:
  file.managed:
    - template: jinja
    - source: salt://oracle-java/files/set-java-home.sh
    - context:
      java_home: {{ pillar['oracle-java']['java_home'] }}

# Include US security files.
{{ pillar['java']['java_home'] }}/jre/lib/security/local_policy.jar:
  file.managed:
   - require:
     - pkg: oracle-java6-installer
   - source: salt://oracle-java/files/local_policy.jar

{{ pillar['java']['java_home'] }}/jre/lib/security/US_export_policy.jar:
  file.managed:
   - require:
     - pkg: oracle-java6-installer
   - source: salt://oracle-java/files/US_export_policy.jar

# Run the installer itself
oracle-java6-installer:
  pkg:
    - installed
    - require:
      - pkgrepo: webupd8-repo
      - debconf: Accept Oracle6 Terms

