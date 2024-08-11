install_net_tools:
  pkg.installed:
    - name: net-tools


create_first_jobs_script:
  file.managed:
    - name: /etc/profile.d/first_jobs.sh
    - source: salt://firstjobs/files/first_jobs.sh
    - user: root
    - group: root
    - mode: 755

set_executable:
  file.managed:
    - name: /etc/profile.d/first_jobs.sh
    - mode: 755
    - user: root
    - group: root
    - require:
      - file: create_first_jobs_script
