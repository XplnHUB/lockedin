#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/colors.sh"

clear_screen() {
    clear
}

show_banner() {
    echo "${CYAN}${BOLD}"
    echo "  _      ____   _____ _  ________ _____  _____ _   _ "
    echo " | |    / __ \ / ____| |/ /  ____|  __ \|_   _| \ | |"
    echo " | |   | |  | | |    | ' /| |__  | |  | | | | |  \| |"
    echo " | |   | |  | | |    |  < |  __| | |  | | | | | . \ |"
    echo " | |___| |__| | |____| . \| |____| |__| |_| |_| |\  |"
    echo " |______\____/ \_____|_|\_\______|_____/|_____|_| \_|"
    echo "${RESET}"
}

show_header() {
    local title=$1
    echo "${MAGENTA}${BOLD}=== $title ===${RESET}"
    echo ""
}

# Generic selection menu
# Usage: select_option "Prompt" "Option 1" "Option 2" ...
select_option() {
    local prompt=$1
    shift
    local options=("$@")
    
    if command -v fzf >/dev/null 2>&1; then
        printf "%s\n" "${options[@]}" | fzf --prompt="$prompt: " --height=10 --border --reverse
    else
        PS3="${BOLD}${prompt}> ${RESET}"
        select opt in "${options[@]}"; do
            if [[ -n "$opt" ]]; then
                echo "$opt"
                return
            fi
        done
    fi
}

notify() {
    local title=$1
    local message=$2
    if [[ "$OS_TYPE" == "Darwin" ]]; then
        osascript -e "display notification \"$message\" with title \"$title\""
    else
        if command -v notify-send >/dev/null 2>&1; then
            notify-send "$title" "$message"
        fi
    fi
}

# Format table-like output for CLI
print_table_row() {
    local color=$1
    shift
    local cols=("$@")
    printf "${color}"
    for col in "${cols[@]}"; do
        printf "%-20s " "$col"
    done
    printf "${RESET}\n"
}
