{% set bind_machine_ip_addr = salt['cmd.run']('curl -s http://169.254.169.254/latest/meta-data/local-ipv4') %}


zookeeper.directory.requirement:
  file.directory:
    - names:
      - /mnt/kafka/zookeeper/data
    - makedirs: True


zookeeper_requirement:
  pkg.installed:
    - pkgs:
      - java-1.8.0-openjdk


install_zookeeper:
  cmd.run:
    - name: wget -O /opt/kafka.tgz https://archive.apache.org/dist/kafka/3.7.0/kafka_2.13-3.7.0.tgz

extract_zookeeper:
  cmd.run:
    - name: tar -xvf /opt/kafka.tgz -C /opt/
    - cwd: /opt
    - creates: /opt/kafka_2.13-3.7.0

zookeeper_properties:
  file.managed:
    - user: root
    - group: root
    - makedirs: True
    - names:
      - /opt/kafka_2.13-3.7.0/config/zookeeper.properties:
        - source: salt://zookeeper/files/zookeeper.properties
        
update_server_properties:
  file.append:
    - name: /opt/kafka_2.13-3.7.0/config/server.properties
    - text:
      - listeners=PLAINTEXT://{{ bind_machine_ip_addr }}:9092
      - advertised.listeners=PLAINTEXT://{{ bind_machine_ip_addr }}:9092


zookeeper_service:
  file.managed:
    - user: root
    - group: root
    - makedirs: True
    - names:
      - /etc/systemd/system/zookeeper.service:
        - source: salt://zookeeper/files/zookeeper.service
 

get_zookeeper_run_sh_file:
  file.managed:
    - user: root
    - group: root
    - makedirs: True
    - names:
      - /tmp/zookeeper-run.sh:
        - source: salt://zookeeper/files/zookeeper-run.sh
 

get_zookeper_ips:
  cmd.run:
    - name: bash zookeeper-run.sh
    - cwd: /tmp
