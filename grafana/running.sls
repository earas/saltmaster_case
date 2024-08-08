grafana_service:
  service.running:
    - name: grafana-server
    - enable: True
    - require:
      - pkg: grafana_package