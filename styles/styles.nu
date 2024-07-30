# styles.nu
# author: D.A.Pelasgus

# ANSI escape codes for styling
let BOLD = "\033[1m"
let RESET = "\033[0m"
let PURPLE = "\033[95m"

# Function for styling text
def style_text [text] {
    echo $"($BOLD)($PURPLE)($text)($RESET)"
}
