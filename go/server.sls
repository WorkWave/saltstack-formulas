
# Install the Thoughtworks go server
# -----------------------------------------

{% set go_version = '14.2.0-377' %}

{% include 'go/common.sls' %}

{% set go_server_file = "go-server-" + go_version + ".deb" %}
{% set go_server_pkg_path = "/tmp/" + go_server_file %}
{% set go_uri = "http://download.go.cd/gocd-deb/" %}


{{ go_server_pkg_path }}:
  cmd.run:
    - name: wget {{ go_uri + go_server_file }} -O {{ go_server_pkg_path }} -q
    - unless: test -f {{ go_server_pkg_path }}

# Test
/tmp/rundpkg.sh:
  file.managed:
    - contents: |
        #!/bin/bash
        dpkg -i -G -E --force-confold $1
    - user: vagrant 

# --force-unsafe-io
# --ignore-depends
# --skip-same-version
# dpkg -i --force-confold
go-server:
  cmd.run:
#    - name: /home/vagrant/rundpkg.sh {{ go_server_pkg_path }}
    - name: dpkg -i --force-confold {{ go_server_pkg_path }} > t.log 2>& 1
#    - name: echo `dpkg -i --force-confold {{ go_server_pkg_path }}`
    - output_loglevel: debug
    - unless: dpkg --list go-server | grep {{ go_version }}
#    - use_vt: true
#    - timeout: 60

#  pkg.installed:
#    - sources:
#      - go-server: {{ go_uri + go_server_file }}
#    - require:
#      - pkg: unzip
#      - sls: oracle-java.java7
#      - cmd: {{ go_server_pkg_path }}
