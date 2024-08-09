#/bin/bash
export INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
export REGION=$(curl http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)
export NAME=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" --region $REGION --query "Tags[?Key=='Name'].Value" --output text)
export CLUSTER_NAME=$(echo $NAME | cut -d '-' -f 2-4)
export CLUSTER_NAME_COUNT=$(echo $NAME | cut -d '-' -f 4)
if [ "$CLUSTER_NAME" == "passive-kafka-0" ]; then
  echo -e "bootstrap.servers="$(aws ec2 describe-instances --filters "Name=tag:Name,Values=ARAS-active-kafka-*" --query 'Reservations[*].Instances[*].[PrivateIpAddress, Tags[?Key==`Name`].Value]' | jq -r '.[][] | "\(.[1][0]) \(.[0])"' | sort | grep -v null | awk '{print $2":9092"}'  | paste -sd, -) >> /opt/kafka_2.13-3.7.0/config/source-cluster-consumer.properties

  echo -e "bootstrap.servers="$(aws ec2 describe-instances --filters "Name=tag:Name,Values=ARAS-passive-kafka-*" --query 'Reservations[*].Instances[*].[PrivateIpAddress, Tags[?Key==`Name`].Value]' | jq -r '.[][] | "\(.[1][0]) \(.[0])"' | sort | grep -v null | awk '{print $2":9092"}'  | paste -sd, -) >> /opt/kafka_2.13-3.7.0/config/target-cluster-producer.properties

  /opt/kafka_2.13-3.7.0/bin/kafka-mirror-maker.sh --consumer.config /opt/kafka_2.13-3.7.0/config/source-cluster-consumer.properties --producer.config /opt/kafka_2.13-3.7.0/config/target-cluster-producer.properties --whitelist=".*"

fi