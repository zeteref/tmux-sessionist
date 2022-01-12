#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

# global vars passed to the script as arguments
CURRENT_SESSION_NAME="$1"
CURRENT_PANE_ID="$2"
PANE_CURRENT_PATH="$3"
SESSION_NAME="$(basename "$PANE_CURRENT_PATH")"

number_of_panes() {
	tmux list-panes -s -t "$CURRENT_SESSION_NAME" |
		wc -l |
		tr -d ' '
}

create_new_session() {
	TMUX="" tmux -S "$(tmux_socket)" new-session -c "$PANE_CURRENT_PATH" -d -s "$SESSION_NAME"
}

new_session_pane_id() {
	local session_name="$1"
	tmux list-panes -t "$session_name" -F "#{pane_id}"
}

promote_pane() {
    create_new_session
	local new_session_pane_id="$(new_session_pane_id "$SESSION_NAME")"
	tmux join-pane -s "$CURRENT_PANE_ID" -t "$new_session_pane_id"
	tmux kill-pane -t "$new_session_pane_id"
	switch_to_session "$SESSION_NAME"
}

main() {
    if session_exists_exact; then
        switch_to_session "$SESSION_NAME"
        display_message "Switched to existing session ${SESSION_NAME}" "2000"
    else
        if [ "$(number_of_panes)" -gt 1 ]; then
            promote_pane
        else
            display_message "Can't promote with only one pane in session"
        fi
    fi
}
main
