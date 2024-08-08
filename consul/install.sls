{% set bind_machine_ip_addr = salt['cmd.run']('curl -s http://169.254.169.254/latest/meta-data/local-ipv4') %}

consul.directory.requirement:
  file.directory:
    - names:
      - /opt/consul/directory
      - /var/consul
      - /home/consul/www
      - /etc/consul.d/server
      - /etc/consul.d/bootstrap
    - makedirs: True

install_consul:
  cmd.run:
    - name:  wget -O /tmp/consul.zip  https://releases.hashicorp.com/consul/1.16.1/consul_1.16.1_linux_amd64.zip

extract_consul:
  cmd.run:
    - name: unzip /tmp/consul.zip
    - cwd: /tmp
    
move_consul:
  cmd.run:
    - name: mv /tmp/consul /usr/local/bin/ 

create_consul_user:
  user.present:
    - name: consul
    - system: True
    - home: /home/consul
    - shell: /bin/false

get_consul_service_file:
  file.managed:
    - user: root
    - group: root
    - makedirs: True
    - names:
      - /etc/systemd/system/consul.service:
        - source: salt://consul/files/consul.service


get_consul_run_sh_file:
  file.managed:
    - user: root
    - group: root
    - makedirs: True
    - names:
      - /tmp/consul-run.sh:
        - source: salt://consul/files/consul-run.sh