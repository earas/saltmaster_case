#/bin/bash
export INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
export REGION=$(curl http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)
export NAME=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" --region $REGION --query "Tags[?Key=='Name'].Value" --output text)
export CLUSTER_NAME=$(echo $NAME | cut -d '-' -f 1-3)
export CLUSTER_NAME_COUNT=$(echo $NAME | cut -d '-' -f 4)
counter=0;  aws ec2 describe-instances --filters "Name=tag:Name,Values=$CLUSTER_NAME-*" --query 'Reservations[*].Instances[*].[PrivateIpAddress, Tags[?Key==`Name`].Value]' | jq -r '.[][] | "\(.[1][0]) \(.[0])"' | sort | awk '{print $2}' | grep -v null | while read -r line; do  echo "server.$counter=$line:2888:3888" ;     ((counter++)); done >> /opt/kafka_2.13-3.7.0/config/zookeeper.properties
echo -e $CLUSTER_NAME_COUNT > /mnt/kafka/zookeeper/data/myid 
