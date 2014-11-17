# Install the sun / Oracle JDK from the WEB UPD8 team repo
# Ubuntu tested only.
# --------------------------------------------------

# If this state is not executed, the downloaded installer will prompt interactively
# for confirmation that the license is agreed to.  To install automatically,
# the pkg installer requires this state.

#Accept Oracle Terms:
#  cmd.run:
#    - name: echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections

Accept Oracle Terms:
  debconf.set:
    - name: oracle-java6-installer 
    - data: 
        'shared/accepted-oracle-license-v1-1': {'type': 'boolean', 'value': True }

# Configure apt to use the WEB UPD8 repo
webupd8-repo:
  pkgrepo.managed:
    - humanname: WEB UPD8 Repository
    - name: deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main
    - gpgcheck: 1
    - keyid: EEA14886
    - keyserver: keyserver.ubuntu.com
    - enabled: 1

/etc/profile.d/set-java-home.sh:
  file.managed:
    - template: jinja
    - source: salt://oracle-java/files/set-java-home.sh
    - context:
      java_home: {{ pillar['java']['java_home'] }}

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

oracle-java6-installer:
  pkg:
    - installed
    - require:
      - pkgrepo: webupd8-repo
      - debconf: Accept Oracle Terms

