# styles.sh
# author: D.A.Pelasgus

#!/bin/bash

# ANSI escape codes for styling
BOLD='\033[1m'
RESET='\033[0m'
PURPLE='\033[95m'

# Function for styling text
style_text() {
    echo -e "${BOLD}${PURPLE}$1${RESET}"
}
