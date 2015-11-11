# Install the sun / Oracle JDK from the WEB UPD8 team repo
# Ubuntu tested only.
# --------------------------------------------------

{% set java_version = '6' %}

{% include 'oracle-java/common.sls' %}

# Automatically accept the oracle license
Accept Oracle6 Terms:
  debconf.set:
    - name: oracle-java6-installer
    - data:
        'shared/accepted-oracle-license-v1-1': {'type': 'boolean', 'value': True }

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
