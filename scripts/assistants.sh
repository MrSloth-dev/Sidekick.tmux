#!/usr/bin/env bash

set -uo pipefail

ASSISTANTS=("claude" "codex" "aider" "amazon_q" "copilot" "crush" "cursor" "gemini" "grok" "opencode" "qwen")
SESSION="sidekick"

get_active_pane() {
	for ai in "${ASSISTANTS[@]}"; do
		PANE_ID=$(tmux list-panes -F '#{pane_id} #{pane_current_command}' | grep -w "$ai" | awk '{print $1}')
		if [[ -n $PANE_ID ]]; then
			echo "$PANE_ID:$ai"
			return 0
		fi
	done
	return 1
}

get_sidekick_assistant() {
	if ! tmux has-session -t "$SESSION" 2>/dev/null; then
		return 1
	fi
	for ai in "${ASSISTANTS[@]}"; do
		if tmux list-windows -t "$SESSION" -F '#{window_name}' | grep -q "^${ai}$"; then
			echo "$ai"
			return 0
		fi
	done
	return 1
}

prompt_fzf() {
	for ai in "${ASSISTANTS[@]}"; do
		if command -v "$ai" &>/dev/null; then
			echo "✓" "${ai}"
		else
			echo "⨉" "${ai}"
		fi
	done | fzf  --tmux --border-label='Available ' --header='Please select an assistant'
	}

main() {
	case "${1:-toggle}" in
		toggle)
			if ACTIVE=$(get_active_pane); then
				local PANE_ID="${ACTIVE%%:*}"
				local CMD="${ACTIVE#*:}"
				if ! tmux has-session -t "$SESSION" 2>/dev/null; then
					tmux new-session -d -s "$SESSION"
				fi
				tmux break-pane -d -n "$CMD" -s "$PANE_ID" -t "$SESSION"
			elif CMD=$(get_sidekick_assistant); then
				tmux join-pane -h -s "${SESSION}:${CMD}"
			else
				CHOSEN=$(prompt_fzf)
				if [[ -n $CHOSEN ]]; then
					CMD="${CHOSEN#* }"
					tmux split-window -dh -l 50% "$CMD"
				fi
			fi
			;;
		create)
			CHOSEN=$(prompt_fzf)
			if [[ -n $CHOSEN ]]; then
				local CMD="${CHOSEN#* }"
				tmux split-window -dh -l 50% "$CMD"
			fi
	esac
}

main
