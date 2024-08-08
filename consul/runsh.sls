
wait_till_consul_up:
  cmd.run:
    - name: sleep 120

run_consul_token_sh:
  cmd.run:
    - name: bash consul-run.sh
    - cwd: /tmp
