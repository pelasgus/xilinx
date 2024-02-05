#!/bin/bash

# Import styles.sh
source ./styles.sh

style_text "Welcome to Xilinx Product Installer/Uninstaller"

# Ask the user whether to install or uninstall
style_text "Do you want to install or uninstall a Xilinx product? (Type 'install' or 'uninstall')"
read -p "Choice: " choice

if [ "$choice" = "install" ]; then
    style_text "Installing Xilinx product..."
    ./setup.sh  # Replace with the actual setup script name
elif [ "$choice" = "uninstall" ]; then
    style_text "Uninstalling Xilinx product..."
    ./uninstall.sh  # Replace with the actual cleanup script name
else
    style_text "Invalid choice. Please enter 'install' or 'uninstall'."
    exit 1
fi

style_text "Process completed."
