#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

main() {
    tmux command -I "$(tmux run-shell 'basename #{pane_current_path}')" -p "new session name:" "run '$CURRENT_DIR/new_session.sh \"%1\"'"
}
main
