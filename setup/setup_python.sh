#!/bin/bash
# python_installer.sh
# author: D.A.Pelasgus

# Absolute path to the directory containing this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to log messages
log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1"
}

# Function to install Python
install_python() {
    local python_version="$1"

    if command -v "$python_version" &>/dev/null; then
        log "Python $python_version is already installed."
    else
        log "Python $python_version not found. Installing Python $python_version..."

        if command -v apt-get &>/dev/null; then
            # Debian-based system (e.g., Ubuntu)
            sudo apt-get update && sudo apt-get install -y "$python_version"
        elif command -v yum &>/dev/null; then
            # Red Hat-based system (e.g., Fedora)
            sudo yum install -y "$python_version"
        elif command -v pacman &>/dev/null; then
            # Arch Linux
            sudo pacman -S --noconfirm "$python_version"
        elif command -v brew &>/dev/null; then
            # macOS with Homebrew
            brew install "$python_version"
        elif command -v nix-shell &>/dev/null; then
            # NixOS
            nix-shell -p "$python_version"
        elif command -v flatpak &>/dev/null; then
            # Flatpak (requires flatpak to be installed)
            flatpak install flathub "org.python.$python_version"
        elif command -v choco &>/dev/null; then
            # Windows with Chocolatey (requires Chocolatey to be installed)
            choco install python --version "$python_version"
        else
            log "Error: Unsupported system or package manager. Please install Python $python_version manually."
            exit 1
        fi

        # Check if Python installation was successful
        if ! command -v "$python_version" &>/dev/null; then
            log "Error: Python $python_version installation failed."
            exit 1
        fi
    fi
}

# Function to install additional packages
install_additional_packages() {
    log "Installing additional packages..."
    # Add commands to install additional packages here
}

# Main function
main() {
    local python_version="python3"  # Default Python version
    local install_additional=false

    # Parse command-line options
    while getopts ":v:a" opt; do
        case $opt in
            v)
                python_version="$OPTARG"
                ;;
            a)
                install_additional=true
                ;;
            \?)
                log "Invalid option: -$OPTARG"
                exit 1
                ;;
        esac
    done

    # Install Python
    install_python "$python_version"

    # Install additional packages if specified
    if [ "$install_additional" = true ]; then
        install_additional_packages
    fi

    # Run the Python script
    log "Running the Python script..."
    "$python_version" "$SCRIPT_DIR/setup_compression_status.py"
}

# Entry point
main "$@"