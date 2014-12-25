
# Install the Thoughtworks go server
# -----------------------------------------

# Bug: startup script nohups and hangs salt when trying to start the service,
# both on asserting service:running and on install (which starts the service).
# Workaround for install is to redir stdout and stderr, which circumvents the
# nohop.

{% set go_version = '14.2.0-377' %}

{% include 'go/common.sls' %}

{% set go_server_file = "go-server-" + go_version + ".deb" %}
{% set go_server_pkg_path = "/tmp/" + go_server_file %}
{% set go_uri = "http://download.go.cd/gocd-deb/" %}


{{ go_server_pkg_path }}:
  cmd.run:
    - name: wget {{ go_uri + go_server_file }} -O {{ go_server_pkg_path }} -q
    - unless: test -f {{ go_server_pkg_path }}

# redirect dpkg stdout and stderr to workaround hang of salt
go-server-installed:
  cmd.run:
    - name: dpkg -i --force-confold {{ go_server_pkg_path }} > t.log 2>& 1
    - unless: dpkg --list go-server | grep {{ go_version }}
    - require:
      - cmd: {{ go_server_pkg_path }}

# This hangs salt if service is not running due to service nohup
go-server:
  service:
    - running
    - require:
      - cmd: go-server-installed
