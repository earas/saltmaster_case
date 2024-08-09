kafka_exporter.directory.requirement:
  file.directory:
    - names:
      - /etc/kafka-exporter
    - makedirs: True

get_kafka_kminion_file:
  file.managed:
    - user: root
    - group: root
    - makedirs: True
    - mode: 777
    - names:
      - /etc/kafka-exporter/kminion:
        - source: salt://kafka/files/kminion
        
get_kafka_exporter_file:
  file.managed:
    - user: root
    - group: root
    - makedirs: True
    - names:
      - /etc/kafka-exporter/exporter.yml:
        - source: salt://kafka/files/exporter.yml

get_kafka_exporter_service_file:
  file.managed:
    - user: root
    - group: root
    - makedirs: True
    - names:
      - /etc/systemd/system/kafka-exporter.service:
        - source: salt://kafka/files/kafka-exporter.service

copy_kafka_exporter_run_sh:
  file.managed:
    - user: root
    - group: root
    - makedirs: True
    - names:
      - /tmp/kafka-exporter-run.sh:
        - source: salt://kafka/files/kafka-exporter-run.sh

run_kafka_exporter_run_sh:
  cmd.run:
    - name: bash kafka-exporter-run.sh
    - cwd: /tmp/

kafka-exporter.service:
  service.running:
    - enable: True
