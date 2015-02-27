# tomcat/init.sls

authbind:
  pkg.installed

# Install tomcat7, and be sure to restart it if server.xml or defaults change
tomcat7:
  pkg:
    - installed
  service:
    - running
    - watch:
      - file: /etc/tomcat7/server.xml
      - file: /etc/default/tomcat7

tomcat-on-port-80:
  file.replace:
    - name: /etc/tomcat7/server.xml
    - pattern: 'Connector port="8080"'
    - repl: 'Connector port="80"'
    - requires:
      - pkg: tomcat7

tomcat-enable-authbind:
  file.replace:
    - name: /etc/default/tomcat7
    - pattern: '^#AUTHBIND=no'
    - repl: AUTHBIND=yes
    - requires:
      - pkg: tomcat7

tomcat-prefer-ipv4:
  file.append:
    - name: /etc/default/tomcat7
    - text: JAVA_OPTS="${JAVA_OPTS} -Djava.net.preferIPv4Stack=true"
    - unless: grep java.net.preferIPv4Stack=true /etc/default/tomcat7
    - requires:
      - pkg: tomcat7

# Configure tomcat to listen on port 80
authbind-enable-port-80:
  file.managed:
      - name: /etc/authbind/byport/80
      - mode: 0500
      - user: tomcat7
      - group: tomcat7
      - requires:
        - pkg: tomcat7
        - pkg: authbind

