prometheus_installation:
  cmd.run:
    - name: wget https://github.com/prometheus/prometheus/releases/download/v2.27.1/prometheus-2.27.1.linux-amd64.tar.gz -O /tmp/prometheus-2.27.1.linux-amd64.tar.gz
    - creates: /tmp/prometheus-2.27.1.linux-amd64.tar.gz

prometheus_user:
  user.present:
    - name: prometheus
    - home: /nonexistent
    - shell: /bin/false
prometheus_etc_dir:
  file.directory:
    - name: /etc/prometheus
    - user: prometheus
    - group: prometheus

prometheus_lib_dir:
  file.directory:
    - name: /var/lib/prometheus
    - user: prometheus
    - group: prometheus

extract_prometheus:
  cmd.run:
    - name: tar -xvzf /tmp/prometheus-2.27.1.linux-amd64.tar.gz -C /tmp
    - user: root
    - cwd: /tmp

move_to_tmp:
  cmd.run:
    - name: mv /tmp/prometheus-2.27.1.linux-amd64 /tmp/prometheus
    - user: root
    - cwd: /tmp

prom_binary_move:
  cmd.run:
    - name: mv /tmp/prometheus/prometheus /usr/local/bin/prometheus
    - user: root  
promtool_binary_move:
  cmd.run:
    - name: mv /tmp/prometheus/promtool /usr/local/bin/promtool
    - user: root 


promconsole_binary_copy:
  cmd.run:
    - name: cp -r /tmp/prometheus/consoles /etc/prometheus
    - user: root

promconsole_library_binary_copy:
  cmd.run:
    - name: cp -r /tmp/prometheus/console_libraries /etc/prometheus
    - user: root

get_prometheus_service_file:
  file.managed:
    - user: root
    - group: root
    - makedirs: True
    - names:
      - /etc/systemd/system/prometheus.service:
        - source: salt://prometheus/files/prometheus.service

copy_prometheus_yml:
  file.managed:
    - user: root
    - group: root
    - makedirs: True
    - names:
      - /etc/prometheus/prometheus.yml:
        - source: salt://prometheus/files/prometheus.yml

copy_prometheus_sh:
  file.managed:
    - user: root
    - group: root
    - makedirs: True
    - names:
      - /tmp/prometheus-run.sh:
        - source: salt://prometheus/files/prometheus-run.sh

run_sh_for_prometheues:
  cmd.run:
    - name: bash prometheus-run.sh
    - user: root
    - cwd: /tmp
