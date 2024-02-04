# python.sh
# author: D.A.Pelasgus

#!/bin/bash

# Check if Python is installed
if command -v python3 &>/dev/null; then
    echo "Python is already installed."
else
    # Install Python using a generic approach
    echo "Python not found. Installing Python..."

    if command -v apt-get &>/dev/null; then
        # Debian-based system (e.g., Ubuntu)
        sudo apt-get update
        sudo apt-get install -y python3
    elif command -v yum &>/dev/null; then
        # Red Hat-based system (e.g., Fedora)
        sudo yum install -y python3
    elif command -v pacman &>/dev/null; then
        # Arch Linux
        sudo pacman -S --noconfirm python
    elif command -v brew &>/dev/null; then
        # macOS with Homebrew
        brew install python
    elif command -v nix-shell &>/dev/null; then
        # NixOS
        nix-shell -p python3
    elif command -v flatpak &>/dev/null; then
        # Flatpak (requires flatpak to be installed)
        flatpak install flathub org.python.Python
    elif command -v choco &>/dev/null; then
        # Windows with Chocolatey (requires Chocolatey to be installed)
        choco install python --version 3.8.0
    else
        echo "Error: Unsupported system or package manager. Please install Python manually."
        exit 1
    fi
fi

# Run the Python script
python3 directory_setup.py
