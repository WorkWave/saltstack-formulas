
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

go-server-installed:
  cmd.run:
    - name: dpkg -i --force-confold {{ go_server_pkg_path }} > t.log 2>& 1
    - unless: dpkg --list go-server | grep {{ go_version }}
    - require:
      - cmd: {{ go_server_pkg_path }}

go-server:
  service:
    - running
    - require:
      - cmd: go-server-installed
