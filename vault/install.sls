{% set bind_machine_ip_addr = salt['cmd.run']('curl -s http://169.254.169.254/latest/meta-data/local-ipv4') %}

vault.directory.requirement:
  file.directory:
    - names:
      - /opt/vault/directory
    - makedirs: True

install_vault:
  cmd.run:
    - name:  wget -O /tmp/vault.zip https://releases.hashicorp.com/vault/1.15.0/vault_1.15.0_linux_amd64.zip

extract_vault:
  cmd.run:
    - name: unzip /tmp/vault.zip
    - cwd: /tmp
    
move_vault:
  cmd.run:
    - name: mv /tmp/vault /usr/local/bin/ 

create_vault_user:
  user.present:
    - name: vault
    - system: True
    - home: /etc/vault.d
    - shell: /bin/false

get_vault_service_file:
  file.managed:
    - user: root
    - group: root
    - makedirs: True
    - names:
      - /etc/systemd/system/vault.service:
        - source: salt://vault/files/vault.service


get_vault_hcl_file:
  file.managed:
    - user: root
    - group: root
    - makedirs: True
    - names:
      - /etc/systemd/system/vault.service:
        - source: salt://vault/files/vault.service



get_vault_run_sh_file:
  file.managed:
    - user: root
    - group: root
    - makedirs: True
    - names:
      - /tmp/vault-run.sh:
        - source: salt://vault/files/vault-run.sh


