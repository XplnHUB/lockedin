#!/bin/bash

MODULE_DIR=$(dirname "${BASH_SOURCE[0]}")
# shellcheck source=./utils/db.sh
source "$MODULE_DIR/../utils/db.sh"
# shellcheck source=./utils/ui.sh
source "$MODULE_DIR/../utils/ui.sh"

manage_tasks() {
    while true; do
        clear_screen
        show_header "Task Management"
        
        local action
        action=$(select_option "Choose action" "View All Tasks" "Add Task" "Mark Task Done" "Delete Task" "Filter Tasks" "Back")
        
        case "$action" in
            "View All Tasks")
                view_tasks "all"
                read -p "Press enter to continue..."
                ;;
            "Add Task")
                add_task
                ;;
            "Mark Task Done")
                mark_task_done
                ;;
            "Delete Task")
                delete_task
                ;;
            "Filter Tasks")
                filter_tasks_menu
                ;;
            "Back")
                return
                ;;
        esac
    done
}

view_tasks() {
    local filter=$1
    local query="."
    
    case "$filter" in
        "today") query=".[] | select(.due_date == \"$(date +%Y-%m-%d)\")" ;;
        "overdue") query=".[] | select(.due_date < \"$(date +%Y-%m-%d)\" and .status == \"pending\")" ;;
        "pending") query=".[] | select(.status == \"pending\")" ;;
        "high") query=".[] | select(.priority == \"high\")" ;;
        *) query=".[]" ;;
    esac

    show_header "Tasks ($filter)"
    printf "${CYAN}${BOLD}%-5s %-25s %-12s %-10s %-10s %-10s${RESET}\n" "ID" "Title" "Due" "Pri" "Status" "Proj"
    echo "------------------------------------------------------------------------------------------"
    
    jq -r "$query | \"\(.id)\t\(.title)\t\(.due_date)\t\(.priority)\t\(.status)\t\(.project_id // \"N/A\")\"" "$TASKS_DB" | while IFS=$'\t' read -r id title due pri status proj; do
        local color=$RESET
        [[ "$status" == "done" ]] && color=$GREEN
        [[ "$pri" == "high" && "$status" == "pending" ]] && color=$RED
        printf "${color}%-5s %-25s %-12s %-10s %-10s %-10s${RESET}\n" "$id" "$title" "$due" "$pri" "$status" "$proj"
    done
}

add_task() {
    show_header "Add New Task"
    read -p "Title: " title
    read -p "Due Date (YYYY-MM-DD, default today): " due
    [[ -z "$due" ]] && due=$(date +%Y-%m-%d)
    
    local pri
    pri=$(select_option "Priority" "low" "medium" "high")
    
    # Optional Project Link
    local proj_id=""
    read -p "Link to Project ID (optional, press enter to skip): " proj_id
    
    local id=$(get_next_id "$TASKS_DB")
    local json=$(jq -n \
        --arg id "$id" \
        --arg title "$title" \
        --arg due "$due" \
        --arg pri "$pri" \
        --arg proj "$proj_id" \
        '{id: ($id|tonumber), title: $title, due_date: $due, priority: $pri, status: "pending", project_id: (if $proj == "" then null else ($proj|tonumber) end)}')
    
    db_add "$TASKS_DB" "$json"
    echo "${GREEN}Task added!${RESET}"
    notify "LockedIn" "Task added: $title"
    sleep 1
}

mark_task_done() {
    view_tasks "pending"
    read -p "Enter Task ID to mark as done: " id
    db_update "$TASKS_DB" "$id" ".status = \"done\""
    echo "${GREEN}Task marked as done!${RESET}"
    sleep 1
}

delete_task() {
    view_tasks "all"
    read -p "Enter Task ID to delete: " id
    db_delete "$TASKS_DB" "$id"
    echo "${RED}Task deleted.${RESET}"
    sleep 1
}

filter_tasks_menu() {
    local f
    f=$(select_option "Filter by" "Today" "Overdue" "High Priority" "Back")
    case "$f" in
        "Today") view_tasks "today"; read -p "Press enter..."; ;;
        "Overdue") view_tasks "overdue"; read -p "Press enter..."; ;;
        "High Priority") view_tasks "high"; read -p "Press enter..."; ;;
    esac
}
