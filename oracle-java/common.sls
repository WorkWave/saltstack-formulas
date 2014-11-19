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

# Set JAVA_HOME.  The SLS java_home attribute is set in javaX.sls.  Each version
# has an appropriate default value that can be over-ridden in pillar.
# Note that the currently running environment will NOT have JAVA_HOME set, rather
# it will be set on next login for every user.  Applications such as tomcat have
# their own way of setting JAVA_HOME and should be dealt with as part of their
# specific setup.
/etc/profile.d/set-java-home.sh:
  file.managed:
    - template: jinja
    - source: salt://oracle-java/files/set-java-home.sh
    - context:
      java_home: {{ java_home }}
