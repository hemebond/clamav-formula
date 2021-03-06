# -*- coding: utf-8 -*-
# vim: ft=sls

{%- from "clamav/map.jinja" import clamav with context %}

{%- if salt['grains.get']('os') == 'Debian' and salt['grains.get']('init') == 'systemd' %}
clamav-daemon-service-config:
  file.managed:
    - name: /etc/systemd/system/clamav-daemon.socket.d/extend.conf
    - source: salt://clamav/files/extend.conf
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - context:
        settings: {{ clamav.daemon.get('systemd', {})|json }}
    - watch_in:
        service: clamav-daemon
{%- endif %}


clamav-daemon-clamd-config:
  file.managed:
    - name: /etc/clamav/clamd.conf
    - mode: 644
    - user: root
    - group: root
    - contents: |
        {%- for setting, value in clamav.daemon.settings.items() %}
        {{ setting }} {{ value }}
        {%- endfor %}
    - watch_in:
        service: clamav-daemon
