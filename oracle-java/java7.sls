# Install the sun / Oracle JDK from the WEB UPD8 team repo
# Ubuntu tested only.
# --------------------------------------------------

include:
  - oracle-java.common

# Automatically accept the oracle license
Accept Oracle7 Terms:
  debconf.set:
    - name: oracle-java7-installer 
    - data: 
        'shared/accepted-oracle-license-v1-1': {'type': 'boolean', 'value': True }

# Set JAVA_HOME.
/etc/profile.d/set-java-home.sh:
  file.managed:
    - template: jinja
    - source: salt://oracle-java/files/set-java-home.sh
    - context:
      java_home: {{ pillar['oracle-java']['java_home'] }}

# Run the installer itself
oracle-java7-installer:
  pkg:
    - installed
    - require:
      - pkgrepo: webupd8-repo
      - debconf: Accept Oracle7 Terms

