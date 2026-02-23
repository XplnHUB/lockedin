#!/bin/bash

MODULE_DIR=$(dirname "${BASH_SOURCE[0]}")
# shellcheck source=./utils/db.sh
source "$MODULE_DIR/../utils/db.sh"
# shellcheck source=./utils/ui.sh
source "$MODULE_DIR/../utils/ui.sh"

show_stats() {
    clear_screen
    show_header "Statistics Dashboard"
    
    local total_tasks=$(jq 'length' "$TASKS_DB")
    local completed_tasks=$(jq '[.[] | select(.status == "done")] | length' "$TASKS_DB")
    local pending_tasks=$(jq '[.[] | select(.status == "pending")] | length' "$TASKS_DB")
    local overdue_tasks=$(jq --arg today "$(date +%Y-%m-%d)" '[.[] | select(.due_date < $today and .status == "pending")] | length' "$TASKS_DB")
    local total_projects=$(jq 'length' "$PROJECTS_DB")
    
    echo "${CYAN}${BOLD}Tasks Overview:${RESET}"
    echo "  Total:      $total_tasks"
    echo "  ${GREEN}Completed:  $completed_tasks${RESET}"
    echo "  ${YELLOW}Pending:    $pending_tasks${RESET}"
    echo "  ${RED}Overdue:    $overdue_tasks${RESET}"
    echo ""
    echo "${CYAN}${BOLD}Project Overview:${RESET}"
    echo "  Total:      $total_projects"
    echo ""
    
    read -p "Press enter to return to menu..."
}
