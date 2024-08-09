#/bin/bash
export INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
export REGION=$(curl http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)
export NAME=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" --region $REGION --query "Tags[?Key=='Name'].Value" --output text)
export CLUSTER_NAME=$(echo $NAME | cut -d '-' -f 2)
export CLUSTER_NAME_COUNT=$(echo $NAME | cut -d '-' -f 4)
echo  -e "zookeeper.connect="$(aws ec2 describe-instances --filters "Name=tag:Name,Values=Aras-$CLUSTER_NAME-zookeeper-*" --query 'Reservations[*].Instances[*].[PrivateIpAddress, Tags[?Key==`Name`].Value]' | jq -r '.[][] | "\(.[1][0]) \(.[0])"' | sort | grep -v null | awk '{print $2":2181"}'  | paste -sd, -) >> /opt/kafka_2.13-3.7.0/config/server.properties
echo "broker.id=$CLUSTER_NAME_COUNT" >>  /opt/kafka_2.13-3.7.0/config/server.properties