# Install the sun / Oracle JDK from the WEB UPD8 team repo
# Ubuntu tested only.
# --------------------------------------------------

{% set java_version = '7' %}

{% include 'oracle-java/common.sls' %}

# Automatically accept the oracle license
Accept Oracle7 Terms:
  debconf.set:
    - name: oracle-java7-installer 
    - data: 
        'shared/accepted-oracle-license-v1-1': {'type': 'boolean', 'value': True }

# Run the installer itself
oracle-java7-installer:
  pkg:
    - installed
    - require:
      - pkgrepo: webupd8-repo
      - debconf: Accept Oracle7 Terms

