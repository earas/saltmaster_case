grafana_repo:
  pkgrepo.managed:
    - humanname: "Grafana YUM Repository"
    - name: "grafana"
    - baseurl: "https://packages.grafana.com/oss/rpm"
    - file: /etc/yum.repos.d/grafana.repo
    - gpgcheck: 1
    - gpgkey: "https://packages.grafana.com/gpg.key"
    - enabled: 1

grafana_package:
  pkg.installed:
    - name: grafana
    - refresh: True
    - require:
      - pkgrepo: grafana_repo