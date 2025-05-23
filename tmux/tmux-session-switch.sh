#!/bin/sh
idx=$1
session=$(tmux list-sessions -F '#S' | sed -n "${idx}p")
if [ -n "$session" ]; then
  tmux switch-client -t "$session"
else
  tmux display-message "没有第${idx}个session"
fi
