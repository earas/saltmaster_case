prometheus_daemon_reload:
  cmd.run:
    - name: systemctl daemon-reload

prometheus_start_and_enable:
  cmd.run:
    - name: systemctl enable --now prometheus 

