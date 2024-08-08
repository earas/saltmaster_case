#/bin/bash
export BIND_MACHINE_IP_ADDR=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

export CONSUL_HTTP_ADDR=$BIND_MACHINE_IP_ADDR:8500                             
export CONSUL_HTTP_TOKEN=$(sudo cat /tmp/consul.bootstrap | grep SecretID | awk '{print $2}')  

export INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
export REGION=$(curl http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)
export NAME=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" --region $REGION --query "Tags[?Key=='Name'].Value" --output text)
export CLUSTER_NAME=$(echo $NAME | cut -d '-' -f 2-4)

if [ "$CLUSTER_NAME" == "consul-vault-0" ]; then
    export CONSUL_VAULT_HTTP_TOKEN=$(cat /tmp/consul.vault.token)
    echo 'storage consul { address = "127.0.0.1:8500" path = "vault/" token="$CONSUL_VAULT_HTTP_TOKEN" } listener tcp { address = "$BIND_MACHINE_IP_ADDR:8200" tls_disable = "1" }' |envsubst | sudo tee /etc/vault.d/config.hcl 
fi