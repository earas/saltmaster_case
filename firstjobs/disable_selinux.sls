disable_selinux_file:
  file.managed:
    - name: /etc/selinux/config
    - source: salt://firstjobs/files/selinux_config
    - user: root
    - group: root
    - mode: 644
disable_selinux:
  cmd.run:
    - name: setenforce 0
    - unless: "getenforce | grep -i 'Disabled'"