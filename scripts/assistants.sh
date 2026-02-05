#!/usr/bin/env bash

set -uo pipefail

ASSISTANTS=("claude" "codex" "opencode" "gemini-cli")
SESSION="sidekick"
CREATE_MODE="${1:-split}"


CHOSEN=$(
	for ai in "${ASSISTANTS[@]}"; do
		if command -v "$ai" &>/dev/null; then
			echo "✓" $ai
		else
			echo "⨉" $ai
		fi
	done | fzf --tmux \
			   --border-label='Available ' \
			   --header='Please select an assistant'
		)

if [[ -n $CHOSEN ]]; then
	CMD="${CHOSEN#* }"
	PANE_ID=$(tmux list-panes -F '#{pane_id} #{pane_current_command}' | grep -w "$CMD" | awk '{print $1}')

	if [[ -n $PANE_ID ]]; then
		tmux break-pane -d -s "$PANE_ID" -t "$SESSION"
	else

		if ! tmux has-session -t  "$SESSION" 2>/dev/null; then
			tmux new-session -d -s "$SESSION" -n "$CMD" "$CMD"
		elif !tmux list-window -t "$SESSION" -F '#{window_name}' | grep -q "^${CMD}"; then
			tmux new-windows -t "$SESSION" -n "$CMD" "$CMD"
		fi

		case "$CREATE_MODE" in
			split)
				tmux join-pane -h -s "${SESSION}:${CMD}"
				;;
			window)
				tmux link-window -s "${SESSION}:${CMD}"
				;;
		esac
	fi
fi
