start_nginx:
  service.running:
    - name: nginx
    - enable: True