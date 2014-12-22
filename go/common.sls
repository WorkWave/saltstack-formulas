# Common settings and states for the Thoughtworks go tool
# -----------------------------------------------------------

{% set go_version = '14.2.0-377' %}
{% set go_uri = 'http://download.go.cd/gocd-deb/' %}

unzip:
  pkg:
    - installed
