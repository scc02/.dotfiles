#!/bin/sh
# Survives the default server exiting after the last session closes.
# Usage:
#   cleanup-popup.sh empty              — if no default sessions left, kill popup server
#   cleanup-popup.sh session <name>     — kill popup_* sessions for that main session
#   cleanup-popup.sh window <name>      — kill one popup scratch session by exact name

set -eu

mode=${1:-empty}

case "$mode" in
  window)
    name=${2:-}
    [ -n "$name" ] || exit 0
    tmux -L popup kill-session -t "=$name" 2>/dev/null || true
    ;;
  session)
    raw=${2:-}
    [ -n "$raw" ] || exit 0
    prefix=$(printf 'popup_%s_' "$raw" | tr -c 'A-Za-z0-9_-' '_')
    # trim trailing underscores from tr replacement on final char edge cases
    tmux -L popup list-sessions -F '#S' 2>/dev/null | while IFS= read -r s; do
      case "$s" in
        "$prefix"*) tmux -L popup kill-session -t "=$s" 2>/dev/null || true ;;
      esac
    done
    ;;
  empty|*)
    # Give the closing session a moment to disappear from the default server.
    sleep 0.2
    if ! tmux list-sessions >/dev/null 2>&1; then
      tmux -L popup kill-server 2>/dev/null || true
    fi
    ;;
esac
