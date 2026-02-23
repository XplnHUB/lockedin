#!/bin/bash

MODULE_DIR=$(dirname "${BASH_SOURCE[0]}")
# shellcheck source=./modules/task.sh
source "$MODULE_DIR/task.sh"

show_today() {
    clear_screen
    view_tasks "today"
    read -p "Press enter to return to menu..."
}
