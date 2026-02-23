#!/bin/bash

MODULE_DIR=$(dirname "${BASH_SOURCE[0]}")
source "$MODULE_DIR/../utils/db.sh"
source "$MODULE_DIR/../utils/ui.sh"

manage_projects() {
    while true; do
        clear_screen
        show_header "Project Management"
        
        local action=$(select_option "Choose action" "View Projects" "Add Project" "Edit Project" "Delete Project" "Back")
        
        case "$action" in
            "View Projects")
                view_projects
                read -p "Press enter to continue..."
                ;;
            "Add Project")
                add_project
                ;;
            "Edit Project")
                edit_project
                ;;
            "Delete Project")
                delete_project
                ;;
            "Back")
                return
                ;;
        esac
    done
}

view_projects() {
    show_header "All Projects"
    printf "${CYAN}${BOLD}%-5s %-20s %-15s %-30s${RESET}\n" "ID" "Title" "Status" "Description"
    echo "--------------------------------------------------------------------------------"
    jq -r '.[] | "\(.id)\t\(.title)\t\(.status)\t\(.description)"' "$PROJECTS_DB" | while IFS=$'\t' read -r id title status desc; do
        local color=$RESET
        [[ "$status" == "completed" ]] && color=$GREEN
        printf "${color}%-5s %-20s %-15s %-30s${RESET}\n" "$id" "$title" "$status" "$desc"
    done
}

add_project() {
    show_header "Add New Project"
    read -p "Title: " title
    read -p "Description: " desc
    read -p "Repo URL: " repo
    
    local id=$(get_next_id "$PROJECTS_DB")
    local json=$(jq -n \
        --arg id "$id" \
        --arg title "$title" \
        --arg desc "$desc" \
        --arg repo "$repo" \
        '{id: ($id|tonumber), title: $title, description: $desc, repo: $repo, status: "active"}')
    
    db_add "$PROJECTS_DB" "$json"
    echo "${GREEN}Project added!${RESET}"
    sleep 1
}

edit_project() {
    view_projects
    read -p "Enter Project ID to edit: " id
    local project=$(db_find_by_id "$PROJECTS_DB" "$id")
    if [[ -z "$project" ]]; then
        echo "${RED}Project not found.${RESET}"
        sleep 1
        return
    fi
    
    read -p "New Title (leave blank to keep current): " title
    read -p "New Status (active/completed): " status
    
    local updates=""
    [[ -n "$title" ]] && updates+=".title = \"$title\" | "
    [[ -n "$status" ]] && updates+=".status = \"$status\" | "
    updates=${updates% | }
    
    if [[ -n "$updates" ]]; then
        db_update "$PROJECTS_DB" "$id" "$updates"
        echo "${GREEN}Project updated!${RESET}"
    fi
    sleep 1
}

delete_project() {
    view_projects
    read -p "Enter Project ID to delete: " id
    db_delete "$PROJECTS_DB" "$id"
    echo "${RED}Project deleted.${RESET}"
    sleep 1
}
