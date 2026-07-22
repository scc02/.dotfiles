#!/bin/sh
width=${1:-80%}
height=${2:-80%}
path=${3:-$PWD}
# 主 session + window id，保证不同 window 各用各的 scratch
raw_name=${4:-popup}
# tmux session 名不能含 : . 等，且 window_id 带 @，统一清洗
name=$(printf '%s' "$raw_name" | tr -c 'A-Za-z0-9_-' '_')
conf="${HOME}/.config/tmux/popup.conf"

tmux popup -d "$path" -xC -yC -w"$width" -h"$height" -E \
  "tmux -L popup -f '$conf' new-session -A -s '$name'"
