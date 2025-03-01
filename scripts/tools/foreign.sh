#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"

list_foreign() {
    echo "==> Foreign files in ${CBP_HOME}/:"
    # Create temp file to store known files
    local temp_known=$(mktemp)
    trap 'rm -f ${temp_known}' EXIT

    # Collect files from installed packages
    if [ -d "${CBP_BINARIES}" ]; then
        cat "${CBP_BINARIES}"/*.files > "${temp_known}" 2>/dev/null
    fi

    # Find and display files not in known list
    find_files "${CBP_HOME}" | while read -r file; do
        if [[ "$file" != "bin/cbp" ]] && 
           [[ ! "$file" =~ ^binaries/ ]] && 
           [[ ! "$file" =~ ^cache/ ]] && 
           ! grep -Fxq "$file" "${temp_known}"; then
            echo "  $file"
        fi
    done
    echo
}

# Run the function
list_foreign
