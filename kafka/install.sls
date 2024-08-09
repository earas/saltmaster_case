{% set bind_machine_ip_addr = salt['cmd.run']('curl -s http://169.254.169.254/latest/meta-data/local-ipv4') %}

kafka.directory.requirement:
  file.directory:
    - names:
      - /mnt/kafka/zookeeper
      - /mnt/kafka/kafka-logs
    - makedirs: True


kafka_requirement:
  pkg.installed:
    - pkgs:
      - java-1.8.0-openjdk


install_kafka:
  cmd.run:
    - name: wget -O /opt/kafka.tgz https://archive.apache.org/dist/kafka/3.7.0/kafka_2.13-3.7.0.tgz

extract_kafka:
  cmd.run:
    - name: tar -xvf /opt/kafka.tgz -C /opt/
    - cwd: /opt
    - creates: /opt/kafka_2.13-3.7.0
    
kafka_properties:
  file.managed:
    - user: root
    - group: root
    - makedirs: True
    - names:
      - /opt/kafka_2.13-3.7.0/config/server.properties:
        - source: salt://kafka/files/server.properties
        
update_server_properties:
  file.append:
    - name: /opt/kafka_2.13-3.7.0/config/server.properties
    - text:
      - listeners=PLAINTEXT://{{ bind_machine_ip_addr }}:9092
      - advertised.listeners=PLAINTEXT://{{ bind_machine_ip_addr }}:9092

kafka_service:
  file.managed:
    - user: root
    - group: root
    - makedirs: True
    - names:
      - /etc/systemd/system/kafka.service:
        - source: salt://kafka/files/kafka.service 

get_kafka_run_sh_file:
  file.managed:
    - user: root
    - group: root
    - makedirs: True
    - names:
      - /tmp/kafka-run.sh:
        - source: salt://kafka/files/kafka-run.sh
 

get_kafka_ips:
  cmd.run:
    - name: bash kafka-run.sh
    - cwd: /tmp
