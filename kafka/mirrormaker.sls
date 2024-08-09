get_kafka_mirror_maker_target_file:
  file.managed:
    - user: root
    - group: root
    - makedirs: True
    - names:
      - /opt/kafka_2.13-3.7.0/config/source-cluster-consumer.properties:
        - source: salt://kafka/files/source-cluster-consumer.properties       

get_kafka_mirror_maker_source_file:
  file.managed:
    - user: root
    - group: root
    - makedirs: True
    - names:
      - /opt/kafka_2.13-3.7.0/config/target-cluster-producer.properties:
        - source: salt://kafka/files/target-cluster-producer.properties 

get_kafka_mirror_maker_sh_file:
  file.managed:
    - user: root
    - group: root
    - makedirs: True
    - names:
      - /tmp/mirror-maker.sh:
        - source: salt://kafka/files/mirror-maker.sh
 

run_mirror_maker:
  cmd.run:
    - name: bash mirror-maker.sh
    - cwd: /tmp
