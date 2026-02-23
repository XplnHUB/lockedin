#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/../config.env"
source "$(dirname "${BASH_SOURCE[0]}")/colors.sh"

# Check if jq is installed
if ! command -v jq >/dev/null 2>&1; then
    echo "${RED}${BOLD}Error: 'jq' is not installed.${RESET}"
    echo "Please install it using: brew install jq (macOS) or sudo apt install jq (Linux)"
    exit 1
fi

# Ensure data directory and files exist
mkdir -p "$DATA_DIR"
[[ ! -f "$TASKS_DB" ]] && echo "[]" > "$TASKS_DB"
[[ ! -f "$PROJECTS_DB" ]] && echo "[]" > "$PROJECTS_DB"

# Get next ID for a table
get_next_id() {
    local table_file=$1
    if [[ ! -f "$table_file" ]] || [[ $(cat "$table_file") == "[]" ]]; then
        echo 1
    else
        jq 'max_by(.id).id + 1' "$table_file"
    fi
}

# Add a record to a table
db_add() {
    local table_file=$1
    local json_obj=$2
    local temp_file=$(mktemp)
    
    jq ". += [$json_obj]" "$table_file" > "$temp_file" && mv "$temp_file" "$table_file"
}

# Update a record in a table by ID
db_update() {
    local table_file=$1
    local id=$2
    local updates=$3 # jq update string, e.g., ".title = \"New Title\""
    local temp_file=$(mktemp)
    
    jq "map(if .id == $id then $updates else . end)" "$table_file" > "$temp_file" && mv "$temp_file" "$table_file"
}

# Delete a record from a table by ID
db_delete() {
    local table_file=$1
    local id=$2
    local temp_file=$(mktemp)
    
    jq "del(.[] | select(.id == $id))" "$table_file" > "$temp_file" && mv "$temp_file" "$table_file"
}

# Find a record by ID
db_find_by_id() {
    local table_file=$1
    local id=$2
    jq ".[] | select(.id == $id)" "$table_file"
}

# List all records
db_list_all() {
    local table_file=$1
    jq "." "$table_file"
}
