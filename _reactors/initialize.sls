initialize_orchestration:
  runner.state.orchestrate:
    - args:
      - mods: _orchestration.initialize
      - pillar:
          minion: {{ data['id'] }}