start_consul_service:
  service.running:
    - name: consul
    - enable: True
    - watch:
      - file: /etc/systemd/system/consul.service

wait_till_up:
  cmd.run:
    - name: sleep 120

