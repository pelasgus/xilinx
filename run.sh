#!/bin/bash

# Import styles.sh
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "$SCRIPT_DIR/styles/styles.sh"

# Function for error handling
handle_error() {
    local error_message="$1"
    style_error "$error_message"
    exit 1
}

# Check if script is running as root
if [ "$EUID" -ne 0 ]; then
  style_text "This script requires root privileges. Please enter your password when prompted."
  sudo -k  # Reset timestamp before prompting for password
  sudo "$0" "$@"  # Re-run the script with sudo
  exit $?
fi

# Make scripts executable
chmod +x "$SCRIPT_DIR/styles/styles.py" || handle_error "Failed to make styles.py executable"
chmod +x "$SCRIPT_DIR/styles/styles.sh" || handle_error "Failed to make styles.sh executable"
chmod +x "$SCRIPT_DIR/uninstall.sh" || handle_error "Failed to make uninstall.sh executable"
chmod +x "$SCRIPT_DIR/mac_cleanup.sh" || handle_error "Failed to make mac_cleanup.sh executable"
chmod +x "$SCRIPT_DIR/launcher_qemu.py" || handle_error "Failed to make launcher_qemu.py executable"
chmod +x "$SCRIPT_DIR/setup/setup_python.sh" || handle_error "Failed to make setup_python.sh executable"
chmod +x "$SCRIPT_DIR/setup/setup_directory.py" || handle_error "Failed to make setup_directory.py executable"
chmod +x "$SCRIPT_DIR/setup/setup_nix.py" || handle_error "Failed to make setup_nix.py executable"
chmod +x "$SCRIPT_DIR/setup/setup_qemu.py" || handle_error "Failed to make setup_qemu.py executable"
chmod +x "$SCRIPT_DIR/setup/setup_image.py" || handle_error "Failed to make setup_image.py executable"
chmod +x "$SCRIPT_DIR/setup/setup_compression_status.py" || handle_error "Failed to make setup_compression_status.py executable"
chmod +x "$SCRIPT_DIR/setup/flake_qemu.nix" || handle_error "Failed to make flake_qemu.nix executable"

style_text "Do you want to install or uninstall a Xilinx product? (Type 'install' or 'uninstall')"
read -p "Choice: " choice

if [ "$choice" = "install" ]; then
    style_text "Installing Xilinx product..."
    "$SCRIPT_DIR/setup/setup_python.sh" || handle_error "Failed to install Xilinx product"
elif [ "$choice" = "uninstall" ]; then
    style_text "Uninstalling Xilinx product..."
    "$SCRIPT_DIR/uninstall.sh" || handle_error "Failed to uninstall Xilinx product"
    "$SCRIPT_DIR/mac_cleanup.sh" || handle_error "Failed to perform Mac cleanup"
else
    style_text "Invalid choice. Please enter 'install' or 'uninstall'."
    exit 1
fi

style_text "Process completed."
