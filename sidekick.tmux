#!/usr/bin/env bash

ASSISTANTS=("claude" "codex" "opencode" "gemini-cli")
ASSISTANTS_LEN=${#ASSISTANTS[@]}

echo $ASSISTANTS_LEN
tmux bind-key n run-shell "echo '$(printf "%s\n" "${ASSISTANTS[@]}")' | fzf --tmux"
