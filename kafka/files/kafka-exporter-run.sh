#/bin/bash
export BIND_MACHINE_IP_ADDR=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
export BROKERNAME=$BIND_MACHINE_IP_ADDR:9092  
envsubst < /etc/kafka-exporter/exporter.yml > tmp.txt && mv tmp.txt /etc/kafka-exporter/exporter.yml --force && rm -rf tmp.txt
