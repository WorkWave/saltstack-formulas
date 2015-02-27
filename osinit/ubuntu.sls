# Need to sort this by OS, but for now ubuntu cleanup stuff is here.

# Set timezone to Eastern and hardware clock to UTC
America/New_York:
  timezone.system:
    - utc: true

{% if grains['os'] == 'Ubuntu' %}

chef:
  pkg.purged

chef-zero:
  pkg.purged

puppet:
  pkg.purged

landscape-client:
  pkg.purged

landscape-common:
  pkg.purged

/etc/update-motd.d/51-cloudguest:
  file.absent

/etc/update-motd.d/98-cloudguest:
  file.absent

/etc/update-motd.d/10-help-text:
  file.absent
  
{% endif %}
