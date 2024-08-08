
tengine.directory.requirement:
  file.directory:
    - names:
      - /tmp/tengine
    - makedirs: True

copy_build_tengine_sh:
  file.managed:
    - name: /tmp/tengine/build_tengine.sh
    - source: salt://nginx/files/build_tengine.sh

copy_build_tengine_rpm:
  file.managed:
    - name: /tmp/tengine/tengine-2.3.3-2.el7.ngx.x86_64.rpm
    - source: salt://nginx/files/tengine-2.3.3-2.el7.ngx.x86_64.rpm

copy_build_tengine_spec:
  file.managed:
    - name: /tmp/tengine/tengine.spec
    - source: salt://nginx/files/tengine.spec


install_tengine_package:
  pkg.installed:
    - sources:
        - tengine: /tmp/tengine/tengine-2.3.3-2.el7.ngx.x86_64.rpm



replace_nginx_conf:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://nginx/files/nginx.conf
    - require:
      - pkg: install_tengine_package

manage_ports:
  cmd.run:
    - name: |
        semanage port -a -t http_port_t -p tcp 8404
        semanage port -a -t http_port_t -p tcp 8405
    - require:
      - pkg: install_tengine_package

