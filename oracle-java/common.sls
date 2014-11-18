# Shared states for installing Oracle JDK's from WEB UPD8
# Ubuntu tested only.
# --------------------------------------------------

# Configure apt to use the WEB UPD8 repo
webupd8-repo:
  pkgrepo.managed:
    - humanname: WEB UPD8 Repository
    - name: deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main
    - gpgcheck: 1
    - keyid: EEA14886
    - keyserver: keyserver.ubuntu.com
    - enabled: 1

# Set JAVA_HOME.
/etc/profile.d/set-java-home.sh:
  file.managed:
    - template: jinja
    - source: salt://oracle-java/files/set-java-home.sh
    - context:
      java_home: {{ pillar['java']['java_home'] }}
