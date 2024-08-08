export BIND_MACHINE_IP_ADDR=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

export CONSUL_HTTP_ADDR=$BIND_MACHINE_IP_ADDR:8500                             

export INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
export REGION=$(curl http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)
export NAME=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" --region $REGION --query "Tags[?Key=='Name'].Value" --output text)
export CLUSTER_NAME=$(echo $NAME | cut -d '-' -f 2-4)

if [ "$CLUSTER_NAME" == "consul-vault-0" ]; then

    consul acl bootstrap | sudo tee /tmp/consul.bootstrap                        

    export CONSUL_HTTP_TOKEN=$(sudo cat /tmp/consul.bootstrap | grep SecretID | awk '{print $2}')  

    echo -e 'service "vault" { policy = "write" }\nkey_prefix "vault/" { policy = "write" }\nagent_prefix "" { policy = "read" }\nsession_prefix "" { policy = "write" }' | sudo tee -a /tmp/vault-service-policy.hcl

    consul acl policy create -name vault-service -rules @vault-service-policy.hcl

    consul acl token create -description "Vault Service Token" -policy-name vault-service | sudo tee /tmp/consul.bootstrap.vault

    export CONSUL_VAULT_HTTP_TOKEN=$(sudo cat /tmp/consul.bootstrap.vault | grep SecretID | awk '{print $2}')  
    echo $CONSUL_VAULT_HTTP_TOKEN > /tmp/consul.vault.token

fi